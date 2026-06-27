//
//  ConditionalSheetDetents.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-16.
//

import SwiftUI

public extension View {
    func sheetHeight(height: CGFloat = 220) -> some View {
        modifier(ConditionalSheetDetents(height: height))
    }
}

private struct ConditionalSheetDetents: ViewModifier {
    let height: CGFloat
    
    public init(height: CGFloat = 220) {
        self.height = height
    }
    
    public func body(content: Content) -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            content
                .presentationDetents([.height(height), .large])
                .presentationDragIndicator(.visible)
        } else {
            content
        }
    }
}
