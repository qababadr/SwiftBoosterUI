//
//  SwiftUIView.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-13.
//

import SwiftUI
import DotLottie

public struct LottieAnimation: View {
    
    public let fileName: String
    public let bundle: Bundle
    public let loop: Bool
    
    public init(
        fileName: String,
        bundle: Bundle = .main ,
        loop: Bool = true
    ) {
        self.fileName = fileName
        self.bundle = bundle
        self.loop = loop
    }
    
    public var body: some View {
        DotLottieAnimation(
            fileName: fileName,
            bundle: bundle,
            config: AnimationConfig(
                autoplay: true,
                loop: loop,
                useFrameInterpolation: false
            )
        )
        .view()
    }
}
