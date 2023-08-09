//
//  WeatherListTableViewController.swift
//  GoodWeather
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController, AddWeatherDelegate {
    
    private var weatherListViewModle = WeatherListViewModel()
    
    
    func addWeatherDidSave(vm: WeatherViewModel) {
        weatherListViewModle.addWeatherViewModel(vm)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModle.numberOfRows(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell else {
            fatalError("error")
        }
        let weatherViewModel = weatherListViewModle.modelAt(index: indexPath.row)
        cell.configure(weatherViewModel)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddWeatherCityViewController" {
            prepareSegueForAddWatherViewController(segue: segue)
        }
    }
    
    func prepareSegueForAddWatherViewController(segue: UIStoryboardSegue) {
        guard let nav = segue.destination as? UINavigationController else {
            fatalError("NavigationController not Found")
        }
        
        guard let addWeatherCityVC = nav.viewControllers.first as? AddWeatherCityViewController else {
            fatalError("AddWeatherViewController is not exists")
        }
        addWeatherCityVC.delegate = self
    }
    
}
