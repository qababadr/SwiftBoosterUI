//
//  DownloadIndicator.swift
//  SupportDocumentFeature
//
//  Created by BADR  QABA on 2026-02-19.
//

import SwiftUI

public struct DownloadIndicator<SuccessView: View>: View  {
    
    private let progress: Double
    private let fileName: String
    private let downloadedLabel: String
    private let downloadingLabel: String
    private let openFileLabel: String
    private let onOpen: (() -> Void)?
    private let successView: SuccessView
    
    public init(
        progress: Double,
        fileName: String,
        downloadedLabel: String = "Downloaded",
        downloadingLabel: String = "Downloading...",
        openFileLabel: String = "Open file",
        onOpen: (() -> Void)?,
        @ViewBuilder successView: () -> SuccessView
    ) {
        self.progress = progress
        self.fileName = fileName
        self.onOpen = onOpen
        self.downloadingLabel = downloadingLabel
        self.downloadedLabel = downloadedLabel
        self.openFileLabel = openFileLabel
        self.successView = successView()
    }
    
    var isCompleted: Bool {
        progress >= 100
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            
            ZStack {
                if !isCompleted {
                    
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(.circular)
                        .scaleEffect(3)
                    
                    Text("\(Int(progress))%")
                        .font(.typography(.labelSmall, font: Roboto.regular))
                        .offset(y: 2)
                    
                } else {
                    successView
                }
            }
            
            Text(isCompleted ? downloadedLabel : downloadingLabel)
                .font(.typography(.bodyMedium, font: Roboto.bold))
                .foregroundStyle(Color.theme().onBackground)
            
            if !isCompleted {
                Text(fileName)
                    .font(.typography(.bodyMedium, font: Roboto.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.theme().onBackground)
            } else {
                Button(action: {
                    onOpen?()
                }) {
                    Text(openFileLabel)
                        .font(.typography(.bodyMedium, font: Roboto.bold))
                        .underline()
                        .foregroundStyle(Color.theme().primary)
                }
            }
        }
    }
}

#Preview("Download Progress indicator preview") {
    struct PreviewWrapper: View {
        
        @State
        private var progress: Double = 0
        
        @State
        private var timer: Timer?
        
        var body: some View {
            VStack(spacing: 30) {
                DownloadIndicator(
                    progress: progress,
                    fileName: "Support_Document.pdf",
                    onOpen: {
                        print("Open file tapped")
                    }
                ) {
                    Image(systemName: "checkmark.circle.fill")
                           .font(.system(size: 60))
                }
                
                HStack {
                    Button("Start") {
                        startFakeDownload()
                    }
                    
                    Button("Reset") {
                        stopTimer()
                        progress = 0
                    }
                }
            }
        }
        
        private func startFakeDownload() {
            stopTimer()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                Task { @MainActor in
                    if progress >= 100 {
                        stopTimer()
                    } else {
                        progress += 1
                    }
                }
            }
        }
            
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
    }
    return PreviewWrapper()
}
