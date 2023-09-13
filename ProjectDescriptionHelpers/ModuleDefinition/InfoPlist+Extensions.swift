import Foundation
import ProjectDescription

extension InfoPlist {
    /// The path to our info.plist file shared by resource bundle targets.
    public static var resourceBundleTarget: InfoPlist {
        return InfoPlist.file(path: .relativeToRoot("xcconfig/ResourceBundle/Info.plist"))
    }
}
