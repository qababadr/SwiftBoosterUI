//
//  SnackbarTheme.swift
//  CoreUI
//
//  Created by BADR QABA on 2025-10-02.
//

import SwiftUI

public struct SnackbarTheme {

    public let snackbarSuccessBackground = ThemeProvider.color("Success")
    public let snackbarOnSuccessBackground = ThemeProvider.color("OnPrimary")

    public let snackbarErrorBackground = ThemeProvider.color("Error")
    public let snackbarOnErrorBackground = ThemeProvider.color("OnPrimary")

    public let snackbarInfoBackground = ThemeProvider.color("Info")
    public let snackbarOnInfoBackground = ThemeProvider.color("OnPrimary")

    public let snackbarWarningBackground = ThemeProvider.color("Warning")
    public let snackbarOnWarningBackground = ThemeProvider.color("OnWarning")

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
