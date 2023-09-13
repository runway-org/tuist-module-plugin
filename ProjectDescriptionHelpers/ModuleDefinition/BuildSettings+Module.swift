import Foundation
import ProjectDescription

extension SettingsDictionary {
    static var moduleBase: SettingsDictionary {
        return [
            "CLANG_WARN_DOCUMENTATION_COMMENTS": true,
            "MACH_O_TYPE": "staticlib",
            "INSTALL_PATH": "$(LOCAL_LIBRARY_DIR)/Frameworks",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks"
            ],
            "LIBRARY_SEARCH_PATHS": "$(inherited)",
            "PRODUCT_BUNDLE_IDENTIFIER": "\(PluginConfiguration.bundleBaseID).$(TARGET_NAME)",
            "PRODUCT_NAME": "$(TARGET_NAME)",
            "SKIP_INSTALL": "YES",
            "CLANG_MODULES_AUTOLINK": false,
            "INFOPLIST_FILE": "$(SRCROOT)/Derived/InfoPlists/$(TARGET_NAME).plist",
            "SWIFT_VERSION": "5.0",
        ]
    }

    static var testBase: SettingsDictionary {
        return [
            "TEST_TARGET_NAME": "SampleApp",
            "CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION": "YES_AGGRESSIVE",
            "CLANG_CXX_LANGUAGE_STANDARD": "gnu++14",
            "CLANG_CXX_LIBRARY": "libc++",
            "CLANG_WARN_DIRECT_OBJC_ISA_USAGE": "YES_ERROR",
            "CLANG_WARN_DOCUMENTATION_COMMENTS": true,
            "CLANG_WARN_NON_LITERAL_NULL_CONVERSION": true,
            "CLANG_WARN_OBJC_LITERAL_CONVERSION": true,
            "CLANG_WARN_UNGUARDED_AVAILABILITY": "YES_AGGRESSIVE",
            "CLANG_WARN_OBJC_ROOT_CLASS": "YES_ERROR",
            "CLANG_WARN_SUSPICIOUS_MOVES": true,
            "GCC_C_LANGUAGE_STANDARD": "gnu11",
            "GCC_WARN_ABOUT_RETURN_TYPE": "YES_ERROR",
            "GCC_WARN_UNINITIALIZED_AUTOS": "YES_AGGRESSIVE",
            "LD_RUNPATH_SEARCH_PATHS": [
                "$(inherited)",
                "@executable_path/Frameworks",
                "@loader_path/Frameworks",
            ],
            "MTL_FAST_MATH": true,
            "PRODUCT_BUNDLE_IDENTIFIER": "$(BUNDLE_BASE_IDENTIFIER).$(TARGET_NAME)",
            "PRODUCT_NAME": "$(TARGET_NAME)",
            "STRIP_INSTALLED_PRODUCT": false,
            "TARGETED_DEVICE_FAMILY": "1,2",

            // Debug values
            "GCC_DYNAMIC_NO_PIC": false,
            "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1 $(inherited)",
            "MTL_ENABLE_DEBUG_INFO": "INCLUDE_SOURCE",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
        ]
    }

    static var resourceBase: SettingsDictionary {
        return [
            "PRODUCT_BUNDLE_IDENTIFIER": "\(PluginConfiguration.bundleBaseID).$(TARGET_NAME)",
            "PRODUCT_NAME": "$(TARGET_NAME)",
        ]
    }
}
