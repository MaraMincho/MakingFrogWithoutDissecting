
import UIKit
import HomeViewModel
import Combine

public final class HomeViewController: UIViewController {
  let viewModel: HomeViewModels
  var bag = Set<AnyCancellable>()
  
  private let nextButton: UIButton = {
    let button: UIButton = UIButton(type: .system)
    button.setTitle("다음으로 가요잉", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  
  init(viewModel: HomeViewModels) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: .module)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("Not Recommanded Coder")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

extension HomeViewController {
  func setup() {
    setConstraints()
  }
  
  func setConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    self.view.addSubview(nextButton)
    nextButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    nextButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
  }
  
  func bind() {
    nextButtonDidTap()
  }
  
  func nextButtonDidTap() {
    nextButton.controlPublisher(for: .touchUpInside).sink { [weak self] _ in
      guard let self else { return }
      viewModel.presentPostList()
    }
    .store(in: &bag)
  }
}

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
      }
    
    // Publisher
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    // Subscription
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {

        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscrier
            self.event = event
            
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc func eventDidOccur() {
            _ = subscriber?.receive(control)
        }
    }
}
