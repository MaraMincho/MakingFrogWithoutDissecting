//
//  SetTempartureUnitView.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class SetTemperatureUnitView: UIView {
    
    var setTemperatrueDelegate: SetTemperatureDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = .white
        
        setupTableViewProperty()
        setupConstraints()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.text = "설정할 단위를 클릭하세요"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView:UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

extension SetTemperatureUnitView:UITableViewDataSource, UITableViewDelegate {
    func setupTableViewProperty() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SetTemperatureTableViewCell.self, forCellReuseIdentifier: SetTemperatureTableViewCell.identifier)
    }
    
    func setupConstraints() {
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        self.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetTemperatureTableViewCell.identifier, for: indexPath) as? SetTemperatureTableViewCell
        else {
            fatalError("it isnt work")
        }
        cell.textLabel?.text = "섭씨"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        return indexPath
    }
}
