//
//  TextInput.swift
//  CoreUI
//
//  Created by BADR  QABA on 2025-05-28.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
public typealias KeyboardType = UIKeyboardType
#else
public enum KeyboardType: Int {
    case `default`
    case asciiCapable
    case numbersAndPunctuation
    case URL
    case numberPad
    case phonePad
    case namePhonePad
    case emailAddress
    case decimalPad
    case twitter
    case webSearch
    case asciiCapableNumberPad
}
#endif

public enum InputType {
    case text, password
}

public struct TextInput: View {

    @Binding
    private var value: String

    @FocusState
    private var isFocused: Bool

    private let leadingIconName: String?
    private let trailingIconName: String?
    private let clearable: Bool
    private let isProcessing: Bool
    private let onChange: (String) -> Void
    private let onSubmit: () -> Void
    private let onTrailingIconClick: () -> Void
    private let onFocusChange: (Bool) -> Void
    private let onClearClick: () -> Void
    private let label: String
    private let accessibilityIdentifier: String
    private let keyboardType: KeyboardType
    private let iconsColor: Color
    private let hasError: Bool
    private let errorContent: String?
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let borderColor: Color
    private let innerPadding: CGFloat
    private let trailingIconAI: String
    private let inputType: InputType
    private let multiline: Bool
    private let minHeight: CGFloat?
    private let maxHeight: CGFloat?
    private let background: Color?

    public init(
        value: Binding<String>,
        isFocused: FocusState<Bool>.Binding? = nil,
        label: String = "",
        accessibilityIdentifier: String = "textField",
        trailingIconAI: String = "trailing icon button",
        keyboardType: KeyboardType = .default,
        leadingIconName: String? = nil,
        trailingIconName: String? = nil,
        clearable: Bool = false,
        isProcessing: Bool = false,
        iconsColor: Color = .green,
        hasError: Bool = false,
        errorContent: String? = nil,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 1,
        innerPadding: CGFloat = 10,
        borderColor: Color = .gray,
        inputType: InputType = .text,
        multiline: Bool = false,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        onChange: @escaping (String) -> Void = { _ in },
        onSubmit: @escaping () -> Void = {},
        onTrailingIconClick: @escaping () -> Void = {},
        onClearClick: @escaping () -> Void = {},
        onFocusedChange: @escaping (Bool) -> Void = { _ in },
        background: Color? = nil
    ) {
        _value = value
        self.cornerRadius = cornerRadius
        self.label = label
        self.leadingIconName = leadingIconName
        self.trailingIconName = trailingIconName
        self.clearable = clearable
        self.isProcessing = isProcessing
        self.onChange = onChange
        self.onSubmit = onSubmit
        self.keyboardType = keyboardType
        self.accessibilityIdentifier = accessibilityIdentifier
        self.iconsColor = iconsColor
        self.hasError = hasError
        self.errorContent = errorContent
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.innerPadding = innerPadding
        self.onTrailingIconClick = onTrailingIconClick
        self.onClearClick = onClearClick
        self.trailingIconAI = trailingIconAI
        self.onFocusChange = onFocusedChange
        self.inputType = inputType
        self.multiline = multiline
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.background = background
    }

    // MARK: - Subviews to help the type-checker
    @ViewBuilder
    private var leadingIcon: some View {
        if let leadingIconName {
            Image(leadingIconName, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundColor(
                    hasError ? .theme().error : borderColor
                )
        }
    }

    @ViewBuilder
    private var inputField: some View {
        AnyView(
            Group {
                if multiline && inputType == .text {
                    ZStack(alignment: .topLeading) {
                        if value.isEmpty, !label.isEmpty {
                            Text(label)
                                .font(.typography(.bodyMedium, font: Roboto.regular))
                                .foregroundColor(.theme().secondary)
                                .padding(.vertical, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $value)
                            .autocorrectionDisabled(true)
                            .background(Color.clear)
                            .padding(.vertical, 4)
                            .modifier(ScrollContentBackgroundHiddenIfAvailable())
                    }
                } else if inputType == .text {
                    TextField(
                        "",
                        text: $value,
                        prompt: Text(label)
                            .font(.typography(.bodyMedium, font: Roboto.regular))
                            .foregroundColor(.theme().secondary)
                    )
                    .autocorrectionDisabled(true)
                } else {
                    SecureField(
                        "",
                        text: $value,
                        prompt: Text(label)
                            .font(.typography(.bodyMedium, font: Roboto.regular))
                            .foregroundColor(.theme().secondary)
                    )
                    .autocorrectionDisabled(true)
                    .textContentType(nil)
                }
            }
            .frame(minHeight: minHeight, maxHeight: maxHeight)
            .focused($isFocused)
    #if canImport(UIKit)
            .keyboardType(keyboardType)
    #endif
            .onChange(of: value) { newQuery in
                onChange(newQuery)
            }
            .onChange(of: isFocused) { newValue in
                onFocusChange(newValue)
            }
            .onSubmit {
                onSubmit()
            }
            .accessibilityIdentifier(accessibilityIdentifier)
            .foregroundColor(.theme().onBackground)
        )
    }

    @ViewBuilder
    private var clearButton: some View {
        if !value.isEmpty && clearable {
            Button(action: {
                value = ""
                onClearClick()
            }) {
                Image("close-circle", bundle: .module)
                    .foregroundColor(iconsColor)
            }
        }
    }

    @ViewBuilder
    private var processingView: some View {
        if isProcessing {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.theme().primary)
                .accessibilityIdentifier("inner_progr")
                .padding(.horizontal, 6)
        }
    }

    @ViewBuilder
    private var trailingIconButton: some View {
        if let trailingIconName {
            Button(action: onTrailingIconClick) {
                Image(trailingIconName, bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .foregroundColor(iconsColor)
            }
            .accessibilityIdentifier(trailingIconAI)
        }
    }

    @ViewBuilder
    private var inputRow: some View {
        HStack {
            leadingIcon
            inputField
            clearButton
            processingView
            trailingIconButton
        }
    }

    public var body: some View {
        VStack {
            inputRow
                .padding(innerPadding)
                .background(background ?? Color.theme().background)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            hasError ? .theme().error : borderColor,
                            lineWidth: borderWidth
                        )
                )
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

            if hasError,
               let errorContent {
                Text(errorContent)
                    .font(.typography(.labelSmall, font: Roboto.regular))
                    .foregroundColor(.theme().error)
                    .padding(.horizontal, 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct ScrollContentBackgroundHiddenIfAvailable: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *, macOS 13.0) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

private struct TextInputPreview: View {

    @State
    private var value: String = ""

    @State
    private var isProcessing: Bool = false

    @State
    private var hasError: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            TextInput(
                value: $value,
                label: "Email",
                leadingIconName: "email-outline",
                trailingIconName: "magnify",
                isProcessing: isProcessing,
                iconsColor: .theme().primary,
                hasError: hasError,
                errorContent: "Email is required",
                onChange: { newValue in
                    hasError = newValue.isEmpty
                    Task {
                        if !newValue.isEmpty {
                            isProcessing.toggle()
                            try? await Task.sleep(nanoseconds: 1_700_000_000)
                            isProcessing.toggle()
                        }
                    }
                },
                onSubmit: {}
            )

            TextInput(
                value: $value,
                label: "Multiline notes",
                leadingIconName: "email-outline",
                clearable: true,
                iconsColor: .theme().primary,
                multiline: true,
                maxHeight: 300,
                onChange: { newValue in
                    hasError = false
                }
            )
        }
    }
}

#Preview {
    TextInputPreview()
}

