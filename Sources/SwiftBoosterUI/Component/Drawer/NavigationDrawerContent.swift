//
//  NavigationDrawerContent.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-13.
//

import SwiftUI

public struct NavigationDrawerContent<Header: View, MainContent: View, Footer: View>: View {
    
    let header: Header
    let mainContent: MainContent
    let footer: Footer
    let backgroundColor: Color
    
    public init(
        backgroundColor: Color = .gray.opacity(0.2),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() },
        @ViewBuilder mainContent: @escaping () -> MainContent
    ) {
        self.header = header()
        self.mainContent = mainContent()
        self.footer = footer()
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    header
                    mainContent
                }
                Spacer()
                footer
            }
        }
    }
}

#Preview {
    NavigationDrawerContent(
        header: {
            Image(systemName: "homepod.and.appletv.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .foregroundColor(.blue)
                .padding()
        },
        footer: {
            Text("- About")
        }
    ) {
        VStack(alignment: .leading){
            Text("- Home")
            Text("- Explore")
            Text("- Info")
        }.padding()
    }
}
