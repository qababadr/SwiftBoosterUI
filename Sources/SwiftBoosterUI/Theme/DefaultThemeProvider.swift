//
//  DefaultThemeProvider.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-27.
//

import SwiftUI

public struct DefaultThemeProvider: ThemeProviding {

    public init() {}

    public func color(_ name: String) -> Color {
        Color(name, bundle: .module)
    }

}
