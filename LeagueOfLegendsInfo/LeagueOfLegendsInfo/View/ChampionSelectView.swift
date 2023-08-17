//
//  ChampionSelectView.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit

class ChampionSelectView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챔피언을 선택하세요"
        label.font = ConstOfFontUnit.titleFont
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineAndInputTextView: LineAndInputTextView = {
        let view = LineAndInputTextView()

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setup() {
        self.backgroundColor = .white
        setupConstraints()
        
    }
    

    
    func setupConstraints() {
        
        let safeAreaLayoutGuide = self.safeAreaLayoutGuide
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
//        self.addSubview(lineAndInputTextView)
//        lineAndInputTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
//        lineAndInputTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
//        lineAndInputTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
    }
}

