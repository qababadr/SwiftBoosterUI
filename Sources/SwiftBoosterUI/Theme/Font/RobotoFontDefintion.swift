//
//  RobotoFontDefintion.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-17.
//

public enum Roboto: String, CaseIterable, FontDescriptor {

    case bold = "roboto_bold"
    case italic = "roboto_italic"
    case regular = "roboto_regular"

    public var fontName: String {

        switch self {

        case .bold:
            return "Roboto-Bold"

        case .italic:
            return "Roboto-Italic"

        case .regular:
            return "Roboto-Regular"
        }
    }
}
