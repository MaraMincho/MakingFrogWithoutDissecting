
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
		name: "PostList",
		product: .framework,
		dependencies: [
      .Presentaion.home.project
		]
)


