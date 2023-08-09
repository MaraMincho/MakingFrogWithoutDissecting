//
//  AddCoffeeView.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import UIKit

class AddCoffeeView: UIView, UITextFieldDelegate {
    var addCoffeeVM = AddCoffeeOrderViewModel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let curTableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = UITableView.automaticDimension
        tb.estimatedRowHeight = 100
        
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    let testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "이거 출력 됨?"
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    let emailTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력하세요"
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.clearButtonMode = .always
        tf.contentMode = .right
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름을 입력하세요"
        tf.borderStyle = .roundedRect
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.clearButtonMode = .whileEditing
        tf.contentMode = .bottomLeft
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    func setup() {
        self.backgroundColor = .white
        setupSegmentedControlls()
        setupTableViewProperty()
        setupTextFiledDelegate()
        setupConstraints()
    }
      
    
    
    func setupTextFiledDelegate() {
        nameTextFiled.delegate = self
        emailTextFiled.delegate = self
        
        
    }
    var coffeeSizeSegmentedControl:UISegmentedControl!
    func setupSegmentedControlls() {
        let coffeeSizeSegmentedControl = UISegmentedControl(items: addCoffeeVM.sizes)
        coffeeSizeSegmentedControl.selectedSegmentTintColor = .systemBlue
        coffeeSizeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.coffeeSizeSegmentedControl = coffeeSizeSegmentedControl
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
        curTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 300).isActive = true
        
        self.addSubview(coffeeSizeSegmentedControl)
        coffeeSizeSegmentedControl.topAnchor.constraint(equalTo: curTableView.bottomAnchor, constant: 30).isActive = true
        coffeeSizeSegmentedControl.leadingAnchor.constraint(equalTo: curTableView.leadingAnchor, constant: 40).isActive = true
        coffeeSizeSegmentedControl.trailingAnchor.constraint(equalTo: curTableView.trailingAnchor, constant: -40).isActive = true
        
        self.addSubview(nameTextFiled)
        nameTextFiled.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        nameTextFiled.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(emailTextFiled)
        emailTextFiled.bottomAnchor.constraint(equalTo: nameTextFiled.topAnchor, constant: -10).isActive = true
        emailTextFiled.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
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
        cell.detailTextLabel?.text = addCoffeeVM.sizes[indexPath.row]
        cell.textLabel?.text = addCoffeeVM.types[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        curTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

