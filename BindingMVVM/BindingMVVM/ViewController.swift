//
//  ViewController.swift
//  BindingMVVM
//
//  Created by MaraMincho on 2023/08/09.
//

import UIKit

class ViewController: UIViewController {
    
    private var loginVM = LoginViewModel()
    
    lazy var userNameTextField: UITextField = {
        let userNameTextField = BindingTextField()
        userNameTextField.placeholder = "Enter UserNames"
        userNameTextField.backgroundColor = .lightGray
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.bind { [weak self] text in
            print(text)
            self?.loginVM.userName.value = text
        }
        
        return userNameTextField
    }()
    
    
    lazy var passWordTextField:UITextField = {
        let passWordTextField = BindingTextField()
        passWordTextField.isSecureTextEntry = true
        passWordTextField.placeholder = "Enter Passwd"
        passWordTextField.backgroundColor = .lightGray
        passWordTextField.borderStyle = .roundedRect
        passWordTextField.bind { [weak self] text in
            print(text)
            self?.loginVM.password.value = text
        }
        return passWordTextField
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginVM.userName.bind { [weak self] text in
            self?.userNameTextField.text = text
        }
        
        setupUI()
    }

    
    @objc func login() {
        print(loginVM.userName)
        print(loginVM.password)
    }
    
    @objc func fetchLoginInfo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.loginVM.userName.value = "hot6"
        }
    }
    
    private func setupUI() {
         
        
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = UIColor.gray
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        let fetchLoginInfoButton = UIButton()
        fetchLoginInfoButton.setTitle("fetch login info", for: .normal)
        fetchLoginInfoButton.backgroundColor = UIColor.blue
        fetchLoginInfoButton.addTarget(self, action: #selector(fetchLoginInfo), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [userNameTextField, passWordTextField, loginButton, fetchLoginInfoButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        
        self.view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    

}

