//
//  FileUploader.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-11.
//

import SwiftUI
import Photos
import UIKit

private enum PickerChoice {
    case files
    case photos
}


public struct FileUploader<ProgressView: View & SendableMetatype, IdleView: View & SendableMetatype>: View {
    // MARK: - Configuration
    private var acceptedExtensions: Set<String> = [".png", ".jpg", ".jpeg"]
    private var maxFilesUpload: Int = 5
    private var maxFileSize: Int64 = 0 // 0 = unlimited
    private var acceptMultipleFiles: Bool = true
    private var text: String = "Drag and drop files here"
    private var mimeTypeText: String = ""
    private var allowedContentTypes: [UTType] = [.data]
    private var progressView: ProgressView? = nil
    private var idleView: IdleView? = nil

    private var preUploadedFiles: [URL] = []

    // Async event handlers (equivalent to TaskCompletionSource)
    private var onUpload: ((URL) async -> Bool)?
    private var onDelete: ((URL) async -> Bool)?
    private var onFileClick: ((URL) -> Void)?
    private var onPreUploadedDelete: ((URL) async -> Bool)?
    private var onRejected: ((URL) -> Void)?
    private var onUploadError: ((URL) -> Void)?
    
    public init(
        acceptedExtensions: Set<String> = [".png", ".jpg", ".jpeg"],
        allowedContentTypes: [UTType] = [.data],
        maxFilesUpload: Int = 5,
        maxFileSize: Int64 = 0,
        acceptMultipleFiles: Bool = true,
        text: String = "Drag and drop files here",
        mimeTypeText: String = "",
        progressView: ProgressView? = EmptyView(),
        idleView: IdleView? = EmptyView(),
        preUploadedFiles: [URL] = [],
        onUpload: ((URL) async -> Bool)? = nil,
        onDelete: ((URL) async -> Bool)? = nil,
        onFileClick: ((URL) -> Void)? = nil,
        onPreUploadedDelete: ((URL) async -> Bool)? = nil,
        onRejected: ((URL) -> Void)? = nil,
        onUploadError: ((URL) -> Void)? = nil
    ) {
        self.acceptedExtensions = acceptedExtensions
        self.maxFilesUpload = maxFilesUpload
        self.maxFileSize = maxFileSize
        self.acceptMultipleFiles = acceptMultipleFiles
        self.text = text
        self.mimeTypeText = mimeTypeText
        self.preUploadedFiles = preUploadedFiles
        self.onUpload = onUpload
        self.onDelete = onDelete
        self.onFileClick = onFileClick
        self.onPreUploadedDelete = onPreUploadedDelete
        self.onRejected = onRejected
        self.onUploadError = onUploadError
        self.allowedContentTypes = allowedContentTypes
        self.progressView = progressView
        self.idleView = idleView
    }

    // MARK: - State

    @State private var uploadedFiles: [URL] = []
    @State private var isHighlightedValid = false
    @State private var isHighlightedInvalid = false
    @State private var isUploading = false
    @State private var showPickerMenu = false
    @State private var pickerChoice: PickerChoice?

    private var effectiveMaxFiles: Int {
        acceptMultipleFiles ? maxFilesUpload : 1
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 16) {

            ZStack {
                RoundedRectangle(cornerRadius: Theme.large)
                    .strokeBorder(
                        isHighlightedInvalid
                        ? Color.theme().error
                        : isHighlightedValid
                        ? Color.theme().primary
                        : Color.theme().secondary,
                        style: StrokeStyle(lineWidth: 3, dash: [6])
                    )
                    .background(Color.theme().background)
                    .animation(.easeInOut, value: isHighlightedValid)

                VStack(spacing: 12) {

                    if isUploading {
                        if progressView == nil {
                            Image(MediaResource.fileUpload,bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        } else {
                            progressView
                        }
                    } else {
                        if idleView == nil {
                            Image(MediaResource.fileUploadIdle,bundle: .module)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        } else {
                            idleView
                        }
                    }

                    Text(text)
                        .font(.typography(.headlineMedium, font: Roboto.regular))
                        .foregroundStyle(Color.theme().onBackground)

                    Text(mimeTypeText)
                        .font(.typography(.bodyMedium, font: Roboto.italic))
                        .italic()
                        .foregroundStyle(Color.theme().onBackground)
                }
                .padding(40)
            }
            .onTapGesture { showPickerMenu = true }
            .onDrop(of: [.fileURL], isTargeted: nil) { providers in
                handleDrop(providers: providers)
            }

            VStack(spacing: 8) {

                // Pre-uploaded
                ForEach(preUploadedFiles, id: \.self) { url in
                    fileRow(url: url, isPreUploaded: true)
                        .onTapGesture {
                            onFileClick?(url)
                        }
                }

                // Uploaded
                ForEach(uploadedFiles, id: \.self) { url in
                    fileRow(url: url, isPreUploaded: false)
                        .onTapGesture {
                            onFileClick?(url)
                        }
                }
            }
        }
        .fileImporter(
            isPresented: Binding(
                get: { pickerChoice == .files },
                set: { newValue in
                    if !newValue { pickerChoice = nil }
                }
            ),
            allowedContentTypes: allowedContentTypes,
            allowsMultipleSelection: acceptMultipleFiles
        ) { result in
            handleFilePicker(result)
            pickerChoice = nil
        }
        .sheet(isPresented: $showPickerMenu) {
            VStack(spacing: 16) {
                
                Button {
                    showPickerMenu = false
                    pickerChoice = .files
                } label: {
                    HStack {
                        Image(systemName: "folder.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                        
                        Text("Files")
                            .font(.typography(.bodyLarge, font: Roboto.regular))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme().primary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .tint(.theme().primary)
                }
                
                Button {
                    requestPhotoLibraryAccess { granted in
                        if granted {
                            Task { @MainActor in
                                showPickerMenu = false
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                pickerChoice = .photos
                            }
                        } else {
                            Task { @MainActor in
                                showPickerMenu = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    openAppSettings()
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Text("Photo library")
                            .font(.typography(.bodyLarge, font: Roboto.regular))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.theme().primary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .tint(.theme().primary)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .sheetHeight()
        }
#if canImport(UIKit)
        .sheet(
            isPresented: Binding(
                get: { pickerChoice == .photos },
                set: { newValue in
                    if !newValue { pickerChoice = nil }
                }
            )
        ) {
            ImagePicker(sourceType: UIImagePickerController.SourceType.photoLibrary) { image in
                if let url = saveImageToTempURL(image) {
                    Task { await processFile(url) }
                }
                pickerChoice = nil
            }
        }
#endif
    }
}

private extension FileUploader {

    func handleDrop(providers: [NSItemProvider]) -> Bool {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                guard
                    let data = item as? Data,
                    let url = URL(dataRepresentation: data, relativeTo: nil)
                else { return }

                Task { @MainActor in
                    await processFile(url)
                }
            }
        }
        return true
    }

    func handleFilePicker(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result else { return }

        for url in urls {
            Task {
                await processFile(url)
            }
        }
    }

    func processFile(_ url: URL) async {

        guard validate(url) else {
            onRejected?(url)
            return
        }

        if !acceptMultipleFiles, uploadedFiles.count == 1 {
            let old = uploadedFiles[0]

            if let onDelete, await !onDelete(old) {
                return
            }

            uploadedFiles.removeAll()
        }

        isUploading = true

        let success = await (onUpload?(url) ?? true)

        isUploading = false

        if !success {
            onUploadError?(url)
            return
        }

        withAnimation(.easeInOut) {
            uploadedFiles.append(url)
        }
    }
    
    func validate(_ url: URL) -> Bool {
        if uploadedFiles.count >= effectiveMaxFiles {
                return false
        }

        let ext = "." + url.pathExtension.lowercased()

        if pickerChoice == .files && !acceptedExtensions.contains(ext) {
            return false
        }
        
        if pickerChoice == .photos && !allowedContentTypes.contains(where: { url.conforms(to: $0) }) {
            return false
        }

        if maxFileSize > 0 {
            if let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize,
               Int64(size) > maxFileSize {
                return false
            }
        }

        return true
    }
    
    @ViewBuilder
    func fileRow(url: URL, isPreUploaded: Bool) -> some View {

        HStack {
            
            Image(url.imageResourceFormMime(), bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            
            Text(url.lastPathComponent)
                .font(.typography(.bodyMedium, font: Roboto.regular))
                .truncationMode(.tail)
                .lineLimit(1)
                .foregroundStyle(Color.theme().onBackground)

            Spacer()

            Button(role: .destructive) {
                Task {
                    if isPreUploaded {
                        if let onPreUploadedDelete,
                           await onPreUploadedDelete(url) {
                            // remove from parent state
                        }
                    } else {
                        if let onDelete,
                           await onDelete(url) {
                            uploadedFiles.removeAll { $0 == url }
                        }
                    }
                }
            } label: {
                Image(MediaResource.delete, bundle: .module)
            }
        }
        .padding()
        .background(Color.theme().background)
        .cornerRadius(Theme.medium)
    }
}

private extension URL {
    func mime() -> String {
        if let type = UTType(filenameExtension: self.pathExtension),
           let mime = type.preferredMIMEType {
            return mime
        }
        return "application/octet-stream"
    }
    
    func conforms(to type: UTType) -> Bool {
        if let fileUTType = UTType(filenameExtension: self.pathExtension) {
            return fileUTType.conforms(to: type)
        }
        return false
    }
    
    func imageResourceFormMime() -> String {
        if mime() == "image/jpeg" {
            return MediaResource.jpgSvgrepoCom
        }
        
        if mime() == "image/jpg" {
            return MediaResource.jpgSvgrepoCom
        }
        
        if mime() == "image/png" || mime() == "image/webp" {
            return MediaResource.pngSvgrepoCom
        }

        
        if mime() == "application/pdf" {
            return MediaResource.pdfSvgrepoCom
        }
        
       return ""
    }
}

#if canImport(UIKit)
@MainActor
private func openAppSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(url)
    }
}
#else
private func openAppSettings() {
    // Not supported on this platform
}
#endif

#if canImport(UIKit)
// MARK: - UIImagePickerController for iOS 15
private struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage { parent.onImagePicked(image) }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

private func saveImageToTempURL(_ image: UIImage) -> URL? {
    let data = image.jpegData(compressionQuality: 0.9)
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("\(UUID().uuidString).jpg")
    try? data?.write(to: url)
    return url
}
#endif

#Preview("Manual Testing") {

    struct DropZonePreviewWrapper: View {

        @State private var preUploaded: [URL] = [
            URL(string: "https://example.com/file1.png")!,
            URL(string: "https://example.com/file2.jpg")!,
            URL(string: "https://example.com/manual.pdf")!
        ]

        var body: some View {
            FileUploader(
                acceptedExtensions: [".png", ".jpg", ".jpeg", ".pdf"],
                maxFilesUpload: 3,
                maxFileSize: 5_000_000, // 5MB
                acceptMultipleFiles: true,
                text: "Drag & drop or tap to upload",
                mimeTypeText: "PNG, JPG, PDF • Max 5MB",
                preUploadedFiles: preUploaded,
                onUpload: { url in
                    print("Uploading:", url.lastPathComponent)

                    try? await Task.sleep(nanoseconds: 1_000_000_000)

                    // simulate random failure
                    let success = Bool.random()

                    print(success ? "Upload success" : "Upload failed")
                    return success
                },
                onDelete: { url in
                    print("Deleting uploaded:", url.lastPathComponent)

                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    return true
                },
                onFileClick: { url in
                    print("Showing the image or the file \(url)")
                },
                onPreUploadedDelete: { url in
                    print("Deleting pre-uploaded:", url.lastPathComponent)

                    try? await Task.sleep(nanoseconds: 1_000_000_000)

                    withAnimation(.easeInOut) {
                        preUploaded.removeAll { $0 == url }
                    }

                    return true
                },
                onRejected: { url in
                    print("Rejected file:", url.lastPathComponent)
                },
                onUploadError: { url in
                    print("Upload error:", url.lastPathComponent)
                }
            )
            .padding()
        }
    }

    return DropZonePreviewWrapper()
}

