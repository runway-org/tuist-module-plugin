# Tuist Module Plugin

This repo serves as a plugin to the excellent [Tuist](https://tuist.io) Xcode project generator. The plugin adds functionality to easily create a module structure for your repository. Check out the [Runway blog post](https://www.runway.team/blog/getting-started-with-tuist-for-xcode-project-generation-and-modularization-on-ios) for an introduction to Tuist an the structure of modules.

## Getting Started

Using this plugin from Tuist is straightforward. In your Config.swift file add this entry:

```swift
let config = Config(
    plugins: [
        .git(url: "https://github.com/runway-org/tuist-module-plugin", tag: "1.0.0")
    ]
)
```

Inside of your ProjectDescriptionHelpers you can declare modules like this:

```swift
import Foundation
import ProjectDescription
import ModuleDescription

extension Module {
    public static var sampleApp: Module {
        .init(name: .sampleApp, config: appConfig)
    }
}

extension ModuleName {
    public static var sampleApp: ModuleName = "App"
}

private let appConfig = Module.Config(
    dependencies: [
        // Your other modules
    ],
    product: .custom(.app),
    testConfig: Module.TestConfig(hasResources: false)
)
```

From there the Project.swift becomes much simpler:

```swift
import ProjectDescription
import ProjectDescriptionHelpers
import ModuleDescription

let project = Project(
    bundleID: bundleBaseID,
    modules: [
        .sampleApp,
        // Your other modules
    ]
)
```
