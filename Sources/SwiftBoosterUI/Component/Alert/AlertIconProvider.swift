//
//  AlertIconProvider.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-15.
//

import Foundation

public protocol AlertIconProvider {
    func icon(for severity: AlertSeverity) -> String
    
    func bundle() -> Bundle?
}
