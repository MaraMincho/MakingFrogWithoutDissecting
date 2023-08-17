//
//  ChampionSelectView.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit

class ChampionSelectView: UIView {
    var viewModel: ChampionsPortraitDelegate?
    
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
        label.addShadow(shadowOpacity: 0.3)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var lineAndInputTextView: UIView = {
        let view = LineAndInputTextView()
        view.addShadow(shadowOpacity: 0.03)
        
        view.contentMode = .scaleAspectFit
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let champInputTextFieldView: UIView = {
        let view = ChampionInputTextFiledView()
        view.addShadow(shadowOpacity: 0.03)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var championsPortraitsCollectionView: ChampionsPortraitCollectionView = {
        let view = ChampionsPortraitCollectionView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .red
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public func reloadchampionsPortraitsCollectionView() {
        championsPortraitsCollectionView.viewModel = self.viewModel
        championsPortraitsCollectionView.reloadCahmpionsPortraitCollectionView()
    }
    
    private func setup() {
        self.backgroundColor = .white
        setupConstraints()
    }
    

    
    func setupConstraints() {
        let size = self.frame.size
        let safeAreaLayoutGuide = self.safeAreaLayoutGuide
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        self.addSubview(lineAndInputTextView)
        lineAndInputTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        lineAndInputTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        lineAndInputTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -(size.width / 5) * 1 - 65).isActive = true
        lineAndInputTextView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.addSubview(champInputTextFieldView)
        champInputTextFieldView.centerYAnchor.constraint(equalTo: lineAndInputTextView.centerYAnchor).isActive = true
        champInputTextFieldView.leadingAnchor.constraint(equalTo: lineAndInputTextView.trailingAnchor, constant: 15).isActive = true
        champInputTextFieldView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        champInputTextFieldView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(championsPortraitsCollectionView)
        championsPortraitsCollectionView.topAnchor.constraint(equalTo: lineAndInputTextView.bottomAnchor, constant: 10).isActive = true
        championsPortraitsCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        championsPortraitsCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        championsPortraitsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 15).isActive = true
    }
}

