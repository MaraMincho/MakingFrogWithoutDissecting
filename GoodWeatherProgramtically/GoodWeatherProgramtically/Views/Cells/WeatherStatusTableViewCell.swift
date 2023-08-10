//
//  WeatherStatusTableViewCell.swift
//  GoodWeatherProgramtically
//
//  Created by MaraMincho on 2023/08/10.
//

import UIKit

class WeatherStatusTableViewCell: UITableViewCell {

    static let identifier = "WeatherStatusTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        steup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        steup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func steup() {
        setupConstraints()
        self.selectionStyle = .none
    }

}
extension WeatherStatusTableViewCell {
    private func setupConstraints() {
        self.addSubview(cityLabel)
        cityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        self.addSubview(degreeLabel)
        degreeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        degreeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func setupLabelText(weatherVM: WeatherViewModel, tempType: TemperatureUnit) {
        cityLabel.text = weatherVM.cityName
        var degree = String(format: "%.2f", tempType == .celsius ? weatherVM.degree : weatherVM.fahrenheitDegree)
        degree = tempType == .celsius ? degree + "℃" : degree + "℉"
        degreeLabel.text = degree
    }
}
