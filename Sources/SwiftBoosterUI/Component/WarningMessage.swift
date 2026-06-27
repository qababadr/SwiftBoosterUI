//
//  WarningMessage.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-05-29.
//

import SwiftUI

public struct WarningMessage: View {
    private let text: String
    private let iconName: String
    private let verticalAlignment: VerticalAlignment

    public init(
        text: String,
        iconName: String,
        verticalAlignment: VerticalAlignment = .center
    ) {
        self.text = text
        self.iconName = iconName
        self.verticalAlignment = verticalAlignment
    }

    public var body: some View {
        HStack(alignment: verticalAlignment, spacing: 8) {
            Image(iconName, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundColor(.theme().onPrimary)

            Text(text)
                .font(.typography(.bodyMedium, font: Roboto.regular))
                .foregroundColor(.theme().onPrimary)
                .multilineTextAlignment(.leading)
        }
    }
}

private struct WarningMessagePreview: View {
    var body: some View {
        WarningMessage(
            text: "Its seems that your wishlist is empty",
            iconName: "information"
        )
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.theme().warning)
        .clipShape(RoundedRectangle(cornerRadius: Theme.medium))
        .padding()
        .shadow(radius: Theme.medium)
    }
}

#Preview {
    WarningMessagePreview()
}
