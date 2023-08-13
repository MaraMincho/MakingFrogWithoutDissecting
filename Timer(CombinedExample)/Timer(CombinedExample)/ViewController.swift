//
//  ViewController.swift
//  Timer(CombinedExample)
//
//  Created by MaraMincho on 2023/08/13.
//

import UIKit
import Combine


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 25, weight: .heavy, width: .standard)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    @Published var currentCount: Int = 0
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("increase", for: .normal)
        button.addTarget(self, action: #selector(increaseCurrentCount), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func increaseCurrentCount() {
        self.currentCount += 1
        cancellables.map{$0.cancel()}
    }
    
    var isWork = true
    var cancellables: Set<AnyCancellable> = []
}


extension ViewController {
    private func setup() {
        self.view.backgroundColor = .white
        
        setupConstraints()
        tiktok()
        setupBind()
    }
    
    private func tiktok() {
        DispatchQueue.global().async { [weak self] in
            while true {
                sleep(1)
                self?.currentCount += 1
            }
        }
    }
    
    private func setupBind() {
        let currentValueSubject = CurrentValueSubject<String, Error>("")
        let subscriber = currentValueSubject
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { (result) in
                switch result {
                case .failure(let error) :
                    print(error)
                case .finished :
                    print("끝났어용")
                }
            } receiveValue: { value in
                print(value)
                self.timerLabel.text = value
            }
        
        currentValueSubject.send("123213")
        DispatchQueue.global().async { [weak self] in
            while true {
                sleep(1)
                let value = String(self?.currentCount ?? 0 + 1)
                currentValueSubject.send(value)
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(timerLabel)
        timerLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        timerLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: 30).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}

