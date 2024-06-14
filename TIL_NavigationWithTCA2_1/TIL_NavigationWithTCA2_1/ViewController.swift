//
//  ViewController.swift
//  TIL_NavigationWithTCA2_1
//
//  Created by MaraMincho on 6/14/24.
//

import Combine
import ComposableArchitecture
import UIKit
import SwiftUI

// 첫번째 ViewController
final class FirstViewController: UIHostingController<FirstView> {
  var reducer: FirstReducer
  var destinationSubscriber: AnyCancellable? = nil
  
  init(state: FirstReducer.State, reducer: FirstReducer) {
    self.reducer = reducer
    super.init(rootView: FirstView(store: .init(initialState: state, reducer: {
      reducer
    })))
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // publisher를 통한 화면 전환
    destinationSubscriber = reducer
      .publisher
      .sink { [weak self] destination in
        let pushViewController: UIViewController
        switch destination {
        case .secondScreen:
          pushViewController = SecondViewController(state: .init(), reducer: .init())
        case .thirdScreen:
          pushViewController = ThirdViewController(state: .init(), reducer: .init())
        }
        self?.navigationController?.pushViewController(pushViewController, animated: true)
      }
  }
  
  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// 첫번째 뷰가 갈 수 있는 경로
enum FirstViewPushDestinations {
  case secondScreen
  case thirdScreen
}


// 첫번째 뷰 리듀서
@Reducer
struct FirstReducer {
  struct State {
    var onAppear: Bool = false
  }
  
  enum Action {
    case navigationSecondScreen
    case navigationThirdScreen
    case push(FirstViewPushDestinations)
  }
  
  
  var publisher: PassthroughSubject<FirstViewPushDestinations, Never> = .init()
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .navigationSecondScreen:
        return .send(.push(.secondScreen))
      case .navigationThirdScreen:
        return .send(.push(.thirdScreen))
      case let .push(destination):
        publisher.send(destination)
        return .none
      }
    }
  }
}

// 첫번째 뷰
struct FirstView: View {
  var store: StoreOf<FirstReducer>
  var body: some View {
    VStack(spacing: 0) {
      Text("UIHostinhController를 통해 생성된 뷰")
      Button {
        store.send(.navigationSecondScreen)
      } label: {
        Text("Go SecondScreen")
      }
      
      Button {
        store.send(.navigationThirdScreen)
      } label: {
        Text("Go ThirdScreen")
      }
    }
  }
}

final class SecondViewController: UIHostingController<SecondView> {
  var reducer: SecondReducer
  var publisher: PassthroughSubject<SecondViewPushDestinations, Never> = .init()
  var navigationSubscriber: AnyCancellable? = nil
  
  init(state: SecondReducer.State, reducer: SecondReducer) {
    self.reducer = reducer
    super.init(rootView: SecondView(store: .init(initialState: state, reducer: {
      reducer
    })))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationSubscriber = reducer
      .publisher
      .sink{[weak self] val in
        let pushViewController: UIViewController
        switch val {
        case .thirdScreen:
          pushViewController = ThirdViewController(state: .init(), reducer: .init())
        }
        self?.navigationController?.pushViewController(pushViewController, animated: true)
      }
  }
  
  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

enum SecondViewPushDestinations {
  case thirdScreen
}

@Reducer
struct SecondReducer {
  struct State {
    var onAppear: Bool = false
  }
  
  var publisher: PassthroughSubject<SecondViewPushDestinations, Never> = .init()
  
  enum Action {
    case navigationThirdScreen
    case push(SecondViewPushDestinations)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .navigationThirdScreen:
        return .none
      case let .push(val):
        publisher.send(val)
        return .none
      }
    }
  }
}


struct SecondView: View {
  var store: StoreOf<SecondReducer>
  var body: some View {
    ZStack {
      Color.red.opacity(0.5)
      VStack {
        Button {
          store.send(.navigationThirdScreen)
        } label: {
          Text("Go ThirdScreen")
        }
      }
    }
  }
}





final class ThirdViewController: UIHostingController<ThirdView> {
  var reducer: ThirdReducer
  var publisher: PassthroughSubject<ThirdViewPushDestinations, Never> = .init()
  var navigationSubscriber: AnyCancellable? = nil
  
  init(state: ThirdReducer.State, reducer: ThirdReducer) {
    self.reducer = reducer
    super.init(rootView: ThirdView(store: .init(initialState: state, reducer: {
      reducer
    })))
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationSubscriber = reducer
      .publisher
      .sink{[weak self] val in
        let pushViewController: UIViewController
        switch val {
        case .secondScreen:
          pushViewController = SecondViewController(state: .init(), reducer: .init())
        }
        self?.navigationController?.pushViewController(pushViewController, animated: true)
      }
  }
  
  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

enum ThirdViewPushDestinations {
  case secondScreen
}

@Reducer
struct ThirdReducer {
  struct State {
    var onAppear: Bool = false
  }
  
  var publisher: PassthroughSubject<ThirdViewPushDestinations, Never> = .init()
  
  enum Action {
    case navigationSecondScreen
    case push(ThirdViewPushDestinations)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .navigationSecondScreen:
        return .send(.push(.secondScreen))
      case let .push(val):
        publisher.send(val)
        return .none
      }
    }
  }
}


struct ThirdView: View {
  var store: StoreOf<ThirdReducer>
  var body: some View {
    ZStack {
      Color.gray.opacity(0.5)
      VStack {
        Button {
          store.send(.navigationSecondScreen)
        } label: {
          Text("Go second")
        }
      }
    }
  }
}


