//
//  ViewController.swift
//  ActionSheetAndAlert
//
//  Created by MaraMincho on 2023/08/14.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var alertSheet: UIAlertController = {
        let ac = UIAlertController(title: "TestAlertController", message: "정말로 그것을 하시겠습니까?", preferredStyle: .alert)
        ac.addAction(self.firstAction)
        ac.addAction(secondAction)
        
        return ac
    }()
    
    private lazy var actionSheet: UIAlertController = {
        let ac = UIAlertController(title: "TestAlertController", message: "정말로 그것을 하시겠습니까?", preferredStyle: .actionSheet)
        ac.addAction(self.firstAction)
        ac.addAction(secondAction)
        
        return ac
    }()
    private let firstAction = UIAlertAction(title: "0k", style: .default)
    private let secondAction = UIAlertAction(title: "N0", style: .destructive)
    
    private let acctionButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.setTitle("액션 시트", for: .normal)
        button.addTarget(self, action: #selector(allertButtonTarget(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let allertButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.setTitle("에럴트 버튼", for: .normal)
        button.addTarget(self, action: #selector(actionButtonTarget(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let st = UIStackView(arrangedSubviews: [
            self.acctionButton, self.allertButton
        ])
        st.axis = .vertical
        st.distribution = .fillEqually
        st.alignment = .center
        
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    func setup() {
        self.view.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
        
        self.view.addSubview(buttonStack)
        self.buttonStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        self.buttonStack.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.buttonStack.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    @objc func actionButtonTarget(_ sender: UIButton) {
        self.present(actionSheet, animated: true)
    }


    @objc func allertButtonTarget(_ sender: UIButton) {
        self.present(alertSheet, animated: true)
    }
}

