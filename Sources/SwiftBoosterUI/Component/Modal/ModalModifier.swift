//
//  ModalModifier.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-06-14.
//

import SwiftUI

public struct ModalModifier: ViewModifier {
    
    @EnvironmentObject
    private var modalController: ModalController

    public init() {}

    public func body(content: Content) -> some View {
        ZStack {
            content

            if modalController.isPresented,
                let modalContent = modalController.content
            {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(10)

                modalContent
                    .background(Color.theme().background)
                    .cornerRadius(Theme.medium)
                    .shadow(radius: 8)
                    .padding()
                    .zIndex(11)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: modalController.isPresented)
    }
}

extension View {
    public func modalHost() -> some View {
        self.modifier(ModalModifier())
    }
}
