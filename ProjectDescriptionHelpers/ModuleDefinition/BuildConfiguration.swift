internal typealias SettingConfig = BuildConfiguration

public struct BuildConfiguration: RawRepresentable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static var debug: BuildConfiguration = BuildConfiguration(rawValue: "Debug")
    public static var release: BuildConfiguration = BuildConfiguration(rawValue: "Release")
}
