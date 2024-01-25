//
//  CombineCocoa.swift
//
//  Created by MaraMincho on 1/16/24.
//

import Combine
import UIKit

extension UIControl {
  func publisher(_ event: UIControl.Event) -> EventPublisher {
    return EventPublisher(event: event, target: self)
  }

  struct EventPublisher: Publisher {
    typealias Failure = Never
    typealias Output = UIControl

    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = EventSubscription(event: event, targetView: target, subscriber: subscriber)
      subscriber.receive(subscription: subscription)
    }

    let event: UIControl.Event
    let target: UIControl
    init(event: UIControl.Event, target: UIControl) {
      self.event = event
      self.target = target
    }
  }
}

// MARK: - EventSubscription

final class EventSubscription<T: Subscriber>: Subscription where T.Failure == Never, T.Input == UIControl {
  func request(_: Subscribers.Demand) {}

  func cancel() {
    targetView.removeTarget(self, action: #selector(action), for: event)
    subscriber = nil
  }

  @objc func action() {
    _ = subscriber?.receive(targetView)
  }

  let event: UIControl.Event
  var targetView: UIControl
  var subscriber: T?

  init(event: UIControl.Event, targetView: UIControl, subscriber: T) {
    self.event = event
    self.targetView = targetView
    self.subscriber = subscriber

    targetView.addTarget(self, action: #selector(action), for: event)
  }
}
