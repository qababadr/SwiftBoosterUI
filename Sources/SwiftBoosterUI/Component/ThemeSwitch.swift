//
//  ThemeSwitch.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-05-29.
//

import SwiftUI

private struct IconToggleStyle<
    DarkIcon: View,
    LightIcon: View
>: ToggleStyle {

    let darkIcon: DarkIcon
    let lightIcon: LightIcon

    func makeBody(
        configuration: Configuration
    ) -> some View {

        HStack {

            configuration.label

            ZStack {

                Capsule()
                    .fill(
                        configuration.isOn
                        ? Color.theme().primary
                        : Color.gray.opacity(0.4)
                    )
                    .frame(width: 50, height: 30)

                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .overlay {
                        if configuration.isOn {
                            darkIcon
                        } else {
                            lightIcon
                        }
                    }
                    .offset(
                        x: configuration.isOn
                        ? 10
                        : -10
                    )
            }
            .accessibilityIdentifier("switch_theme")
            .animation(
                .easeOut(duration: 0.2),
                value: configuration.isOn
            )
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

public struct ThemeSwitch<DarkIcon: View, LightIcon: View>: View {

    @Binding
    private var isDarkTheme: Bool

    private let label: String
    private let onToggle: (Bool) -> Void

    private let darkIcon: DarkIcon
    private let lightIcon: LightIcon

    public init(
        isDarkTheme: Binding<Bool>,
        label: String = "",
        onToggle: @escaping (Bool) -> Void = { _ in },
        @ViewBuilder darkIcon: () -> DarkIcon,
        @ViewBuilder lightIcon: () -> LightIcon
    ) {
        _isDarkTheme = isDarkTheme
        self.label = label
        self.onToggle = onToggle
        self.darkIcon = darkIcon()
        self.lightIcon = lightIcon()
    }

    public var body: some View {

        Toggle(
            label,
            isOn: $isDarkTheme
        )
        .onChange(of: isDarkTheme) { value in
            onToggle(value)
        }
        .toggleStyle(
            IconToggleStyle(
                darkIcon: darkIcon,
                lightIcon: lightIcon
            )
        )
    }
}

private struct ThemeSwitchPreview: View {

    @State
    private var isDarkTheme: Bool = false

    var body: some View {
        ThemeSwitch(
            isDarkTheme: $isDarkTheme,
            label: "Theme"
        ) {
            Image(systemName: "moon.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
        } lightIcon: {
            Image(systemName: "sun.max.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
        }
    }
}

#Preview {
    ThemeSwitchPreview()
}
