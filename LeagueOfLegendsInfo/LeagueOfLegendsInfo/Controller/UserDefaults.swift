//
//  UserDefaults.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import Foundation

struct ChampionUserDefaults {
    func getChampion() async ->[Champion] {
        guard let champions = UserDefaults.standard.object(forKey: "ChampionsName") as? [Champion] else {
            return await Task {
                let name = await LOLServices().getChampionName()
                return name
            }.value
        }
        return champions
    }
}
