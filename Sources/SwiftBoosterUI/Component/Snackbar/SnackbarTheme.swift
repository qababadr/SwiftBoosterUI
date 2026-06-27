//
//  SnackbarTheme.swift
//  CoreUI
//
//  Created by BADR QABA on 2025-10-02.
//

import SwiftUI

public struct SnackbarTheme {

    private let provider: ThemeProviding

    public init(provider: ThemeProviding = DefaultThemeProvider()) {
        self.provider = provider
    }

    public var snackbarSuccessBackground: Color {
        provider.color("Success")
    }

    public var snackbarOnSuccessBackground: Color {
        provider.color("OnPrimary")
    }

    public var snackbarErrorBackground: Color {
        provider.color("Error")
    }

    public var snackbarOnErrorBackground: Color {
        provider.color("OnPrimary")
    }

    public var snackbarInfoBackground: Color {
        provider.color("Info")
    }

    public var snackbarOnInfoBackground: Color {
        provider.color("OnPrimary")
    }

    public var snackbarWarningBackground: Color {
        provider.color("Warning")
    }

    public var snackbarOnWarningBackground: Color {
        provider.color("OnWarning")
    }

    public func snackbarBackgroundColor(_ severity: SnackbarSeverity) -> Color {
        switch severity {
        case .success:
            snackbarSuccessBackground
        case .error:
            snackbarErrorBackground
        case .info:
            snackbarInfoBackground
        case .warning:
            snackbarWarningBackground
        }
    }

    public func snackbarOnBackgroundColor(_ severity: SnackbarSeverity) -> Color {
        switch severity {
        case .success:
            snackbarOnSuccessBackground
        case .error:
            snackbarOnErrorBackground
        case .info:
            snackbarOnInfoBackground
        case .warning:
            snackbarOnWarningBackground
        }
    }
}
