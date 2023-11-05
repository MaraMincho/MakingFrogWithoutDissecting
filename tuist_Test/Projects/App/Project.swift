import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "PostList",
    platform: .iOS,
    product: .app,
    dependencies: [
        
    ],
    resources: ["Resources/**"],
    infoPlist: .extendingDefault(with: [
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "ENABLE_TESTS": .boolean(true),
    ])
)