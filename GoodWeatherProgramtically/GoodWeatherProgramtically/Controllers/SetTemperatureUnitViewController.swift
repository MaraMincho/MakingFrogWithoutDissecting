//
//  SetTemperatureUnitViewController.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class SetTemperatureUnitViewController: UIViewController, SetTemperatureDelegate {
    
    var setTempertureUnitView: SetTemperatureUnitView!
    
    
    override func loadView() {
        super.loadView()
        let view = SetTemperatureUnitView()
        
        self.setTempertureUnitView = view
        self.view = setTempertureUnitView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        self.title = "세팅을 설정하세요"
    }
    
    func dismissSetTemperatureScreen() {
        self.dismiss(animated: true)
    }
}


protocol SetTemperatureDelegate {
    func dismissSetTemperatureScreen()
}
