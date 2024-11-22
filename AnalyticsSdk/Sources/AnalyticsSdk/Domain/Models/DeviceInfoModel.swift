//
//  File.swift
//  AnalyticsSdk
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation

/// Device information model.
public struct DeviceInfoModel {
    
    /// {@link String} value of the device model.
    public let deviceModel: String
    
    /// {@link String} value if the operation system version.
    public let osVersion: String
    
    /// {@link String} value of the manufacturer.
    public let manufacturer: String
    
    /// {@link CGRect} value of the screen resolution.
    public let screenResolution: CGSize
    
}

/// Extension for the {@link DeviceInfoModel}.
public extension DeviceInfoModel {
    
    /// Method which provide to get the screen resoltion as height x width
    /// - Returns: string value.
    public func getDeviceResolution() -> String {
        return "\(Int(screenResolution.height)) x \(Int(screenResolution.width))"
    }
    
}
