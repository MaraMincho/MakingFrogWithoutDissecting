import ProjectDescription
import Foundation

public extension Project {
  static func makeModule(
    name: String,
    platform: Platform = .iOS,
    product: Product,
    organizationName: String = "MaraMincho",
    packages: [Package] = [],
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
    dependencies: [TargetDependency] = [],
    sources: SourceFilesList = ["Sources/**"],
    resources: ResourceFileElements? = ["Resources/**"],
    infoPlist: InfoPlist = .default,
    scripts: [TargetScript] = []
  ) -> Project {
    let settings: Settings = .settings(
      base: [:],
      configurations: [
        .debug(name: .debug),
        .release(name: .release)
      ], defaultSettings: .recommended)
    
    let appTarget = Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: "\(organizationName).\(name)",
      deploymentTarget: deploymentTarget,
      infoPlist: infoPlist,
      sources: sources,
      resources: resources,
      scripts: scripts + [.swiftlint],
      dependencies: dependencies
    )
    
    let testTarget = Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "\(organizationName).\(name)Tests",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [.target(name: name)]
    )
    
    let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
    
    let targets: [Target] = [appTarget, testTarget]
    
    return Project(
      name: name,
      organizationName: organizationName,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes
    )
  }
}

extension Scheme {
  static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
    return Scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: ["\(name)"]),
      testAction: .targets(
        ["\(name)Tests"],
        configuration: target,
        options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
      ),
      runAction: .runAction(configuration: target),
      archiveAction: .archiveAction(configuration: target),
      profileAction: .profileAction(configuration: target),
      analyzeAction: .analyzeAction(configuration: target)
    )
  }
}

extension TargetScript {
  static let swiftlint = TargetScript.pre(
    script: 
    """
    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
    ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
}
