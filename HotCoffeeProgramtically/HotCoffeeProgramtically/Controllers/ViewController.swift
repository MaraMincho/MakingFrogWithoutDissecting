//
//  ViewController.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit

class ViewController: UIViewController {

    var presentCurrentCoffeeOrderView:PresentCurrentCoffeeOrder!
    
    
    override func loadView() {
        super.loadView()
        presentCurrentCoffeeOrderView = PresentCurrentCoffeeOrder(frame: self.view.frame)
        self.view = presentCurrentCoffeeOrderView
        setNavigationItems()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrder()
    }

}

extension ViewController {
    func setNavigationItems() {
        self.navigationItem.title = "커피 주문 현황판"
        self.navigationItem.largeTitleDisplayMode = .automatic
        let addItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,
                                      target: self, action: #selector(presentNextView))
        addItem.tintColor = .red
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc func presentNextView() {
        let nextView = AddCoffeeViewController()
        nextView.loadViewIfNeeded()
        self.navigationController?.pushViewController(nextView, animated: true)
        
    }
}


extension ViewController {
    func getOrder() {
        guard let curURL = CoffeeOrderViewControllerConst.url else { return }
        let resource = Resource<[Order]>(url: curURL)
        
        let service = CoffeeService()
        service.load(resource: resource) { result in
            switch result {
            case .failure(let error) :
                return print(error)
            case .success(let orders) :
                self.presentCurrentCoffeeOrderView.orderVM = OrdersViewModel(orders: orders)
                DispatchQueue.main.async {
                    self.presentCurrentCoffeeOrderView.tableView.reloadData()
                }
            }
        }
    }
    
}



enum CoffeeOrderViewControllerConst {
    static let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders")
}
