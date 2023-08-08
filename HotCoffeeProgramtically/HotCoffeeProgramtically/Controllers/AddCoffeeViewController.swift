//
//  AddCoffeeViewController.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit


class AddCoffeeViewController: UIViewController {
    var addCoffeeView:AddCoffeeView!
    
    override func loadView() {
        super.loadView()
        let curView = AddCoffeeView(frame: self.view.frame)
        addCoffeeView = curView
        self.view = addCoffeeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AddCoffeeViewController {
    func setup() {
        setupNavigationController()
    }
    
    
    func setupNavigationController() {
        self.navigationItem.title = "새로운 메뉴를 추가하세요"
    }
}
