//
//  AlertTheme.swift
//
//
//  Created by BADR QABA on 2024-10-19.
//

import Foundation
import SwiftUI

public struct AlertTheme {

    public let alertSuccessBg = ThemeProvider.color("AlertSuccessColor")
    public let alertSuccessAccentColor = ThemeProvider.color("AlertSuccessAccentColor")

    public let alertErrorBg = ThemeProvider.color("AlertErrorColor")
    public let alertErrorAccentColor = ThemeProvider.color("AlertErrorAccentColor")

    public let alertInfoBg = ThemeProvider.color("AlertInfoColor")
    public let alertInfoAccentColor = ThemeProvider.color("AlertInfoAccentColor")

    public let alertWarningBg = ThemeProvider.color("AlertWarningColor")
    public let alertWarningAccentColor = ThemeProvider.color("AlertWarningAccentColor")

    public let modernError = ThemeProvider.color("ModernAlertError")
    public let modernInfo = ThemeProvider.color("ModernAlertInfo")
    public let modernAlertDefaultAccent = ThemeProvider.color("AlertDefaultAccentColor")
    public let modernSuccess = ThemeProvider.color("ModernAlertSuccess")
    public let modernWarning = ThemeProvider.color("ModernAlertWarning")

    public func backgroundColor(_ type: AlertSeverity) -> Color {
        switch type {
        case .success:
            alertSuccessBg
        case .error:
            alertErrorBg
        case .info:
            alertInfoBg
        case .warning:
            alertWarningBg
        }
    }

    public func modernBackgroundColor(_ type: AlertSeverity) -> Color {
        switch type {
        case .success:
            modernSuccess
        case .error:
            modernError
        case .info:
            modernInfo
        case .warning:
            modernWarning
        }
    }

    public func alertAccentColor(_ type: AlertSeverity) -> Color {
        switch type {
        case .success:
            alertSuccessAccentColor
        case .error:
            alertErrorAccentColor
        case .info:
            alertInfoAccentColor
        case .warning:
            alertWarningAccentColor
        }
    }
}
