


import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
		name: "PostListViewModel",
		product: .framework,
		dependencies: [
			.Presentaion.postList.project,
		]
)


