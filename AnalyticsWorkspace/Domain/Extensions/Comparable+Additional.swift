//
//  File.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 23.11.2024.
//

import Foundation

/// Extension which provide the functional for the {@link Comparable}.
extension Comparable {
    
    /// Method which provide the clamped functional.
    /// - Parameter limits: value.
    /// - Returns: value.
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
