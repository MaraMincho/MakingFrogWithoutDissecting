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
                print(text)
                if text.count > 5 {
                    print("이메일 check가 바뀌었습니다.")
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
                print(value)
                if value.count > 5 {
                    self?.passwordCheck = true
                }else {
                    self?.passwordCheck = false
                }
            }
            .store(in: &cancellables)
        
        $passwordCheck.receive(on: DispatchQueue.main)
            .subscribe(on: DispatchQueue.global())
            .sink { value in
                switch value {
                case .failure(let error) :
                    print(error)
                case .finished :
                    print(value)
                }
            } receiveValue: { value in
                print(value)
                if self.passwordCheck && self.emailCheck {
                    self.loginButton.isEnabled = true
                }else {
                    self.loginButton.isEnabled = false
                }
            }.store(in: &cancellables)

    }
}


struct test {
    var name: String
}
extension Notification.Name {
    static let ssss = Notification.Name("ssss")
    
}

