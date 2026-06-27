//
//  Theme.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-10.
//

import SwiftUI

public struct Theme {

    private let provider: ThemeProviding

    public init(provider: ThemeProviding = DefaultThemeProvider()) {
        self.provider = provider
    }

    public var background: Color { provider.color("Background") }
    public var error: Color { provider.color("ErrorDark") }
    public var errorDark: Color { provider.color("Error") }
    public var info: Color { provider.color("Info") }
    public var onBackground: Color { provider.color("OnBackground") }
    public var onPrimary: Color { provider.color("OnPrimary") }
    public var onSuccess: Color { provider.color("OnSuccess") }
    public var onSurface: Color { provider.color("OnSurface") }
    public var onWarning: Color { provider.color("OnWarning") }
    public var primary: Color { provider.color("Primary") }
    public var primaryLight: Color { provider.color("PrimaryLight") }
    public var primaryVariant: Color { provider.color("PrimaryVariant") }
    public var secondary: Color { provider.color("Secondary") }
    public var success: Color { provider.color("Success") }
    public var surface: Color { provider.color("Surface") }
    public var surfaceVariant: Color { provider.color("SurfaceVariant") }
    public var warning: Color { provider.color("Warning") }
    public var drawerBackground: Color { provider.color("DrawerBackground") }
    public var selectedDrawerItem: Color { provider.color("SelectedDrawerItem") }
    public var gradientBackground1: Color { provider.color("gradientBackground1") }
    public var gradientBackground2: Color { provider.color("gradientBackground2") }
    public var gradientBackground3: Color { provider.color("gradientBackground3") }
}
