import Foundation
import ProjectDescription

/// A type that represents a product module
public struct Module: Hashable {
    /// Configuration options used when generating the target for the module
    public struct Config {
        public enum Product {
            /// Produces a dynamic framework product
            case `dynamic`
            /// Produces a static framework product
            case `static`
            /// Allows us to use any of the valid product types. This should be used very rarely.
            case custom(ProjectDescription.Product)
            /// Defines the module as one that just wraps a Swift package. This will allow us to link a Swift package
            /// with multiple of our targets and not get duplicate symbol errors. The associated value should be the
            /// package target for the module to depend on.
            case wrapper([ProjectDescription.TargetDependency])
        }

        /// Objective-C headers
        var headers: Headers?
        /// Any build phases that may need to be executed
        var actions: [TargetScript] = []
        /// The dependencies of the module
        var dependencies: [Dependency] = []
        /// Any additional resource files to be included (these will be in a module's resource bundle)
        var additionalFiles: [ResourceFileElement] = []
        /// The kind of product that should be produced by the module. Defaults to `static`. This should almost never be
        /// changed.
        var product: Product = .static
        /// Determines if there should be a resource bundle created for it. Only applies to static framework product
        /// types. Defaults to `false`.
        var hasResources: Bool = false
        /// The testing configuration for the module
        var testConfig: TestConfig? = nil

        public init(headers: Headers? = nil, actions: [TargetScript] = [], dependencies: [Dependency] = [],
                    additionalFiles: [ResourceFileElement] = [], product: Module.Config.Product = .static,
                    hasResources: Bool = false, testConfig: Module.TestConfig? = nil
        ) {
            self.headers = headers
            self.actions = actions
            self.dependencies = dependencies
            self.additionalFiles = additionalFiles
            self.product = product
            self.hasResources = hasResources
            self.testConfig = testConfig
        }

    }

    /// Configuration options for a module's test target
    public struct TestConfig {
        /// Additional dependencies beyond the primary module itself and the testing resources module
        var dependencies: [TargetDependency] = []
        /// Additional sources that the module's test target may need (such as the shared mocks)
        var additionalSources: [SourceFileGlob] = []
        /// Determines if the test target should have resource bundle created for it.
        var hasResources: Bool = false
        /// Determines if the test target should use an empty host app to run its test.
        var usesTestHost: Bool = false
        /// Additional build settings to apply to the test target.
        var additionalBuildSettings: SettingsDictionary = [:]
        /// Additional properties to apply to the generated Info.plist file
        var additionalInfoPlistProperties: [String : ProjectDescription.InfoPlist.Value] = [:]

        public init(dependencies: [TargetDependency] = [], additionalSources: [SourceFileGlob] = [],
                    hasResources: Bool = false, usesTestHost: Bool = false,
                    additionalBuildSettings: SettingsDictionary = [:],
                    additionalInfoPlistProperties: [String : InfoPlist.Value] = [:]
        ) {
            self.dependencies = dependencies
            self.additionalSources = additionalSources
            self.hasResources = hasResources
            self.usesTestHost = usesTestHost
            self.additionalBuildSettings = additionalBuildSettings
            self.additionalInfoPlistProperties = additionalInfoPlistProperties
        }


    }

    /// The name of the module
    let name: ModuleName
    /// Configuration options used when generating the module's main target
    let config: Config

    public init(name: ModuleName, config: Config = Config()) {
        self.name = name
        self.config = config
    }

    var targetReference: TargetReference {
        return TargetReference(projectPath: nil, target: name.name)
    }

    var testableTarget: TestableTarget {
        let reference = TargetReference(projectPath: nil, target: name.tests.name)
        return TestableTarget(target: reference)
    }

    var isPackageWrapper: Bool {
        return wrappedPackgeDependency != nil
    }

    var wrappedPackgeDependency: [TargetDependency]? {
        if case Config.Product.wrapper(let dependency) = config.product {
            return dependency
        }

        return nil
    }

    /// A complete list of the target dependencies of this module, including transitive ones.
    var resolvedDependencies: [TargetDependency] {
        if isPackageWrapper {
            return []
        }

        let moduleDeps = config.dependencies.compactMap({ dep -> Module? in
            switch dep {
            case .module(let module):
                return module
            default:
                return nil
            }
        })

        let moduleTargetDeps = moduleDeps
            .map({ TargetDependency.moduleName($0.name) })

        let transitiveDeps = moduleDeps
            .filter({ $0.isPackageWrapper == false })
            .flatMap({ $0.resolvedDependencies })

        let targetDeps = config.dependencies.compactMap({ dep -> TargetDependency? in
            switch dep {
            case .target(let targetDep):
                return targetDep
            default:
                return nil
            }
        })

        var allDeps = moduleTargetDeps + transitiveDeps + targetDeps
        if config.hasResources {
            allDeps.append(.moduleName(self.name.resources))
        }

        let filteredDeps = allDeps.removingDuplicates()
        return filteredDeps
    }

    /// Makes the targets needed for a module
    /// - Returns: The array of targets to be used in an Xcode project
    func makeTargets() -> [Target] {
        var targets: [Target?] = [
            Target.target(forModule: self),
        ]

        if config.hasResources {
            targets.append(Target.resourceTarget(for: self))
        }

        if config.testConfig != nil {
            targets.append(Target.testTarget(for: self))
        }

        return targets.compactMap { $0 }
    }

    func makeScheme() -> [Scheme] {
        let scheme = Scheme(
            name: name.name,
            shared: true,
            hidden: true,
            buildAction: BuildAction(
                targets: [
                    targetReference,
                ],
                preActions: [],
                postActions: []
            ),
            testAction: .targets([
                testableTarget,
            ])
        )

        var resourceScheme: Scheme?
        if config.hasResources {
            resourceScheme = Scheme(
                name: "\(name.name)Resources",
                hidden: true
            )
        }

        return [scheme, resourceScheme].compactMap { $0 }
    }

    public static func == (lhs: Module, rhs: Module) -> Bool {
        return lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

private extension Module.Config.Product {
    var xcodeProduct: Product {
        switch self {
        case .dynamic, .wrapper:
            return ProjectDescription.Product.framework
        case .static:
            return ProjectDescription.Product.staticFramework
        case .custom(let product):
            return product
        }
    }

    var isStatic: Bool {
        switch self {
        case .dynamic, .wrapper:
            return false
        case .static:
            return true
        case .custom(let product):
            return product == .staticLibrary || product == .staticFramework
        }
    }
}

private extension Target {
    static func target(forModule module: Module) -> Target
    {
        if let deps = module.wrappedPackgeDependency {
            return Target(
                name: module.name.name,
                platform: .iOS,
                product: .framework,
                bundleId: .bundleID(from: module.name),
                infoPlist: .default,
                scripts: module.config.actions,
                dependencies: deps,
                settings: .settings(base: frameworkWrapperSettings)
            )
        }

        let config = module.config
        let resources: ResourceFileElements?
        if module.config.product.isStatic == false {
            resources = ResourceFileElements(resources: [
                .glob(pattern: Path.resourcesPath(for: module.name).globbing),
            ])
        } else {
            resources = nil
        }

        return Target(
            name: module.name.name,
            platform: .iOS,
            product: config.product.xcodeProduct,
            bundleId: .bundleID(from: module.name),
            infoPlist: .default,
            sources: SourceFilesList(globs: [
                .glob(Path.sourcesPath(for: module.name).globbing)
            ]),
            resources: resources,
            headers: config.headers,
            scripts: config.actions,
            dependencies: module.resolvedDependencies,
            settings: .moduleSettings(),
            additionalFiles: [
                .glob(pattern: .modulePath(for: module.name).appending("README.md"))
            ]
        )
    }

    static func testTarget(for module: Module) -> Target? {
        guard module.isPackageWrapper == false, let config = module.config.testConfig else {
            return nil
        }

        let moduleName = module.name

        var dependencies: [TargetDependency] = config.dependencies + [
            .moduleName(moduleName),
        ]

        var resources: [ResourceFileElement] = []
        if config.hasResources {
            resources = [
                .glob(pattern: Path.modulePath(for: moduleName).appending("TestResources").globbing)
            ]
        }

        let sourceGlobs = config.additionalSources + [
            SourceFileGlob.glob(Path.testsPath(for: moduleName).globbing),
        ]

        var settings: Settings = .testSettings(with: config.additionalBuildSettings)
        if config.usesTestHost {
            settings = .testSettings(with: testHostSettings)
            dependencies.append(.moduleName(.testHost))
        }

        if module.config.product.isStatic {
            dependencies.append(contentsOf: module.resolvedDependencies)
        }

        if module.config.hasResources {
            dependencies.append(.moduleName(module.name.resources))
        }

        dependencies = dependencies.removingDuplicates()

        var additionalPlistProperties: [String: InfoPlist.Value] = [
            "NSPrincipalClass": "TestingResources.TestOrchestrator"
        ]

        additionalPlistProperties.merge(config.additionalInfoPlistProperties, uniquingKeysWith: { $1 })

        return Target(
            name: moduleName.tests.name,
            platform: .iOS,
            product: .unitTests,
            bundleId: .bundleID(from: moduleName.tests),
            infoPlist: InfoPlist.extendingDefault(with: additionalPlistProperties),
            sources: SourceFilesList(globs: sourceGlobs),
            resources: ResourceFileElements(resources: resources),
            dependencies: dependencies,
            settings: settings
        )
    }

    static func resourceTarget(for module: Module) -> Target? {
        guard module.isPackageWrapper == false else {
            return nil
        }

        guard
            module.config.product.isStatic,
            module.config.hasResources
        else { return nil }

        let additionalFiles = module.config.additionalFiles
        let moduleName = module.name

        var allResources = additionalFiles
        allResources.append(.glob(pattern: Path.resourcesPath(for: moduleName).globbing))

        return Target(
            name: moduleName.resources.name,
            platform: .iOS,
            product: .bundle,
            bundleId: .bundleID(from: moduleName.resources),
            infoPlist: .resourceBundleTarget,
            resources: ResourceFileElements(resources: allResources),
            scripts: [],
            settings: Settings.resourceSettings()
        )
    }
}

private let testHostSettings: SettingsDictionary = [
    "TEST_HOST": .string("$(BUILT_PRODUCTS_DIR)/TestHost.app/TestHost"),
    "BUNDLE_LOADER": .string("$(TEST_HOST)"),
]

private let frameworkWrapperSettings: SettingsDictionary = [
    "SKIP_INSTALL": .string("YES")
]
