//
//  TIL_NavigationWithTCAApp.swift
//  TIL_NavigationWithTCA
//
//  Created by MaraMincho on 6/9/24.
//

import SwiftUI

@main
struct TIL_NavigationWithTCAApp: App {
    var body: some Scene {
        WindowGroup {
            FirstNavigationView(store: .init(initialState: .init(), reducer: {
                FirstNavigation()
            }))
        }
    }
}
