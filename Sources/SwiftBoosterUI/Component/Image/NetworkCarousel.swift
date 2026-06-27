//
//  NetworkCarousel.swift
//  CoreUI
//

import SwiftUI
import Combine

public struct NetworkCarousel: View {
    
    private let urls: [URL]
    private let timeout: Double
    private let cornerRadius: CGFloat
    private let isCacheable: Bool
    
    @State
    private var isAutoPlay: Bool
    
    @State
    private var selection = 0
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(
            every: timeout,
            on: .main,
            in: .common
        )
        .autoconnect()
    }

    public init(
        urls: [URL],
        isCacheable: Bool = false,
        timeout: Double = 4,
        cornerRadius: CGFloat = 4,
        isAutoPlay: Bool = true
    ) {
        self.urls = urls
        self.isCacheable = isCacheable
        self.timeout = timeout
        self.cornerRadius = cornerRadius
        self._isAutoPlay = State(initialValue: isAutoPlay)
    }

    public var body: some View {
        TabView(selection: $selection) {
            ForEach(Array(urls.enumerated()), id: \.offset) { index, url in
                NetworkImage(
                    url: url,
                    isCacheable: isCacheable
                )
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        .onReceive(timer) { _ in
            guard isAutoPlay, urls.count > 1 else { return }
            
            withAnimation {
                selection = (selection + 1) % urls.count
            }
        }
        .gesture(
            DragGesture()
                .onChanged { _ in
                    isAutoPlay = false
                }
                .onEnded { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isAutoPlay = true
                    }
                }
        )
    }
}
