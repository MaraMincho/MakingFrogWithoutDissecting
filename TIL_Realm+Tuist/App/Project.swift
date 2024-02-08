import ProjectDescription

let project = Project(
    name: "App",
    
    targets: [
        .target(
            name: "App",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.App",
            infoPlist: .dictionary([
              "CFBundleDisplayName": "$(PRODUCT_NAME)",
              "CFBundleVersion": "1.0.0",
              "CFBundleShortVersionString": "1.0.0",
              "UILaunchStoryboardName": "LaunchScreen",
              "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                  "UIWindowSceneSessionRoleApplication": [
                    [
                      "UISceneConfigurationName": "Default Configuration",
                      "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                    ],
                  ],
                ],
              ],
            ]),
            sources: "Sources/**",
            dependencies: [
                //.project(target: "Framework", path: "../Framework"),
            ]
        ),
    ]
)
