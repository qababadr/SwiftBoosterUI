//
//  StringExtension.swift
//  SwiftBoosterUI
//
//  Created by BADR  QABA on 2026-06-18.
//

import Foundation

extension String {
    public func localized(
        bundle: Bundle = .main,
        comment: String = "",
        _ arguments: any CVarArg...
    ) -> String {
        return String(
            format: NSLocalizedString(
                self,
                bundle: bundle,
                comment: comment
            ),
            arguments: arguments
        )
    }
}
