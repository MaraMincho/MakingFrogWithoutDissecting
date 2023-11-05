


import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
		name: "PostListViewModel",
		product: .framework,
		dependencies: [
			.PresentaionDependencies.postList.project,
		],
		resources: ["Resources/**"]
)


