//
//  Card.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-23.
//

import SwiftUI

public extension View {
    func cardStyle(shouldApplyStyle: Bool = true) -> some View {
        modifier(Card(shouldApplyStyle: shouldApplyStyle))
    }
}

public struct Card: ViewModifier {
    let shouldApplyStyle: Bool

    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical)
            .background(
                shouldApplyStyle ? Color.theme().surface : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
            .shadow(radius: shouldApplyStyle ? Theme.medium : 0)
            .padding(.top)
            .padding(.bottom, 6)
            .padding(.horizontal, 6)
    }
}
