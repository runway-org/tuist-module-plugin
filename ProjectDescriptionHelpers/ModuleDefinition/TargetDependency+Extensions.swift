import ProjectDescription

// MARK: - System SDKs
extension TargetDependency {
    public static var libz: TargetDependency {
        return .sdk(name: "libz.tbd", type: .framework)
    }

    public static var sqlite3: TargetDependency {
        return .sdk(name: "libsqlite3.tbd", type: .framework)
    }

    public static var coreTelephony: TargetDependency {
        return .sdk(name: "CoreTelephony.framework", type: .framework)
    }

    public static var iAd: TargetDependency {
        return .sdk(name: "iAd.framework", type: .framework)
    }

    public static var security: TargetDependency {
        return .sdk(name: "Security.framework", type: .framework)
    }

    public static var coreData: TargetDependency {
        return .sdk(name: "CoreData.framework", type: .framework)
    }

    public static var systemConfiguration: TargetDependency {
        return .sdk(name: "SystemConfiguration.framework", type: .framework)
    }

    public static var authenticationServices: TargetDependency {
        return .sdk(name: "AuthenticationServices.framework", type: .framework)
    }

    public static var foundation: TargetDependency {
        return .sdk(name: "Foundation.framework", type: .framework)
    }

    public static var uiKit: TargetDependency {
        return .sdk(name: "UIKit.framework", type: .framework)
    }

    public static var adServices: TargetDependency {
        return .sdk(name: "AdServices.framework", type: .framework, status: .optional)
    }

    public static var passKit: TargetDependency {
        return .sdk(name: "PassKit.framework", type: .framework)
    }

    public static var combine: TargetDependency {
        return .sdk(name: "Combine.framework", type: .framework)
    }
}

extension Array where Element == TargetDependency {
    /// Removes the duplicates that have the same name in an array of `TargetDependency`. This is similar behavior to
    /// a `Set<TargetDependency>` were `TargetDependency` also `Hashable`.
    ///
    /// - Returns: An updated array of `TargetDependency`
    func removingDuplicates() -> [Element] {
        var filteredItems = [TargetDependency]()
        for dep in self {
            if filteredItems.contains(dep) == false {
                filteredItems.append(dep)
            }
        }

        return filteredItems
    }
}
