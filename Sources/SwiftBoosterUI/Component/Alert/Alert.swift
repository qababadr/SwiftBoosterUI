//
//  Alert.swift
//
//
//  Created by BADR  QABA on 2024-10-19.
//

import SwiftUI

public struct Alert<Content: View>: View {
    
    public let content: Content
    public let severity: AlertSeverity
    public var closable: Bool = false
    private let iconProvider: AlertIconProvider
    
    @Binding
    public var isOpen: Bool
    
    var alertStyle: AlertBackgroundStyle = .modern
    
    public init(
        isOpen: Binding<Bool>,
        severity: AlertSeverity,
        iconProvider: AlertIconProvider = DefaultIconProvider(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
        self._isOpen = isOpen
        self.severity = severity
        self.iconProvider = iconProvider
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if isOpen {
                HStack(alignment: .top) {
                    if iconProvider.bundle() == nil {
                        Image(systemName: iconProvider.icon(for: severity))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(
                                alertStyle == .modern ? .modernAlertDefaultAccent :
                                        .alertAccentColor(severity)
                            )
                            .padding(.leading, 8)
                            .padding(.vertical, 8)
                    } else {
                        Image(iconProvider.icon(for: severity), bundle: iconProvider.bundle())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(
                                alertStyle == .modern ? .modernAlertDefaultAccent :
                                        .alertAccentColor(severity)
                            )
                            .padding(.leading, 8)
                            .padding(.vertical, 8)
                    }

                    content.frame(alignment: .leading)

                    Spacer()

                    if closable {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isOpen.toggle()
                            }
                        }){
                            Image(systemName: "xmark.app.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(
                                    alertStyle == .modern ? .modernAlertDefaultAccent :
                                            .alertAccentColor(severity)
                                )
                        }
                        .padding(.all, 8)
                    }
                }
                .background {
                    switch alertStyle {
                    case .modern:
                        Color.modernBackgroundColor(severity)
                    case .classic:
                        Color.backgroundColor(severity)
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isOpen)
    }
}

#Preview("Alert Preview") {
    struct PreviewWrapper: View {
        
        @State
        private var isOpen = false
        
        var body: some View {
            VStack {
                Alert(
                    isOpen: $isOpen,
                    severity: .success,
                ) {
                    Text("""
                         ✅ When You Should Use AlertIconProvider
                         1️⃣ When building a Design System / UI Library (like your CoreUI)

                         If Alert is part of a reusable framework, and:

                         Different apps want different icons

                         Or different brands use different icon sets

                         Or some apps use SF Symbols, others use custom asset names

                         Then a protocol is perfect.
                        """)
                        .foregroundColor(.white)
                        .padding(.all, 8)
                }
                .asClosable()
                .cornerRadius(6)
                .padding()
                
                Button(action: { withAnimation { isOpen = true } }) {
                    Text("Show alert")
                }
            }
        }
    }
    
    return PreviewWrapper()
}

