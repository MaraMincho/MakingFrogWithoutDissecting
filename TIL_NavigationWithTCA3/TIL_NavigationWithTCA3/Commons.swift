//
//  Commons.swift
//  TIL_NavigationWithTCA3
//
//  Created by MaraMincho on 6/15/24.
//

import Foundation
import ComposableArchitecture

protocol ReucerStateContainerable {
  var container: [String: Any] { get }
  func save<T: CaseReducerState>(state: T)
  func getReducer<T:Reducer>(_ reducer: T.Type) -> T?
}


protocol PushNavigationDestination {
  associatedtype Destinations
}

protocol Factoryable: PushNavigationDestination {
  func buildDestinationState<T: Reducer>(_ val: Destinations, state: T.State, reducer: T)
}

protocol Routingable: PushNavigationDestination {}
