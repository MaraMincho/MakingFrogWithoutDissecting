//
//  AddCoffeeView.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit

class AddCoffeeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension AddCoffeeView {
    func setup() {
        setupBackgroundColor()
    }
    
    func setupBackgroundColor() {
        self.backgroundColor = .blue
    }
}
