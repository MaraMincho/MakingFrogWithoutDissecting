//
//  TCADiscussionProjectApp.swift
//  TCADiscussionProject
//
//  Created by MaraMincho on 10/1/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct InsightsApp: App {
  @Dependency(\.featureFlagClient) var featureFlagClient

  @Bindable var store: StoreOf<AppFeature> = Store(
    initialState: AppFeature.State(
      featureFlagData: Shared(FeatureFlagData())
    )
  ) {
    AppFeature()
  }

  init() {
    store.send(.initializeFeatureFlags)
  }

  var body: some Scene {

    WindowGroup {
      AppView(store: store)
        .onAppear(perform: {
          featureFlagClient.observeAll(allFlagsObserver) { updatedFlags in
            store.send(.featureFlagsUpdated(updatedFlags))
          }
        })
    }
  }
}

struct AppView: View {

  @Bindable var store: StoreOf<AppFeature>

  var body: some View {
    Group {
      if store.loggedIn {
        AuthenticatedView(store: store.scope(
          state: \.authenticated,
          action: \.authenticated
        ))
      } else {
        LoginView(store: store.scope(
          state: \.login,
          action: \.login
        ))
      }
    }
  }
}

@Reducer
struct AppFeature {

  //    @Reducer
  //    enum Path: Equatable {
  //        case login(LoginFeature)
  //        case authenticated(AuthenticatedFeature)
  //    }

  @ObservableState
  struct State: Equatable {
    //        var path = StackState<Path.State>()

    @Shared var featureFlagData: FeatureFlagData
    var loggedIn: Bool = false

    var login = LoginFeature.State.init()
    
  }

  enum Action {
    //        case path(StackAction<Path.State, Path.Action>)

    case featureFlagsUpdated([String: LDChangedFlag])
    case initializeFeatureFlags
    case login(LoginFeature.Action)
    case authenticated(AuthenticatedFeature.Action)
  }

  var body: some ReducerOf<Self> {
    Scope(state: \.login, action: \.login) {
      LoginFeature()
    }
    Scope(state: \.authenticated, action: \.authenticated) {
      AuthenticatedFeature()
    }
    Reduce { state, action in
      switch action {
      case .initializeFeatureFlags:
        // do some stuff
        return .none

      case .featureFlagsUpdated(let updatedFlags):
        // update flag values
        return .none

      case let .login(.delegate(action)):
        switch action {
        case .authenticated:
          state.loggedIn = true
          return .none
        }

      case let .authenticated(.accountSelected(.delegate(action))):
        switch action {
        case .logout:
          state.loggedIn = false
          return .none
        }

      case .login, .authenticated:
        return .none

        //            case .path(_):
        //                return .none
      }
    }
    //        .forEach(\.path, action: \.path)
  }
}
