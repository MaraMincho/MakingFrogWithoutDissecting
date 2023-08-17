//
//  InitialSelectButton.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit

class InitialSelectButton: UIButton {
    var animator: UIViewPropertyAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.gray.cgColor
        self.backgroundColor = .blue
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        self.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(tempButtonTouch(_:)), for: .touchCancel)
        
    }
    
    @objc func ifButtonTouchUpInside(_ sender: UIButton) {
        self.layer.add(ConstOfAppAnimation.flashAnimation, forKey: nil)
    }
    @objc func ifButtonTouchDragInside(_ sender: UIButton) {
        self.layer.add(ConstOfAppAnimation.pulseAnimation, forKey: nil)
    }
    
    var darkOverlayView: UIView?
    @objc func tempButtonTouch(_ sender: UIButton) {
        print("템프")
    }

    @objc func buttonTouchDown(_ sender: UIButton) {
        print("터치 다운")
        showDarkOverlay(for: sender)
    }
      
    @objc func buttonTouchUpInside(_ sender: UIButton) {
        print("터치업")
        hideDarkOverlay()
    }

    func showDarkOverlay(for button: UIButton) {
        let overlay = UIView(frame: button.bounds)
        overlay.layer.cornerRadius = 10
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.4)
        button.addSubview(overlay)
        darkOverlayView = overlay
    }

    func hideDarkOverlay() {
        darkOverlayView?.removeFromSuperview()
    }



}
