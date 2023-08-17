//
//  ViewController.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit
import SwiftSoup

class MeetUpVC: UIViewController, MeetUpDelegate {
    private var iniitalView: MeetUpView!
    
    override func loadView() {
        super.loadView()
        
        self.iniitalView = MeetUpView()
        self.iniitalView.meetUpResource = self
        self.view = self.iniitalView
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc func getToChampionSelectVC() {
        
        let nextVC = ChampionSelectVC()
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

protocol MeetUpDelegate {
    func getToChampionSelectVC()
}

