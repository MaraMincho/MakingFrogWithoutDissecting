//
//  InitialSelectScreen.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit

class MeetUpView: UIView {
    var meetUpResource: MeetUpDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private let initialBackgroundImage: UIImageView = {
        var targetImage = UIImage(named: "InitialScreen")
        targetImage = targetImage?.adjustedBrightness(-0.2)
        targetImage = targetImage?.applyGausianBlur(radius: 6)
        
        let imageView = UIImageView(image: targetImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let titleLogo: UIImageView = {
        
        var image = UIImage(named: "LeagueOfLegends")!
        image = image.applyGausianBlur(radius: 1)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.addShadow()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    

    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLogo])
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.spacing = 25
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let selectButton: InitialSelectButton = {
        let button = InitialSelectButton()
        button.setTitle("눌러서 시작하기", for: .normal)
        button.titleLabel?.font = ConstOfFontUnit.titleFont
        button.addTarget(self, action: #selector(getNextVC(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    @objc func getNextVC(_ sender:UIButton) {
//        sender.layer.add(ConstOfAppAnimation.flashAnimation, forKey: nil)
        meetUpResource?.getToChampionSelectVC()
    }
    
    
    func setup() {
        self.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
        let safeAreaLayoutGuide = self.safeAreaLayoutGuide
        
        self.addSubview(initialBackgroundImage)
        initialBackgroundImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        initialBackgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        initialBackgroundImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        initialBackgroundImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.addSubview(titleStackView)
        titleStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        titleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        
        self.addSubview(selectButton)
        selectButton.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 200).isActive = true
        selectButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        selectButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
}
