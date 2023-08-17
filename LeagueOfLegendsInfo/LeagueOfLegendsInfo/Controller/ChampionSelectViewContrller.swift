//
//  ChampionSelectViewContrller.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit
import SwiftSoup

class ChampionSelectVC: UIViewController, UIGestureRecognizerDelegate {
    var championSelectView:ChampionSelectView?
    var champions: [Champion] = []
    
    override func loadView() {
        super.loadView()
        self.championSelectView = ChampionSelectView()
        championSelectView?.layoutIfNeeded()
        
        self.view = self.championSelectView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        getChampion()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("끝남")
    }
    
    func getChampion() {
        Task {
            let name = await LOLServices().getChampionName()
            self.champions = champions
        }
    }
}

extension ChampionSelectVC {
    func setNavigationItem() {
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    func addGesture() {
        
    }
}
