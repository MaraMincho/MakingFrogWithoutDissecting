//
//  PresentCurrentCoffeeOrder.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation
import UIKit


class PresentCurrentCoffeeOrder:UIView {
    var orderVM = OrdersViewModel(orders: [])
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    var tableView:UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
}


extension PresentCurrentCoffeeOrder:UITableViewDelegate, UITableViewDataSource {

    
    func setup() {
        self.backgroundColor = .white
        setupTableViewProperty()
        setupConstraints()
    }
    
    
    func setupTableViewProperty() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PresentCurrentCoffeeOrderTableViewCell.self, forCellReuseIdentifier: PresentCurrentCoffeeOrderTableViewCell.identifier)
    }
    
    func setupConstraints() {
        self.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderVM.numOfOrders()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PresentCurrentCoffeeOrderTableViewCell.identifier, for: indexPath) as? PresentCurrentCoffeeOrderTableViewCell
        else {
            fatalError("셀을 설정 요류")
        }
        cell.titleLabel.text = orderVM.currentOrder(index: indexPath.row).titleLabelText
        cell.descriptionLabel.text = orderVM.currentOrder(index: indexPath.row).descriptionText
        return cell
    }
    
}




