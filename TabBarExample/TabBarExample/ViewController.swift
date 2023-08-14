//
//  ViewController.swift
//  TabBarExample
//
//  Created by MaraMincho on 2023/08/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        let view01 = UIViewController()
        let view02 = UIViewController()
        let view03 = UIViewController()
        
        self.setViewControllers([view01, view02, view03], animated: true)
        
        view01.tabBarItem = UITabBarItem(title: "첫 번째 아이템", image: UIImage(systemName: "calendar"), tag: 0)
        view02.tabBarItem = UITabBarItem(title: "두 번째 아이템", image: UIImage(systemName: "photo"), tag: 1)
        view03.tabBarItem = UITabBarItem(title: "세 번째 아이템", image: UIImage(systemName: "star"), tag: 2)
        
        self.tabBar.backgroundColor = .brown
        self.tabBar.barTintColor = .blue
        
        
        self.tabBar.tintColor = .red
    }
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }

    

}

class TestViewController: UIViewController {

    override func loadView() {
        super.loadView()
        view.backgroundColor = .blue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }

    

}

