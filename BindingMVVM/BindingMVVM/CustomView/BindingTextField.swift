//
//  BindingTextField.swift
//  BindingMVVM
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation
import UIKit


class BindingTextField: UITextField {
    
    var textChaged: (String) -> Void = {_ in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(textFieldDidchanged), for: .editingChanged)
    }
    
    
    func bind(callback: @escaping (String) -> Void) {
        textChaged = callback
    }
    
    @objc func textFieldDidchanged(_ textField: UITextField) {
        if let text = textField.text {
            textChaged(text)
        }
    }
}
