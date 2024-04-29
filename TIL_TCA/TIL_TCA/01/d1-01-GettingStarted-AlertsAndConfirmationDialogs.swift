import ComposableArchitecture
import SwiftUI

private let readMe = """
  This demonstrates how to best handle alerts and confirmation dialogs in the Composable \
  Architecture.

  The library comes with two types, `AlertState` and `ConfirmationDialogState`, which are data \
  descriptions of the state and actions of an alert or dialog. These types can be constructed in \
  reducers to control whether or not an alert or confirmation dialog is displayed, and \
  corresponding view modifiers, `alert(_:)` and `confirmationDialog(_:)`, can be handed bindings \
  to a store focused on an alert or dialog domain so that the alert or dialog can be displayed in \
  the view.

  The benefit of using these types is that you can get full test coverage on how a user interacts \
  with alerts and dialogs in your application
  """

@Reducer
struct AlertAndConfirmationDialog {
  
  @ObservableState
  struct State {
    @Presents var alert: AlertState<Action.Alert>?
    @Presents var confirmationDialo: ConfirmationDialogState<Action.ConfirmationDialog>?
    @Presents var customAlert: CustomAlert?
    var count = 0
  }
  
  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case alertButtonTapped
    case confirmationDialog(PresentationAction<ConfirmationDialog>)
    case confirmationDialogButtonTapped
    case customAlertTapped
    case customAlert(PresentationAction<CustomAlert>)
    case confirmationStateOfAlertAndDialog
    
    
    @CasePathable
    enum Alert {
      case incrementButtonTapped
    }
    
    @CasePathable
    enum ConfirmationDialog {
      case incrementButtonTapped
      case decrementButtonTapped
    }
    
    @CasePathable
    enum CustomAlert{
      case closeTapped
    }
  }
  
  var body: some Reducer<State, Action> {
    Reduce{ state, action in
      
      switch action {
      case .customAlertTapped:
        state.customAlert = CustomAlert(buttonAction: {
          
        })
        return .none
      case .customAlert(.presented(.closeTapped)):
        return .none
      case .customAlert:
        return .none

      case .confirmationStateOfAlertAndDialog :
        print("alert: \(state.alert == nil), dialog: \(state.confirmationDialo == nil)")
        return .none
      case .alert(.presented(.incrementButtonTapped)),
          .confirmationDialog(.presented(.incrementButtonTapped)):
        state.alert = AlertState{
          TextState("Incremented")
        }
        state.count += 1
        return .none
        
      case .alert:
        return .none
        
      case .alertButtonTapped:
        state.alert = AlertState {
          TextState("Alert!")
        } actions: {
          
          ButtonState(action: .incrementButtonTapped) {
            TextState("Increment")
          }
        } message: {
          TextState("This is an Alert")
        }
        return .none
    
      case .confirmationDialog(.presented(.decrementButtonTapped)) :
        state.alert = AlertState { TextState("Decremented!")}
        state.count -= 1
        return .none
        
      case .confirmationDialog(.presented(.incrementButtonTapped)) :
        state.alert = AlertState { TextState("increment!!")}
        state.count += 1
        return .none
        
      case .confirmationDialog:
        return .none
        
      case .confirmationDialogButtonTapped:
        state.confirmationDialo = ConfirmationDialogState {
          TextState("Confirmnation dialog")
        } actions: {
          ButtonState(role: .cancel) {
            TextState("Cancel")
          }
          ButtonState(action: .decrementButtonTapped) {
            TextState("DecrementButtonTapped")
          }
          ButtonState(action: .incrementButtonTapped) {
            TextState("incrementButtonTapped")
          }
        }message: {
          TextState("This is a confirmnation Dialog.")
        }
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
    .ifLet(\.$confirmationDialo, action: \.confirmationDialog)
  }
}

struct AlertAndConfirmationDialogView: View {
  @Bindable var store: StoreOf<AlertAndConfirmationDialog>

  var body: some View {
    
    Form {
      Section {
        AboutView(readMe: readMe)
      }

      Text("Count: \(store.count)")
      Button("Alert") { store.send(.alertButtonTapped) }
      Button("Confirmation Dialog") { store.send(.confirmationDialogButtonTapped) }
      
      Button("상태 확인하기") {
        store.send(.confirmationStateOfAlertAndDialog)
      }
      Button("커스텀 얼럿!") {
        store.send(.customAlertTapped)
      }
      Section {
        if let alert = store.state.customAlert {
          alert
        }
      }
    }
    .navigationTitle("Alerts & Dialogs")
    .alert($store.scope(state: \.alert, action: \.alert))
    .confirmationDialog($store.scope(state: \.confirmationDialo, action: \.confirmationDialog))
  }
}

struct CustomAlert: View {
  var buttonAction: (() -> ())
  var body: some View {
    VStack{
      Button("Close") {
        buttonAction()
      }
    }
  }
}
