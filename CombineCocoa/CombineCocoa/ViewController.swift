//
//  ViewController.swift
//  CombineCocoa
//
//  Created by MaraMincho on 1/10/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(someButton)
    
    someButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
    someButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    view.backgroundColor = .red
    
    someButton.publisher(gesture: .tap)
      .sink { _ in
        print("눌림")
      }
      .store(in: &subscriptions)
    
    someButton.publisher(gesture: .longPress)
      .sink { _ in
        print("롱프레")
        self.subscriptions.removeAll()
      }
      .store(in: &subscriptions)
  }
  
  var subscriptions: Set<AnyCancellable> = .init()
  var someButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .blue
    button.setTitle("눌러라 눌러라", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

}

public extension UIView {
  func publisher(gesture: GestureType) -> GesturePublisher {
    return GesturePublisher(targetView: self, gesture: gesture.recognizer)
  }

  struct GesturePublisher: Publisher {
    public typealias Output = UIGestureRecognizer
    public typealias Failure = Never

    let targetView: UIView
    let gesture: UIGestureRecognizer
    init(targetView: UIView, gesture: UIGestureRecognizer) {
      self.targetView = targetView
      self.gesture = gesture
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIGestureRecognizer == S.Input {
      let subscription = GestureSubscription(subscriber: subscriber, gesture: gesture, targetView: targetView)
      subscriber.receive(subscription: subscription)
    }
  }

  enum GestureType {
    case tap
    case swipe
    case longPress
    case pan
    case pinch
    case edge

    var recognizer: UIGestureRecognizer {
      switch self {
      case .tap:
        return UITapGestureRecognizer()
      case .swipe:
        return UISwipeGestureRecognizer()
      case .longPress:
        return UILongPressGestureRecognizer()
      case .pan:
        return UIPanGestureRecognizer()
      case .pinch:
        return UIPinchGestureRecognizer()
      case .edge:
        return UIPinchGestureRecognizer()
      }
    }
  }
}


final class GestureSubscription<T: Subscriber>: Subscription where T.Input == UIGestureRecognizer, T.Failure == Never {
  var subscriber: T?
  let gesture: UIGestureRecognizer
  var targetView: UIView?

  @objc func action() {
    _ = subscriber?.receive(gesture)
  }

  init(subscriber: T, gesture: UIGestureRecognizer, targetView: UIView) {
    self.subscriber = subscriber
    self.gesture = gesture
    self.targetView = targetView

    gesture.addTarget(self, action: #selector(action))
    targetView.addGestureRecognizer(gesture)
  }
  deinit {
    print("\(Self.self) did deinit")
  }

  func request(_: Subscribers.Demand) {}

  func cancel() {
    gesture.removeTarget(self, action: #selector(action))
    targetView?.removeGestureRecognizer(gesture)
    targetView = nil
    subscriber = nil
  }
}
