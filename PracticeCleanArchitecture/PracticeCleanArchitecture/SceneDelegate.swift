//
//  SceneDelegate.swift
//
//  Created by MaraMincho on 1/16/24.
//

import Combine
import UIKit

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  var subscription = Set<AnyCancellable>()

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = .init(windowScene: windowScene)
    window?.rootViewController = Builder.exchangingRateViewController()
    window?.makeKeyAndVisible()
  }
}

// MARK: - Builder

enum Builder {
  static func exchangingRateViewController() -> UIViewController {
    let receiveCountries: [ReceiveCountry] = [
      .init(name: "한국", unit: "KRW"),
      .init(name: "일본", unit: "JPY"),
      .init(name: "필리핀", unit: "PHP"),
    ]

    let repo = ExchangingRateRepository(session: URLSession.shared)
    let convertUseCase = ExchangingRateConvertUseCase()
    let fetchUseCase = ExchangingRateFetchUseCase(repository: repo, receiveCountries: receiveCountries)
    let viewModel = ExchangingRateViewModel(fetchUseCase: fetchUseCase, convertUseCase: convertUseCase)
    let viewController = ExchangingRateViewController(viewModel: viewModel)

    return viewController
  }
}
