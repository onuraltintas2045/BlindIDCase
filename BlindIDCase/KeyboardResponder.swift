//
//  KeyboardResponder.swift
//  BlindIDCase
//
//  Created by Onur Altintas on 25.05.2025.
//
import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    static let shared = KeyboardResponder()

    @Published var keyboardHeight: CGFloat = 0

    private var cancellables = Set<AnyCancellable>()

    private init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .assign(to: \.keyboardHeight, on: self)
            .store(in: &cancellables)
    }

    var isKeyboardVisible: Bool {
        keyboardHeight > 0
    }
}
