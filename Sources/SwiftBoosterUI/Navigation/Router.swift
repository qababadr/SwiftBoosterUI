//
//  Router.swift
//  CoreUI
//
//  Created by BADR  QABA on 2026-02-10.
//

import Foundation
import Combine

public final class Router<Destination: Hashable>: ObservableObject {
    
    public init() {}
    
    @Published
    public var navigationStack: [Destination] = []
    
    public func currentDestination() -> Destination? {
        return navigationStack.last
    }
    
    public func navigate(
        to destination: Destination,
        onNavigate: @escaping (Destination?) -> Void = { _ in }
    ) {
        // prevent pushing the same destination consecutively
        guard navigationStack.last != destination else { return }
        onNavigate(destination)
        navigationStack.append(destination)
    }
    
    public func navigateBack(
        onNavigateBack: @escaping () -> Void = {}
    ) {
        guard !navigationStack.isEmpty else { return }
        onNavigateBack()
        navigationStack.removeLast()
    }
    
    public func reset(to destination: Destination) {
        navigationStack = [destination]
    }
}
