//
//  AlertTheme.swift
//
//
//  Created by BADR QABA on 2024-10-19.
//

import Foundation
import SwiftUI

public struct AlertTheme {

    private let provider: ThemeProviding

    public init(provider: ThemeProviding = DefaultThemeProvider()) {
        self.provider = provider
    }

    public var alertSuccessBg: Color {
        provider.color("AlertSuccessColor")
    }

    public var alertSuccessAccentColor: Color {
        provider.color("AlertSuccessAccentColor")
    }

    public var alertErrorBg: Color {
        provider.color("AlertErrorColor")
    }

    public var alertErrorAccentColor: Color {
        provider.color("AlertErrorAccentColor")
    }

    public var alertInfoBg: Color {
        provider.color("AlertInfoColor")
    }

    public var alertInfoAccentColor: Color {
        provider.color("AlertInfoAccentColor")
    }

    public var alertWarningBg: Color {
        provider.color("AlertWarningColor")
    }

    public var alertWarningAccentColor: Color {
        provider.color("AlertWarningAccentColor")
    }

    public var modernError: Color {
        provider.color("ModernAlertError")
    }

    public var modernInfo: Color {
        provider.color("ModernAlertInfo")
    }

    public var modernAlertDefaultAccent: Color {
        provider.color("AlertDefaultAccentColor")
    }

    public var modernSuccess: Color {
        provider.color("ModernAlertSuccess")
    }

    public var modernWarning: Color {
        provider.color("ModernAlertWarning")
    }

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
