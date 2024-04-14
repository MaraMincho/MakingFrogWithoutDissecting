
import Foundation
import ProjectDescription

private let isCI = ProcessInfo.processInfo.environment["TUIST_CI"] != nil

public extension Project {
  static func makeModule(
    name: String,
    targets: [Target],
    packages: [Package] = []
  ) -> Project {
    let settingConfiguration: [Configuration] = [.debug(name: .debug)]

    let settings: Settings = .settings(
      base: ["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES"],
      configurations: settingConfiguration
    )

    return Project(
      name: name,
      organizationName: "io.tuist.TILTuistExample",
      options: .options(automaticSchemesOptions: .disabled, disableBundleAccessors: true, disableSynthesizedResourceAccessors: true),
      packages: packages,
      settings: settings,
      targets: targets
    )
  }
}

public extension Path {
  static func relativeToXCConfig(_ path: String = "Shared") -> Path {
    print("XCConfig/\(path).xcconfig")
    return .relativeToRoot("XCConfig/\(path).xcconfig")
  }

  static func relativeToXCConfigString(_ path: String = "Shared") -> String {
    return "XCConfig/\(path).xcconfig"
  }
}
