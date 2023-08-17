//
//  ChampionInputTextFiledView.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import UIKit

class ChampionInputTextFiledView: UIView, UITextFieldDelegate {
    
    
    private let championNameTextField: UITextField = {
        let tf = UITextField()
        
        tf.borderStyle = .roundedRect
        tf.placeholder = "이름"
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private func setupChampionNameTextFielDelegate() {
        championNameTextField.delegate = self
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupConstraints()
    }
    
    func setupConstraints() {
        self.addSubview(championNameTextField)
        championNameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        championNameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        championNameTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        championNameTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}
