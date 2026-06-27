//
//  Colors.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-10.
//

import SwiftUI

extension Color {

    @MainActor public static func theme() -> Theme {
        Theme(provider: ThemeManager.currentProvider())
    }

    @MainActor public static func alertTheme() -> AlertTheme {
        AlertTheme(provider: ThemeManager.currentProvider())
    }

    @MainActor public static func snackbarTheme() -> SnackbarTheme {
        SnackbarTheme(provider: ThemeManager.currentProvider())
    }
}
