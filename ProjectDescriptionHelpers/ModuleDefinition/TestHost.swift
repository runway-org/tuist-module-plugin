import Foundation
import ProjectDescription

extension Module {
    public static var testHost: Module {
        return Module(name: .testHost, config: moduleConfig)
    }
}

// Defines a static instance of your module's name, usable by other targets to create dependencies
extension ModuleName {
    public static var testHost: ModuleName = "TestHost"
}

private let moduleConfig = Module.Config(
    product: .custom(.app),
    hasResources: false,
    testConfig: nil
)
