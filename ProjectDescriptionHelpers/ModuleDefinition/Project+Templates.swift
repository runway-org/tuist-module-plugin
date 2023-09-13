import ProjectDescription

extension Project {
    /// Makes a project from the given array of modules
    /// - Parameters:
    ///   - modules: The modules to include in the project (each module is converted into its array of targets)
    ///   - additionalTargets: Additional targets to be added to the project which are not directly tied to a module
    ///   - packages: The Swift packages to include
    ///   - schemes: Custom schemes
    ///   - additionalFiles: Extra files to be added to the project
    /// - Returns: The finished Xcode project
    public init(bundleID: String, modules: Set<Module>, additionalTargets: [Target] = [], packages: [Package] = [],
                schemes: [Scheme] = [], additionalFiles: [FileElement] = [], settings: Settings = .moduleSettings())
    {
        PluginConfiguration.bundleBaseID = bundleID
        var targets = modules.flatMap { $0.makeTargets() }
        targets.append(contentsOf: additionalTargets)

        let moduleSchemes = modules.map({ $0.makeScheme() }).flatMap({ $0 })
        let allSchemes = schemes + moduleSchemes

        self.init(
            name: "Tuist Module Demo",
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: allSchemes,
            additionalFiles: additionalFiles
        )
    }
}
