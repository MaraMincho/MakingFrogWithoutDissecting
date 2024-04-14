import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "BookFeature",
  targets: [
    .target(
      name: "BookFeature",
      destinations: .iOS,
      product: .framework,
      bundleID: "io.tuist.TILTuistExample",
      sources: ["Sources/**"],
      scripts: [
      ],
      dependencies: [
        .external(name: "Alamofire", condition: .none),
      ]
    ),
  ]
)
