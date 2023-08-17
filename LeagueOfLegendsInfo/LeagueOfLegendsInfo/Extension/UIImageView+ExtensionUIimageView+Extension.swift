//
//  UIimageView+Extension.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit

extension UIImageView {
    func addShadow(cgColor: UIColor = .black, shadowRadius: CGFloat = 3.0, shadowOpacity: CGFloat = 1.0, shadowOffset: CGSize = CGSize(width: 4, height: 4)) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.masksToBounds = false
    }
}
