//
//  TypographyExtension.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-18.
//
import Foundation

public extension Typography {

    var size: CGFloat {

        switch self {

        case .displayLarge:
            return 30

        case .displayMedium:
            return 24

        case .displaySmall:
            return 20

        case .headlineLarge:
            return 20

        case .headlineMedium:
            return 18

        case .headlineSmall:
            return 16

        case .titleLarge:
            return 19

        case .titleMedium:
            return 17

        case .titleSmall:
            return 15

        case .bodyLarge:
            return 20

        case .bodyMedium:
            return 16

        case .labelLarge:
            return 16

        case .labelMedium:
            return 14

        case .labelSmall:
            return 12
        }
    }
}
