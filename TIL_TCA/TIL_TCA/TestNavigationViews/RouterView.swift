
import SwiftUI
struct HomeView: View {
  
  var router = Router.shared
  
  var body: some View {
    VStack {
      Image(systemName: "house.fill")
        .font(.system(size: 56))
        .foregroundColor(.accentColor)
      Text("**Home**")
        .font(.system(size: 24))
      
      Button {
        router.navigate(to: .livingroom)
      } label: {
        Text("**Go to Livingroom**")
      }
      .padding(.top, 12)
      
    }
    .padding()
  }
}


struct LivingroomView: View {
  
  var router = Router.shared
  
  var body: some View {
    VStack {
      Image(systemName: "sofa.fill")
        .font(.system(size: 56))
        .foregroundColor(.accentColor)
      Text("**Livingroom**")
        .font(.system(size: 24))
        .padding(.top, 12)
      
      Button("**Go to Jane's Bedroom**") {
        router.navigate(to: .bedroom(owner: "Jane"))
      }
      .padding(.top, 12)
      
      Button("**Go to John's Bedroom**") {
        router.navigate(to: .bedroom(owner: "John"))
      }
      .padding(.top, 12)
      
      Button {
        router.navigateBack()
      } label: {
        Text("Back")
      }
      .padding(.top, 4)
    }
    .navigationBarBackButtonHidden()
    .padding()
  }
}


struct BedroomView: View {
  
  var router = Router.shared
  var ownerName: String
  
  var body: some View {
    VStack {
      Text("\(ownerName)'s Bedroom")
        .font(.system(size: 36, weight: .bold))
        .padding(.bottom, 12)
      Image(systemName: "bed.double.fill")
        .font(.system(size: 56))
        .foregroundColor(.accentColor)
      
      Button {
        router.navigateBack()
      } label: {
        Text("Back to **Livingroom**")
      }
      .padding(.top, 12)
      
      Button {
        router.navigateToRoot()
      } label: {
        Text("Pop to **Home**")
      }
      .padding(.top, 4)
      
    }
    .navigationBarBackButtonHidden()
    .padding()
  }
}

final class Router: ObservableObject {
  static var shared: Router = .init()
  
  public enum Destination: Codable, Hashable {
    case livingroom
    case bedroom(owner: String)
  }
  
  @Published var navPath = NavigationPath()
  
  func navigate(to destination: Destination) {
    navPath.append(destination)
  }
  
  func navigateBack() {
    navPath.removeLast()
  }
  
  func navigateToRoot() {
    navPath.removeLast(navPath.count)
  }
}
