import Foundation

/// Convenience helpers for reading bundle metadata.
public extension Bundle {
    /// The bundle display name or bundle name.
    var appName: String {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? ""
    }

    /// The short version string from the bundle info dictionary.
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    /// The build number from the bundle info dictionary.
    var buildNumber: String {
        object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
}
