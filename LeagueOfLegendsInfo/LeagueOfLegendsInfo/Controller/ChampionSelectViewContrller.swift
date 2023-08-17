//
//  ChampionSelectViewContrller.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit
import SwiftSoup

class ChampionSelectVC: UIViewController, UIGestureRecognizerDelegate, ChampionsPortraitDelegate {
    var championSelectView:ChampionSelectView?
    var champions: [Champion] = []
    
    override func loadView() {
        super.loadView()
        self.championSelectView = ChampionSelectView(frame: self.view.frame)
        self.championSelectView!.viewModel = self
        self.championSelectView!.layoutIfNeeded()
        
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
            self.champions = await ChampionUserDefaults().getChampion()
            DispatchQueue.main.async {
                self.championSelectView!.reloadchampionsPortraitsCollectionView()
            }
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
        //TODO: 입력하다가 다른 곳 클릭하면 isEditing = false하는 코드 추가
    }
}



protocol ChampionsPortraitDelegate {
    var champions: [Champion] {get}
}
