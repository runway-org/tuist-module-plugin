import Foundation
import ProjectDescription

extension Settings {
    /// Creates the build settings for a module.
    /// - Parameter extraSettings: Any additional settings that need to be injected.
    /// - Returns: The build settings for the module.
    public static func moduleSettings(with extraSettings: SettingsDictionary = [:]) -> Settings {
        return .settings(
            base: .moduleBase.merging(extraSettings),
            configurations: [
                .debug(name: "Debug"),
                .release(name: "Release"),
            ],
            defaultSettings: .none
        )
    }

    /// Creates the build settings for a test target.
    /// - Parameter extraSettings: Any additional settings that need to be injected.
    /// - Returns: The build settings for the test target.
    public static func testSettings(with extraSettings: SettingsDictionary = [:]) -> Settings {
        return .settings(
            base: .testBase.merging(extraSettings),
            configurations: [
                .debug(name: "Debug"),
                .release(name: "Release"),
            ],
            defaultSettings: .none
        )
    }

    /// The build settings for a resource bundle
    /// - Returns: The build settings for the resource bundle target
    public static func resourceSettings() -> Settings {
        return .settings(base: .resourceBase, defaultSettings: .none)
    }
}
