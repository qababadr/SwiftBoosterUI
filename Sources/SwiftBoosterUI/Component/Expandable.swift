//
//  Expandable.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-24.
//

import SwiftUI

public struct Expandable<Title: View, Content: View>: View {
    
    let isExpanded: Bool
    let onExpand: (() -> Void)?
    let title: Title
    let iconColor: Color
    let iconSize: CGFloat
    let animationDuration: TimeInterval
    let content: Content
    let imageResource: String?
    let systemName: String?
    
    public init(
        isExpanded: Bool,
        onExpand: (() -> Void)? = nil,
        @ViewBuilder title: @escaping () -> Title,
        iconColor: Color = .primary,
        iconSize: CGFloat = 16,
        animationDuration: TimeInterval = 0.15,
        imageResource: String? = nil,
        systemName: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isExpanded = isExpanded
        self.onExpand = onExpand
        self.title = title()
        self.iconColor = iconColor
        self.animationDuration = animationDuration
        self.content = content()
        self.imageResource = imageResource
        self.systemName = systemName
        self.iconSize = iconSize
    }
    
    public var body: some View {
        VStack {
            HStack(alignment: .center) {
                title
                
                Spacer()
                
                if let resource = imageResource {
                    FlippableButton(
                        isFlipped: isExpanded,
                        iconColor: iconColor,
                        imageResourceName: resource,
                        flipDirection: .DownToUp,
                        onClick: {
                            onExpand?()
                        }
                    )
                    .frame(width: iconSize)
                    .padding(.trailing, isExpanded ? 12 : 8)
                    
                } else {
                    if let systemName = systemName {
                        FlippableButton(
                            isFlipped: isExpanded,
                            iconColor: iconColor,
                            systemName: systemName,
                            flipDirection: .DownToUp,
                            onClick: {
                                onExpand?()
                            }
                        )
                        .frame(width: iconSize)
                        .padding(.trailing, isExpanded ? 12 : 8)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            if isExpanded {
                content
                    .transition(.scale(scale: 1, anchor: .zero))
                    .animation(.easeInOut(duration: animationDuration), value: isExpanded)
            }
        }
    }
}
