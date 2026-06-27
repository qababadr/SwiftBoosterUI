//
//  NetworkImage.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//

import SwiftUI

import SwiftUI

public struct NetworkImage<LoadingView: View, ErrorView: View>: View {

    private let url: URL
    private let isCacheable: Bool
    private let withFadeInAnimation: Bool
    private let accessibilityIdentifier: String?
    private let errorPlaceHolder: ErrorView
    private let loadingPlaceHolder: LoadingView
    private let withTextError: Bool

    @State
    private var image: Image?
    
    @State
    private var isLoaded = false
    
    @State
    private var error: Error?

    private let downloader = ImageDownloader()

    public init(
        url: URL,
        isCacheable: Bool = false,
        withFadeInAnimation: Bool = true,
        accessibilityIdentifier: String? = nil,
        withTextError: Bool = false,
        @ViewBuilder errorPlaceHolder: () -> ErrorView = { EmptyView() },
        @ViewBuilder loadingPlaceHolder: () -> LoadingView = { EmptyView() }
    ) {
        self.url = url
        self.isCacheable = isCacheable
        self.withFadeInAnimation = withFadeInAnimation
        self.accessibilityIdentifier = accessibilityIdentifier
        self.errorPlaceHolder = errorPlaceHolder()
        self.loadingPlaceHolder = loadingPlaceHolder()
        self.withTextError = withTextError
    }

    public var body: some View {
        ZStack {
            if let image {
                image
                    .resizable()
                    .opacity(isLoaded ? 1 : 0)
                    .onAppear {
                        if withFadeInAnimation {
                            withAnimation(.easeIn(duration: 0.5)) {
                                isLoaded = true
                            }
                        } else {
                            isLoaded = true
                        }
                    }
            } else if error != nil {
                errorView
            } else {
                loadingView
            }
        }
        .task {
            await loadImage()
        }
        .accessibilityIdentifier(
            accessibilityIdentifier ?? url.absoluteString
        )
    }
}

private extension NetworkImage {

    func loadImage() async {
        do {
            
            if isCacheable {
                
                if let uiImage = try await downloader.cache(url: url) {
                    image = Image(uiImage: uiImage)
                    return
                } else {
                    error = URLError(.cannotDecodeContentData)
                }
            } else {
                // Direct network load
                //🌐 Image downloaded from network (cache skipped)
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data),
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    error = URLError(.cannotDecodeContentData)
                    return
                }
                image = Image(uiImage: uiImage)
            }
        } catch {
            self.error = error
        }
    }


    var loadingView: some View {
        Group {
            if loadingPlaceHolder is EmptyView {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                loadingPlaceHolder
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    var errorView: some View {
        Group {
            if errorPlaceHolder is EmptyView {
                VStack {
                    Spacer()
                    
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.theme().error)
                    
                    if withTextError {
                        Text(error?.localizedDescription ?? "Unknown error")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.theme().error)
                            .padding()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                errorPlaceHolder
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}


#Preview {
    if let url = URL(string: "https://www.gstatic.com/webp/gallery/1.webp") {
        NetworkImage(
            url: url,
            isCacheable: true
        )
        .scaledToFit()
    } else {
        Spacer()
    }
    
}
