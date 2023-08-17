//
//  UIimageView+Extension.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit

extension UIView {
    func addShadow(cgColor: UIColor = .black, shadowRadius: CGFloat = 3.0, shadowOpacity: Float = 1.0, shadowOffset: CGSize = CGSize(width: -2, height: 2)) {
        self.layer.shadowColor = cgColor.cgColor
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
    }
}
