//
//  SnackbarTheme.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-10-02.
//
import SwiftUI

extension Color {
    static let snackbarSuccessBackground = themedColor("Success")
    static let snackbarOnSuccessBackground = themedColor("OnPrimary")

    static let snackbarErrorBackground = themedColor("Error")
    static let snackbarOnErrorBackground = themedColor("OnPrimary")

    static let snackbarInfoBackground = themedColor("Info")
    static let snackbarOnInfoBackground = themedColor("OnPrimary")

    static let snackbarWarningBackground = themedColor("Warning")
    static let snackbarOnWarningBackground = themedColor("OnWarning")
    
    public static func snackbarBackgroundColor(_ severity: SnackbarSeverity) -> Color {
        return switch severity {
        case .success:
            .snackbarSuccessBackground
        case .error:
            .snackbarErrorBackground
        case .info:
            .snackbarInfoBackground
        case .warning:
            .snackbarWarningBackground
        }
    }
    
    public static func snackbarOnBackgroundColor(_ severity: SnackbarSeverity)
        -> Color
    {
        return switch severity {
        case .success:
            .snackbarOnSuccessBackground
        case .error:
            .snackbarOnErrorBackground
        case .info:
            .snackbarOnInfoBackground
        case .warning:
            .snackbarOnWarningBackground
        }
    }
}
