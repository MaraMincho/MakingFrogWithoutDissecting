
import UIKit

protocol DIContainer {
  func register<T>(dependency: T)
  func resolve<T>() -> T?
}
