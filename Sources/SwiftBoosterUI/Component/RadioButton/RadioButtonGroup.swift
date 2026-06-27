//
//  RadioButtonGroup.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-13.
//

import Foundation
import SwiftUI

public struct RadioButtonGroup<Content: View, Data: Codable & Hashable & Equatable>: View {
    
    public let options: [Data]
    public let selectedColor: Color
    public let unselectedColor: Color
    public let texts: [Content]
    public let onSelected: (Data) -> Void
    public let defaultSelectedOption: Data?
    
    public init(
        options: [Data],
        selectedColor: Color,
        unselectedColor: Color,
        texts: [Content],
        onSelected: @escaping (Data) -> Void = { _ in },
        defaultSelectedOption: Data? = nil
    ) {
        self.options = options
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.texts = texts
        self.onSelected = onSelected
        self.defaultSelectedOption = defaultSelectedOption
    }
    
    @State
    private var selectedOption: Data? = nil
    
    public var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(options.enumerated()), id: \.element) { index, option in
                RadioButton(
                    selected: selectedOption == option,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                    text: texts[index],
                    onClick: {
                        selectedOption = option
                        onSelected(option)
                    }
                )
            }
        }
        .onAppear {
            selectedOption = defaultSelectedOption
        }
    }
}

#Preview {
    RadioButtonGroup(
        options: ["Airline", "Airport"],
        selectedColor: .blue,
        unselectedColor: .gray.opacity(0.5),
        texts: [
            Text("Airline"),
            Text("Airport")
        ],
        defaultSelectedOption: "Airport"
    )
}
