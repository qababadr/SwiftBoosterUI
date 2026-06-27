//
//  ThemeProvider.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-27.
//

public enum ThemeProvider {

    public static var color: (String) -> Color = {
        Color($0, bundle: .module)
    }

}
