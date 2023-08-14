//
//  ViewController.swift
//  CombineExampleOfTextField
//
//  Created by MaraMincho on 2023/08/14.
//

import UIKit
import Combine

class ViewController: UIViewController {

    
    @Published var emailCheck = false
    @Published var passwordCheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력하세요"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.spellCheckingType = .no
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 입력하세요"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.spellCheckingType = .no
        tf.isSecureTextEntry = true
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let loginButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("로그인 불가", for: .disabled)
        bt.setTitleColor(.gray, for: .disabled)
        bt.setTitle("로그인", for: .normal)
        bt.isEnabled = false
        bt.addTarget(self, action: #selector(postValue), for: .touchUpInside)
        
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    @objc func postValue() {

    }
    
    lazy var stackView: UIStackView = {
        let st = UIStackView(arrangedSubviews: [
            self.emailTextField, self.passwordTextField, self.loginButton
        ])
        st.axis = .vertical
        st.distribution = .fillEqually
        st.spacing = 30
        
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    
    func setup() {
        self.view.backgroundColor = .white
        bind()
        setupConstraints()
    }

    
    func setupConstraints() {
        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    var cancellables: Set<AnyCancellable> = []

    func bind() {
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: emailTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .receive(on: DispatchQueue.global())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] text in
                if text.count > 5 {
                    self?.emailCheck = true
                } else {
                    self?.emailCheck = false
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .receive(on: DispatchQueue.global())
            .subscribe(on: DispatchQueue.global())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished :
                    print(completion)
                }
            } receiveValue: {[weak self] value in
                if value.count > 5 {
                    self?.passwordCheck = true
                }else {
                    self?.passwordCheck = false
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($emailCheck, $passwordCheck)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .sink { completion in
                switch completion {
                case .finished:
                    print(completion)
                case .failure(let error) :
                    print(error)
                }
            } receiveValue: { value in
                DispatchQueue.main.async {
                    self.loginButton.isEnabled = (value.0 && value.1) == true ? true : false
                }
            }.store(in: &cancellables)
        
        self.loginButton.publisher(for: .touchDragOutside)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.global())
            .sink { completion in
                switch completion {
                case .failure(let error) :
                    print(error)
                case .finished :
                    print(completion)
                }
            } receiveValue: { event in
                print("event is occured")
            }.store(in: &cancellables)
        
        let ges = UITapGestureRecognizer(target: self, action: #selector(tabView(_:)))
        self.view.addGestureRecognizer(ges)
    }
    @objc func tabView(_ sender:UITapGestureRecognizer) {
        //에디팅이 끝나면 키보드를 내림
        self.view.endEditing(true)
    }
}


struct test {
    var name: String
}
extension Notification.Name {
    static let ssss = Notification.Name("ssss")
    
}
extension UIControl {
    
    fileprivate class EventControlSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {

        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        var currentDemand: Subscribers.Demand = .none

        init(control: UIControl, event: UIControl.Event, subscriber: EventSubscriber) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            DispatchQueue.main.async {
                control.addTarget(self, action: #selector(self.eventRaised), for: event)
            }
            
        }

        func request(_ demand: Subscribers.Demand) {
          currentDemand += demand
        }

        func cancel() {
            subscriber = nil
            control.removeTarget(self,  action: #selector(eventRaised), for: event)
        }

        @objc func eventRaised() {
            if currentDemand > 0 {
              currentDemand += subscriber?.receive(control) ?? .none
              currentDemand -= 1
            }
        }
    }
    
    struct EventControlPublisher: Publisher {
       typealias Output = UIControl
       typealias Failure = Never

       let control: UIControl
       let controlEvent: UIControl.Event

       func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
         // instantiate the new subscription
         let subscription = EventControlSubscription(control: control, event: controlEvent, subscriber: subscriber)
         // tell the subscriber that it has successfully subscribed to the publisher
         subscriber.receive(subscription: subscription)
       }
     }
    
    func publisher(for event: UIControl.Event) -> UIControl.EventControlPublisher {
      return UIControl.EventControlPublisher(control: self, controlEvent: event)
    }
}
