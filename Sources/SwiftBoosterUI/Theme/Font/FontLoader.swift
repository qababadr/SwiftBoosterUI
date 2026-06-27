//
//  FontLoader.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-17.
//

import CoreText
import SwiftUI

public protocol FontFamily: CaseIterable, RawRepresentable
where RawValue == String {

    var fontName: String { get }
}

public enum FontLoader {

    public static func register<T: FontFamily>(
        _ family: T.Type,
        bundle: Bundle = .SwiftBoosterUIBundle
    ) {

        T.allCases.forEach {
            register(
                bundle: bundle,
                fontName: $0.rawValue,
                fontExtension: "ttf"
            )
        }
    }

    private static func register(
        bundle: Bundle,
        fontName: String,
        fontExtension: String
    ) {

        guard
            let fontURL = bundle.url(
                forResource: fontName,
                withExtension: fontExtension
            ),
            let provider = CGDataProvider(
                url: fontURL as CFURL
            ),
            let font = CGFont(provider)
        else {
            fatalError(
                "Could not create font from file: \(fontName).\(fontExtension)"
            )
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(
            font,
            &error
        )
    }
}
