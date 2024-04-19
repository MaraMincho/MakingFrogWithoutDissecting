//
//  TIL_TCAApp.swift
//  TIL_TCA
//
//  Created by MaraMincho on 4/14/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TIL_TCAApp: App {
    var body: some Scene {
      WindowGroup {
        AlertAndConfirmationDialogView(store: .init(initialState: AlertAndConfirmationDialog.State()) {
          AlertAndConfirmationDialog()
        })
      }
    }
}
