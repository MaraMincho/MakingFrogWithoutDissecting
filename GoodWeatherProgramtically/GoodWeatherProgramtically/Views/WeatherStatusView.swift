//
//  WeatherStatusView.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class WeatherStatusView: UIView {
    var weatherListVM: WeatherListViewModel!
    var userTemperatureViewModel = UserTemperatureViewModel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        self.backgroundColor = .white
        setupTableViewProperty()
        setupConstraints()
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

}
extension WeatherStatusView:UITableViewDelegate, UITableViewDataSource {

    private func setupConstraints() {
        self.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupTableViewProperty() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherStatusTableViewCell.self, forCellReuseIdentifier: WeatherStatusTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListVM.numOfCitys()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherStatusTableViewCell.identifier, for: indexPath) as? WeatherStatusTableViewCell else{
            return UITableViewCell()
        }
        
//        let tempVM = WeatherViewModel(weather: WeatherResponse(name: "멜버른", main: Weather(temp: 20.0, humidity: 10.0)))
        let tempVM = weatherListVM.weatherViewModel(index: indexPath.row)
        cell.setupLabelText(weatherVM: tempVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.weatherListVM.deleteViewModel(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}


extension WeatherStatusView {
    
}
