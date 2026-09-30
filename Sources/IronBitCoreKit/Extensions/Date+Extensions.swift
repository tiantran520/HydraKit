import Foundation

/// Convenience helpers for formatting and comparing `Date` values.
public extension Date {
    /// The date formatted as an ISO 8601 string.
    var iso8601String: String {
        ISO8601DateFormatter().string(from: self)
    }

    /// Returns the distance from this date to now in seconds.
    var secondsSinceNow: TimeInterval {
        timeIntervalSinceNow
    }

    /// Returns a new date by adding the supplied component value.
    /// - Parameters:
    ///   - component: The calendar component to add.
    ///   - value: The number of components to add.
    ///   - calendar: The calendar used for calculation.
    /// - Returns: The calculated date, or the receiver when calculation fails.
    func adding(
        _ component: Calendar.Component,
        value: Int,
        calendar: Calendar = .current
    ) -> Date {
        calendar.date(byAdding: component, value: value, to: self) ?? self
    }
}
