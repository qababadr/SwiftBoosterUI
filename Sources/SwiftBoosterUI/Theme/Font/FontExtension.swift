//
//  FontExtension.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-17.
//

import SwiftUI

public protocol FontDescriptor: CaseIterable, RawRepresentable
where RawValue == String {

    var fontName: String { get }
}

public extension Font {

    static func typography<T: FontDescriptor>(
        _ typography: Typography,
        font: T
    ) -> Font {

        .custom(
            font.fontName,
            size: typography.size
        )
    }
}
