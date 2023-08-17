//
//  ConstOfAppUnit.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit


enum ConstOfAppFontNameUnit {
    static let bold = "GmarketSansTTFBold"
    static let medium = "GmarketSansTTFMedium"
    static let light = "GmarketSansTTFLight"
}

enum ConstOfFontUnit {
    static let titleFont = UIFont(name: ConstOfAppFontNameUnit.bold, size: 25)
    static let largeFont = UIFont(name: ConstOfAppFontNameUnit.bold, size: 15)
    static let mediumFont = UIFont(name: ConstOfAppFontNameUnit.medium, size: 15)
    static let descriptionFont = UIFont(name: ConstOfAppFontNameUnit.light, size: 12)
    static let LinedescriptionFont = UIFont(name: ConstOfAppFontNameUnit.light, size: 8)
}


enum ConstOfAppAnimation {
    static let pulseAnimation: CASpringAnimation = {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        return pulse
    }()
    
    static let flashAnimation: CABasicAnimation = {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.1
        flash.fromValue = 1
        flash.toValue = 0.7
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        return flash
    }()
    
    static let infinityClickedAniamtion: CABasicAnimation = {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = .infinity
        flash.fromValue = 1
        flash.toValue = 0.7
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        return flash
    }()
}
