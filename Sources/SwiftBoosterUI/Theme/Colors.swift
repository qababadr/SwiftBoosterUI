//
//  Colors.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-10.
//

import SwiftUI

extension Color {

    public static func theme() -> Theme {
        return Theme()
    }
    
    static func themedColor(_ name: String) -> Color {
#if SWIFT_PACKAGE
        if UIColor(named: name) != nil {
            return Color(name)               // App's Assets.xcassets
        }

        return Color(name, bundle: .module)  // Package fallback
#else
        return Color(name)
#endif
    }
}
