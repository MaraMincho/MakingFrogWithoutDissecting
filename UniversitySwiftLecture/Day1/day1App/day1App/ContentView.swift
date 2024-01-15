//
//  ContentView.swift
//  ImageSwitcher
//
//  Created by Kiyong Kim on 1/15/24.
//

import SwiftUI
import Combine

struct ContentViewModelInput {
  let prevButtonDidTap: AnyPublisher<Void, Never>
  let nextButtonDidTap: AnyPublisher<Void, Never>
}

enum ContentViewModelOutput {
  case idle
}
typealias ContentViewState = AnyPublisher<ContentViewModelOutput, Never>

struct ContentViewModel {
  var subscriptions = Set<AnyCancellable>()
  
  var currentPageIndex: Int = 1
  var catImageFileNameArray = catImageFileName.allCases.map{$0.rawValue}
  
  func transform(input: ContentViewModelInput) -> ContentViewState {
    
    return Just(ContentViewModelOutput.idle).eraseToAnyPublisher()
  }
  
  private enum catImageFileName: String, CaseIterable {
    case cat1
    case cat2
    case cat3
    case cat4
    case cat5
  }
}

struct TopButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    return content
  }
}

struct TopButton: View {
  let isLeft: Bool
  var body: some View {
    Button{
      
    } label: {
      Image(systemName: "arrow.\(isLeft ? "left" : "right").circle.fill")
    }
    .background(Color.yellow)
    .padding()
    .background(Color.red)
  }
}


struct ContentView: View {
  
  @State var currentImageIndex: Int = 1
  @State var isPreviousButtonDisable: Bool = true
  
  var currentImageName: String {
    return "cat\(currentImageIndex)"
  }
  
  let viewModel: ContentViewModel
  init(viewModel: ContentViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      HStack{
        TopButton(isLeft: true)
    
        Text("\(currentImageIndex)/5")
          .frame(maxWidth: .infinity)
        
        TopButton(isLeft: false)
      }
      .font(.largeTitle)
      Image(currentImageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .padding()
  }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
