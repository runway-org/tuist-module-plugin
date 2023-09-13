import ProjectDescription

/// This is a convenience wrapper that will let us strongly type our modules.
public struct ModuleName: ExpressibleByStringLiteral, Hashable {
    public let name: String

    public init(name: String) {
        self.name = name
    }

    public init(stringLiteral value: String) {
        self.name = value
    }
}

extension ModuleName {
    /// The test target name for a given module
    public var tests: ModuleName {
        return ModuleName(name: "\(self.name)Tests")
    }

    /// The resource bundle name for a given module
    public var resources: ModuleName {
        return ModuleName(name: "\(self.name)Resources")
    }
}

extension TargetDependency {
    /// Creates a target dependency on a module
    /// - Parameter module: The module to depend on.
    /// - Returns: The dependency for the calling module.
    public static func moduleName(_ module: ModuleName) -> TargetDependency {
        return .target(name: module.name)
    }
}

extension String {
    /// Creates a bundle identifier from the given module
    /// - Parameter module: The module who's bundle needs identifying
    /// - Returns: The bundle identifier for a module
    public static func bundleID(from module: ModuleName) -> String {
        return "\(PluginConfiguration.bundleBaseID).\(module.name)"
    }
}
