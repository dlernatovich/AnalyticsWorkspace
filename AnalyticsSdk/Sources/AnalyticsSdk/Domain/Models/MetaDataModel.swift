//
//  File.swift
//  AnalyticsSdk
//
//

import Foundation
import UIKit

/// Meta data model.
public struct MetaDataModel: Identifiable {
    public var id = UUID()
    public let type: GalleryTypeEnum
    public let name: String
    public let date: Date?
    public let size: Int64?
    public let dimensions: CGSize?
    public let duration: TimeInterval?
}

/// Extension for the {@link MetaDataModel}.
public extension MetaDataModel {
    
    /// Method which provide to get a date.
    /// - Returns: date value.
    public func getDate() -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Specify the format
        return formatter.string(from: date)
    }
    
    /// Method which provide to get the screen resoltion as height x width
    /// - Returns: string value.
    public func getDimensions() -> String? {
        guard let dimensions = dimensions else { return nil }
        return "\(Int(dimensions.height)) x \(Int(dimensions.width))"
    }
    
}
