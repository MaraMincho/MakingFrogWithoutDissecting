//
//  ServiceError.swift
//  HotCoffeeProgramtically
//
//  Created by MaraMincho on 2023/08/08.
//

import Foundation

enum ServiceError: Error, LocalizedError {
    case serviceError
    case jsonDecodeError
    case noData
}

