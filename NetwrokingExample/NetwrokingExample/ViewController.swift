//
//  ViewController.swift
//  NetwrokingExample
//
//  Created by MaraMincho on 2023/08/14.
//

import UIKit

class ViewController: UIViewController {

    var userData: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    
    func setup() {
        self.view.backgroundColor = .white
        getData()
    }
    
    func getData() {
        let services = NetwrokService()
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        let resource = Resource<[User]>(url: url, httpMethod: .get)
        Task {
            do {
                let data = try await services.publishWay(resource: resource)
                userData = data
                print("유저 데이터는?")
                print(userData)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}

