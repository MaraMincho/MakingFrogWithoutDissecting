
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
		name: "Home",
		product: .framework,
		dependencies: [
      .Presentaion.homeViewModel.project
		]
)
