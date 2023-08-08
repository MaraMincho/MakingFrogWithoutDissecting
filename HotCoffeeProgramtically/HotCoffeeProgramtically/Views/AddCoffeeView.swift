//
//  AddCoffeeView.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit

class AddCoffeeView: UIView {
    var addCoffeeVM = AddCoffeeOrderViewModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var curTableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 100
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    var testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "이거 출력 됨?"
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    func setup() {
          self.backgroundColor = .white
          setupTableViewProperty()
          setupConstraints()
      }
      
      func setupTableViewProperty() {
          curTableView.delegate = self
          curTableView.dataSource = self
          curTableView.register(AddCoffeeOrderCell.self, forCellReuseIdentifier: AddCoffeeOrderCell.identifier)
      }
      
      func setupConstraints() {
          self.addSubview(curTableView)
          curTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
          curTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
          curTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
          curTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
      }
}

extension AddCoffeeView:UITableViewDelegate, UITableViewDataSource {
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addCoffeeVM.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddCoffeeOrderCell.identifier, for: indexPath) as? AddCoffeeOrderCell else {
            fatalError("cant parse Cell")
        }
        cell.textLabel?.text = addCoffeeVM.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
