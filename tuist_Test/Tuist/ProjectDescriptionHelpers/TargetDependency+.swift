//
//  TargetDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by MaraMincho on 11/5/23.
//
import ProjectDescription

extension TargetDependency {
	public enum PresentaionDependencies: String {
		case home
		case homeViewModel
		case postList
		case postListViewModel
		
		public var project: TargetDependency {
			switch self {
			case .home:
				return makeProjectPath(targetName: "Home", layer: .View)
			case .homeViewModel:
				return makeProjectPath(targetName: "HomeViewModel", layer: .View)
			case .postList:
				return makeProjectPath(targetName: "PostList", layer: .View)
			case .postListViewModel:
				return makeProjectPath(targetName: "PostListViewModel", layer: .View)
			}
		}
		
		private func makeProjectPath(targetName: String, layer: ProjectLayer) -> TargetDependency{
			return .project(target: targetName, path: .relativeToRoot("Projects/\(layer.rawValue)/\(targetName)"))
		}
	}
	
	public enum ProjectLayer: String {
		case View
		case ViewModel
		case UseCase
		case Entity
		case RepositoryInterface
	}
}
