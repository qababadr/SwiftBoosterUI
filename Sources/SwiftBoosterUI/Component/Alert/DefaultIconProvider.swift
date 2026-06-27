//
//  DefaultIconProvider.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-15.
//

import Foundation

public struct DefaultIconProvider: AlertIconProvider {
    public init(){}
    
    public func icon(for severity: AlertSeverity) -> String {
        return switch severity {
        case .success:
                "checkmark.circle.fill"
        case .error:
                "exclamationmark.circle.fill"
        case .info:
                "info.circle.fill"
        case .warning:
                "exclamationmark.triangle.fill"
        }
    }
    
    public func bundle() -> Bundle? {
        nil
    }
}
