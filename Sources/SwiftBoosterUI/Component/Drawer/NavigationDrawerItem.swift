//
//  NavigationDrawerItem.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-13.
//

import SwiftUI

public struct NavigationDrawerItem: View {
    
    let itemColor: Color
    let text: String
    let selectedColor: Color
    let isSelected: Bool
    let onClick: () -> Void
    let iconSize: CGFloat
    let font: Font?
    let imageResourceName: String?
    let systemName: String?
    
    public init(
        text: String,
        itemColor: Color = .blue,
        selectedColor: Color = .blue.opacity(0.5),
        isSelected: Bool,
        onClick: @escaping () -> Void,
        iconSize: CGFloat = 26,
        font: Font? = .title,
        imageResourceName: String? = nil,
        systemName: String? = nil
    ) {
        self.itemColor = itemColor
        self.text = text
        self.selectedColor = selectedColor
        self.isSelected = isSelected
        self.onClick = onClick
        self.iconSize = iconSize
        self.font = font
        self.imageResourceName = imageResourceName
        self.systemName = systemName
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            
            if let systemName = systemName {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize)
                    .foregroundColor(isSelected ? selectedColor : itemColor)
                    .padding(.trailing, 4)
                
            } else {
                if let resource = imageResourceName {
                    Image(resource, bundle: .module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize)
                        .foregroundColor(isSelected ? selectedColor : itemColor)
                        .padding(.trailing, 4)
                }
            }
            
            Text(text)
                .font(font)
                .foregroundColor(isSelected ? selectedColor : itemColor)
                .bold()
            
        }.onTapGesture {
            onClick()
        }
    }
}

#Preview {
    let isSelected = true
    NavigationDrawerItem(
        text: "Home",
        isSelected: isSelected,
        onClick: {},
        font: .title3,
        imageResourceName: "home"
    )
    .padding(5)
    .background {
        isSelected ? Color.blue.opacity(0.2) : Color.blue.opacity(0)
    }
    .clipShape(RoundedRectangle(cornerRadius: 8))
}
