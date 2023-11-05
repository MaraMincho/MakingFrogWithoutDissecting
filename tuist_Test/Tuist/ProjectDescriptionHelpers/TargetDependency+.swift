//
//  TargetDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/5/23.
//
import ProjectDescription

extension TargetDependency {
  public enum Presentaion: String {
    case home
    case homeViewModel
    case postList
    case postListViewModel
    
    public var project: TargetDependency {
      switch self {
      case .home:
        return makeProjectPath(targetName: "Home", layer: .Presentaion(layer: .View))
      case .homeViewModel:
        return makeProjectPath(targetName: "HomeViewModel", layer: .Presentaion(layer: .ViewModel))
      case .postList:
        return makeProjectPath(targetName: "PostList", layer: .Presentaion(layer: .View))
      case .postListViewModel:
        return makeProjectPath(targetName: "PostListViewModel", layer: .Presentaion(layer: .ViewModel))
      }
    }
  }
  
  public enum Shared: String {
    case DIContainer
    
    public var project: TargetDependency {
      switch self {
      case .DIContainer:
        return .makeProjectPath(targetName: "DIContainer", layer: .Shared)
      }
    }
  }
  
  
  
  private static func makeProjectPath(targetName: String, layer: ProjectLayer) -> TargetDependency{
    return .project(target: targetName, path: .relativeToRoot("Projects/\(layer.path)\(targetName)"))
  }
  
  public enum ProjectLayer {
    case Presentaion(layer: PresentaionLayer)
    case Domain(layer: DomainLayer)
    case Data(layer: DataLayer)
    case Shared
    
    var path: String {
      switch self {
      case .Presentaion(let layer):
        return "\(layer)"
      case .Domain(let layer):
        return "\(layer)"
      case .Data(let layer) :
        return "\(layer)"
      case .Shared:
        return ""
      }
    }
  }
  
  public enum DataLayer: CustomStringConvertible {
    case Repository
    case Network
    case Persistence
    
    public var description: String {
      switch self {
      case .Repository:
        return "Data/Repository/"
      case .Network:
        return "Data/Network/"
      case .Persistence:
        return "Data/Persistence/"
      }
    }
  }
  
  public enum PresentaionLayer: CustomStringConvertible {
    case View
    case ViewModel
    
    public var description: String {
      switch self {
      case .View:
        return "Presentation/View/"
      case .ViewModel:
        return "Presentation/ViewModel/"
      }
    }
  }
  
  public enum DomainLayer: CustomStringConvertible {
    case UseCase
    case Entity
    case RepositoryInterface
    
    public var description: String {
      switch self {
      case .UseCase:
        return "Domain/UseCase/"
      case .Entity:
        return "Domain/Entity/"
      case .RepositoryInterface:
        return "Domain/RepositoryInterface/"
      }
    }
  }
}
