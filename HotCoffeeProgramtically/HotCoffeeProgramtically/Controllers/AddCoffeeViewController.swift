//
//  AddCoffeeViewController.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit


class AddCoffeeViewController: UIViewController {
    var addCoffeeView:AddCoffeeView!
    var presentOrderDelegate: AddOrderWhileNavigation!
    
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
        
        let saveNavigationItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveOrder))
        self.navigationItem.rightBarButtonItem = saveNavigationItem
    }
    
    @objc func saveOrder() {
        
        guard let curOrder = getCurrentUserOrder() else {return}
        guard postCurOrder(order: curOrder) == true else {return}
        DispatchQueue.main.async {
            self.presentOrderDelegate.AddOrderInCurrentTableView(order: curOrder, currentViewController: self)
        }
       
    }
    
    private func postCurOrder(order: Order) -> Bool {
        let curData = try? JsonHelper.jsonEncoder.encode(order)
        guard let url = CoffeeOrderURL.url else {return false}
        let resource = Resource<Order>(url: url, data: curData, httpMethod: .post)
        
        let service = CoffeeServiceHelper.cofffeeService
        var isComplete = true
        service.load(resource: resource) { result in
            switch result {
            case .failure(let error) :
                print(error)
            case .success(let order) :
                print("\(order) 전송에 성공하였습니다.")
                isComplete = true
            }
        }
        return isComplete
    }
    
    
    private func getCurrentUserOrder() -> Order? {
        let tempSize = addCoffeeView.coffeeSizeSegmentedControl.selectedSegmentIndex
        guard let tempEmail = addCoffeeView.emailTextFiled.text else {return nil}
        guard let tempName = addCoffeeView.nameTextFiled.text else {return nil}
        
        guard let email = tempEmail == "" ? nil : tempEmail,
              let name = tempName == "" ? nil : tempName,
              let coffeeType = addCoffeeView.curTableView.indexPathForSelectedRow?.row,
              let size = tempSize == -1 ? nil :  tempSize
        else {
            return nil
        }
        
        let curOrderVM = addCoffeeView.addCoffeeVM
        
        let coffeeTypeString = curOrderVM.types[coffeeType]
        guard let curCoffeeType = CoffeeType(rawValue: coffeeTypeString) else { return nil}
        
        let coffeeSizeString = curOrderVM.sizes[size]
        guard let curCoffeeSize = CoffeeSize(rawValue: coffeeSizeString) else {return nil}
        return Order(name: name, email: email, type: curCoffeeType, size: curCoffeeSize)
    }
}
