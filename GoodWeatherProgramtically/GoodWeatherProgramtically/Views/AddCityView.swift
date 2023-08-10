//
//  AddCityView.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class AddCityView: UIView {
    var addCityViewDelegate: AddCityViewDelegate!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        setupConstraints()
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "도시명을 입력하세요"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 500.00, height: 30.00))
        tf.font = .systemFont(ofSize: 30)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .default
        tf.textAlignment = .center
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.addTarget(self, action: #selector(dismissScreen), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

extension AddCityView {
    
    @objc func dismissScreen() {
        addCityViewDelegate.dismissAddCityView()
    }
    
    func setupConstraints() {
        self.backgroundColor = .white
        
        
        self.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        self.addSubview(inputTextField)
        inputTextField.widthAnchor.constraint(equalToConstant: 350).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        inputTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        inputTextField.centerXAnchor.constraint(equalTo: descriptionLabel.centerXAnchor).isActive = true
        
        self.addSubview(saveButton)
        saveButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 20).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: inputTextField.centerXAnchor).isActive = true
    }
}
