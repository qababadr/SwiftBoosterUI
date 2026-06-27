//
//  AlertModifier.swift
//
//
//  Created by BADR  QABA on 2024-10-19.
//

import Foundation
import SwiftUI

public extension Alert {
    func asClosable() -> Alert {
        var alert = Alert(
            isOpen: self.$isOpen,
            severity: self.severity,
            content: { self.content }
        )
        alert.closable.toggle()
        return alert
    }
    
    func alertBackgroundStyle(_ style: AlertBackgroundStyle) -> Self {
        var copy = self
        copy.alertStyle = style
        return copy
    }

    func modern() -> Self {
        alertBackgroundStyle(.modern)
    }

    func classic() -> Self {
        alertBackgroundStyle(.classic)
    }
}

