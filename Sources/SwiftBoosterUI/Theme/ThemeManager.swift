//
//  ThemeManager.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-27.
//

@MainActor
public enum ThemeManager {

    private static var provider: ThemeProviding = DefaultThemeProvider()

    public static func setProvider(_ provider: ThemeProviding) {
        self.provider = provider
    }

    public static func currentProvider() -> ThemeProviding {
        provider
    }
}
