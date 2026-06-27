//
//  AlertBackgroundColor.swift
//
//
//  Created by BADR  QABA on 2024-10-19.
//

import Foundation
import SwiftUI

public extension Color {
    
    static let alertSuccessBg = themedColor("AlertSuccessColor")
    static let alertSuccessAccentColor = themedColor("AlertSuccessAccentColor")
    
    static let alertErrorBg = themedColor("AlertErrorColor")
    static let alertErrorAccentColor = themedColor("AlertErrorAccentColor")
    
    static let alertInfoBg = themedColor("AlertInfoColor")
    static let alertInfoAccentColor = themedColor("AlertInfoAccentColor")
    
    static let alertWarningBg = themedColor("AlertWarningColor")
    static let alertWarningAccentColor = themedColor("AlertWarningAccentColor")
    
    static let modernError = themedColor("ModernAlertError")
    static let modernInfo = themedColor("ModernAlertInfo")
    static let modernAlertDefaultAccent = themedColor("AlertDefaultAccentColor")
    static let modernSuccess = themedColor("ModernAlertSuccess")
    static let modernWarning = themedColor("ModernAlertWarning")
    
    static func backgroundColor(_ type: AlertSeverity) -> Color {
        return switch type {
        case .success:
                .alertSuccessBg
        case .error:
                .alertErrorBg
        case .info:
                .alertInfoBg
        case .warning:
                .alertWarningBg
        }
    }
    
    static func modernBackgroundColor(_ type: AlertSeverity) -> Color {
        return switch type {
        case .success:
                .modernSuccess
        case .error:
                .modernError
        case .info:
                .modernInfo
        case .warning:
                .modernWarning
        }
    }
    
    static func alertAccentColor(_ type: AlertSeverity) -> Color {
        return switch type {
        case .success:
                .alertSuccessAccentColor
        case .error:
                .alertErrorAccentColor
        case .info:
                .alertInfoAccentColor
        case .warning:
                .alertWarningAccentColor
        }
    }
}
