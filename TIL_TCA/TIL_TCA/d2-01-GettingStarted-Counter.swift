import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates the basics of the Composable Architecture in an archetypal counter \
  application.

  The domain of the application is modeled using simple data types that correspond to the mutable \
  state of the application and any actions that can affect that state or the outside world.
  """

@Reducer
struct Counter {
  
  @ObservableState
  struct State: Equatable {
    var count = 0
  }

  enum Action {
    case decrementButtonTapped
    case incrementButtonTapped
    case resetButtonTapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .resetButtonTapped:
        state.count = 0
        return .none
      case .decrementButtonTapped:
        state.count -= 1
        return .none
      case .incrementButtonTapped:
        state.count += 1
        return .none
      }
    }
  }
}

struct CounterView: View {
  let store: StoreOf<Counter>

  var body: some View {
    VStack {
      Button {
        store.send(.resetButtonTapped)
      } label: {
        Text("reset")
      }
      HStack {
        Button {
          store.send(.decrementButtonTapped)
        } label: {
          Image(systemName: "minus")
        }

        Text("\(store.count)")
          .monospacedDigit()

        Button {
          store.send(.incrementButtonTapped)
        } label: {
          Image(systemName: "plus")
        }
      }
    }
  
  }
}

struct CounterDemoView: View {
  let store: StoreOf<Counter>
  
  init(store: StoreOf<Counter>) {
    self.store = store
  }

  var body: some View {
    NavigationStack {
      NavigationLink {
        Color.red
      } label: {
        VStack{
          ZStack {
            Color.gray
            Text("asdf")
          }
        }
      }
      Form { 
        Section {
          AboutView(readMe: readMe)
        }
        
        Section {
          CounterView(store: store)
            .frame(maxWidth: .infinity)
        }
      }
    }
    
    .buttonStyle(.borderless)
    .navigationTitle("Counter demo")
  }
}

enum SomeNavigation {
  case ta
  case tb
  case tc
}
