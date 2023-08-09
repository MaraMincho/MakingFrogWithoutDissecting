//
//  LoginViewModel.swift
//  BindingMVVM
//
//  Created by MaraMincho on 2023/08/09.
//

import Foundation

class Dynamic<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(callback: @escaping(T) -> Void) {
        self.listener = callback
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    
    
}


struct LoginViewModel {
    var userName = Dynamic("")
    var password = Dynamic("")
}
