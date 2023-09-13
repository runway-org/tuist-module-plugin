import Foundation
import ProjectDescription

/// Defines a dependency for a given module
public enum Dependency: Equatable {
    /// Defines a specifc target dependency
    case target(TargetDependency)
    /// Defines a dependency on a module
    case module(Module)
}
