//
//  LOLService.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/17.
//

import Foundation
import SwiftSoup

class LOLServices {
    
    private func getChampionNameDocument() async -> Document?{
        guard let url = URL(string: "https://www.leagueoflegends.com/ko-kr/champions/"),
              let html = try? String(contentsOf: url, encoding: .utf8),
              let doc: Document = try? SwiftSoup.parse(html) else {
            return nil
        }
        return doc
    }
    private func getElementsFrom(document: Document) async -> Elements? {
        return try? document.select(".style__Wrapper-sc-13btjky-0.style__ResponsiveWrapper-sc-13btjky-4.kKksmy.SHyYQ > div.style__List-sc-13btjky-2.IorQY > a")
    }
    func getChampionName() async -> [Champion] {
        let champ = Task {
            let doc = await getChampionNameDocument()!
            let elements = await getElementsFrom(document: doc)!
            var champions:[Champion] = []
            elements.forEach{ element in
                guard let name = try? element.select("span.style__Name-sc-n3ovyt-2.fHdhXn").text(),
                      let link = try? element.attr("href")
                else{
                    return
                }
                champions.append(Champion(korName: name, engName: String(link.split(separator: "/").last!)))
            }
            return champions
        }
        return await champ.value
    }
}

struct Resource<T> {
    let url: URL
    let httpMethod: HTTPMethod = .get
    let body: Data? = nil
    
    
}

enum HTTPMethod: String {
    case get = "GET"
    case POST = "POST"
}

