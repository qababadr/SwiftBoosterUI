//
//  RadioButton.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-13.
//

import Foundation
import SwiftUI

public struct RadioButton<Content: View>: View {
    let selected: Bool
    let selectedColor: Color
    let unselectedColor: Color
    let text: Content
    let onClick: () -> Void

    @State private var animate: Bool = false

    public var body: some View {
        Button(action: {
            onClick()
            animate.toggle()
        }){
            HStack(alignment: .center) {
                circleView
                text
            }
        }.buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    private var circleView: some View {
        Circle()
            .fill(selected ? selectedColor : Color.clear)
            .scaleEffect(animate ? 1.2 : 1.0) // Scale effect for animation
            .animation(.easeInOut(duration: 0.15), value: animate)
            .padding(4)
            .overlay(
                Circle()
                    .stroke(selected ? selectedColor : Color.gray, lineWidth: 1)
            ).frame(width: 20, height: 20)
    }
}

#Preview {
    RadioButton(
        selected: true,
        selectedColor: .blue,
        unselectedColor: .gray.opacity(0.5),
        text: Text("Airline"),
        onClick: {}
    )
}
