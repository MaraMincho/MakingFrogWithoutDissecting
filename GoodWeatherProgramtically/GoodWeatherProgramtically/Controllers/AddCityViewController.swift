//
//  AddCityViewController.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class AddCityViewController: UIViewController {
    var addCityView: AddCityView!
    
    
    override func loadView() {
        super.loadView()
        
        let view = AddCityView()
        view.addCityViewDelegate = self
        
        self.view = view
        self.addCityView = view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    


}



extension AddCityViewController: AddCityViewDelegate {
   
    @objc func dismissAddCityView() {
        self.dismiss(animated: true, completion: nil)
    }
}
protocol AddCityViewDelegate {
    func dismissAddCityView()
}
