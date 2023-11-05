

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
		name: "HomeViewModel",
		product: .framework,
		dependencies: [
			.Presentaion.home.project,
		]
)


