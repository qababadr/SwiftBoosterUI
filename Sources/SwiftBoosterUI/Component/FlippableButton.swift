//
//  FlippableButton.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-24.
//

import SwiftUI

public enum FlipDirection {
    case DownToUp,
    UpToDown,
    RightToLeft,
    LeftToRight
}

public struct FlippableButton: View {
    
    let isFlipped: Bool
    let animationDuration: TimeInterval
    let iconColor: Color
    let imageResourceName: String?
    let systemName: String?
    let onClick: () -> Void
    let flipDirection: FlipDirection
    
    public init(
        isFlipped: Bool,
        animationDuration: TimeInterval = 0.15,
        iconColor: Color = .primary,
        imageResourceName: String? = nil,
        systemName: String? = nil,
        flipDirection: FlipDirection = .DownToUp,
        onClick: @escaping () -> Void
    ) {
        self.isFlipped = isFlipped
        self.animationDuration = animationDuration
        self.iconColor = iconColor
        self.onClick = onClick
        self.imageResourceName = imageResourceName
        self.systemName = systemName
        self.flipDirection = flipDirection
    }
    
    public var body: some View {
        let rotation: Double = isFlipped ? flipDirection.degrees : 0
        
        Button(action: {
            withAnimation(.easeIn(duration: animationDuration)){
                onClick()
            }
        }) {
            if let systemName = systemName {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(iconColor)
                    .rotationEffect(.degrees(rotation))
            } else {
                if let resource = imageResourceName {
                    Image(resource, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(iconColor)
                        .rotationEffect(.degrees(rotation))
                }
            }
            
        }
    }
}

private extension FlipDirection {
    var degrees: Double {
        switch self {
            
        case .DownToUp:
            180
        case .UpToDown:
            360
        case .RightToLeft:
            90
        case .LeftToRight:
            270
        }
    }
}
