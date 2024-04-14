import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "TILTuistExample",
  targets: [
    .target(
      name: "TILTuistExample",
      destinations: .iOS,
      product: .app,
      bundleId: "io.tuist.TILTuistExample",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]
      ),
      sources: ["TILTuistExample/Sources/**"],
      resources: ["TILTuistExample/Resources/**"],
      scripts: [.swiftLint, .swiftFormat],
      dependencies: [
        //              .project(target: "BookFeature", path: "Projects/Features/Book/", condition: .none),
        .external(name: "Alamofire", condition: .none),
        .external(name: "RealmSwift", condition: .none),
      ]
    ),
    .target(
      name: "TILTuistExampleTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "io.tuist.TILTuistExampleTests",
      infoPlist: .default,
      sources: ["TILTuistExample/Tests/**"],
      resources: [],
      dependencies: [.target(name: "TILTuistExample")]
    ),
  ]
)
