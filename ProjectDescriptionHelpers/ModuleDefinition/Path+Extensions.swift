import ProjectDescription

extension Path {
    /// Creates a path to the dependencies directory and appends the given additional path
    /// - Parameter pathStr: The path to append
    /// - Returns: The path inside of the dependencies directory
    public static func relativeToDeps(_ path: String) -> Path {
        Path.relativeToRoot("Dependencies").appending(path)
    }

    /// Creates a path to the Carthage built products directory and appends the given additional path
    /// - Parameter pathStr: The path to append
    /// - Returns: The path inside of the Carthage products directory
    static func relativeToCarthageDir(_ path: String) -> Path {
        Path.relativeToRoot("Tuist/Dependencies/Carthage/Build").appending(path)
    }

    /// Creates a path to the binaries directory (inside of dependencies) and appends the given additional path
    /// - Parameter pathStr: The path to append
    /// - Returns: The path inside of the dependencies directory
    public static func relativeToBinaries(_ path: String) -> Path {
        Path.relativeToDeps("Binaries").appending(path)
    }

    /// Creates a path to the tools directory and appends the given additional path
    /// - Parameter pathStr: The path to append
    /// - Returns: The path inside of the tools directory
    public static func relativeToTools(_ path: String) -> Path {
        Path.relativeToRoot("Tools").appending(path)
    }
}

extension Path {
    /// Defines a sub-directory that a module can have
    public struct SubdirectoryType: RawRepresentable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static var sources = SubdirectoryType(rawValue: "Sources")
        public static var tests = SubdirectoryType(rawValue: "Tests")
        public static var resources = SubdirectoryType(rawValue: "Resources")
        public static var config = SubdirectoryType(rawValue: "xcconfig")
        public static var supporting = SubdirectoryType(rawValue: "Supporting")
    }

    /// Creates a path to the given module's root
    /// - Parameter moduleName: The module who's path is needed
    /// - Returns: The path to the root of a module
    public static func modulePath(for moduleName: ModuleName) -> Path {
        .relativeToRoot("Modules/\(moduleName.name)")
    }

    /// Creates a path to the given subdirectory type for a module.
    /// - Parameters:
    ///   - moduleName: The module who's subdirectory is needed
    ///   - type: The type of subdirectory to append to the module path
    /// - Returns: The full path to the module/subdirectory (i.e. MyFramework/Sources)
    public static func moduleSubdirectory(for moduleName: ModuleName, type: SubdirectoryType) -> Path {
        Path.modulePath(for: moduleName).appending(type.rawValue)
    }

    /// The path to a module's info.plist file
    /// - Parameter moduleName: The module who's info.plist is needed
    /// - Returns: The full path to the module's info.plist file
    public static func infoPlistPath(for moduleName: ModuleName) -> Path {
        Path.moduleSubdirectory(for: moduleName, type: .supporting).appending("Info.plist")
    }

    /// The path to a module's sources directory (a shortcut from calling
    /// `moduleSubdirectory(for: module, type: .sources)`)
    /// - Parameter moduleName: The module who's sources are needed
    /// - Returns: The full path to the module's sources directory
    public static func sourcesPath(for moduleName: ModuleName) -> Path {
        Path.moduleSubdirectory(for: moduleName, type: .sources)
    }

    /// The path to a module's resources directory (a shortcut from calling
    /// `moduleSubdirectory(for: module, type: .resources)`)
    /// - Parameter moduleName: The module who's resources are needed
    /// - Returns: The full path to the module's resources directory
    public static func resourcesPath(for moduleName: ModuleName) -> Path {
        Path.moduleSubdirectory(for: moduleName, type: .resources)
    }

    /// The path to a module's tests directory (a shortcut from calling `moduleSubdirectory(for: module, type: .tests)`)
    /// - Parameter moduleName: The module who's tests are needed
    /// - Returns: The full path to the module's tests directory
    public static func testsPath(for moduleName: ModuleName) -> Path {
        Path.moduleSubdirectory(for: moduleName, type: .tests)
    }

    /// Creates a globbing pattern from the path instance
    public var globbing: Path {
        self.appending("**")
    }
}

extension Path {
    /// Creates a new Path instance from the existing one, appending the extra path
    /// - Parameter extraPath: The extra path to append to self
    /// - Returns: The new instance of the full path
    public func appending(_ extraPath: String) -> Path {
        let newPath = pathString + "/\(extraPath)"

        switch self.type {
        case .relativeToCurrentFile:
            return .relativeToCurrentFile(newPath)
        case .relativeToManifest:
            return .relativeToManifest(newPath)
        case .relativeToRoot:
            return .relativeToRoot(newPath)
        @unknown default:
            fatalError("Unknown case hit: \(self.type)")
        }
    }
}
