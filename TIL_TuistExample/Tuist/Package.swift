// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    //      productTypes: ["Alamofire": .framework]
  )
#endif

let package = Package(
  name: "TILTuistExample",
  dependencies: [
    // Add your own dependencies here:
    .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.1"),
    .package(url: "https://github.com/realm/realm-swift.git", exact: "10.49.1"),
    // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
  ]
)
