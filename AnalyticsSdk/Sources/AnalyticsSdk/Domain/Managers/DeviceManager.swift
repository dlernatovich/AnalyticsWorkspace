//
//  File.swift
//  AnalyticsSdk
//
//

import Foundation
import UIKit

/// Manager which provide the device functional.
public final class DeviceManager {
    
    /// Instance of the {@link DeviceManager}.
    public static let shared: DeviceManager = .init()
    
    /// Method which provide to fetch device information.
    /// - Parameter it: callback instance.
    public func fethDeviceInfo(
        _ it: @escaping (_ device: DeviceInfoModel) -> Void
    ) {
        let deviceModel = UIDevice.current.model
        let osVersion = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
        let manufacturer = "Apple"
        let screenResolution = UIScreen.main.nativeBounds.size
        DispatchQueue.main.async {
            it(DeviceInfoModel(deviceModel: deviceModel, osVersion: osVersion, manufacturer: manufacturer, screenResolution: screenResolution))
        }
    }
    
    /// Property wrapper for the {@link DeviceManager}.
    @propertyWrapper
    public struct Wrapper {
        /// Instance of the {@link DeviceManager}.
        public var wrappedValue: DeviceManager { DeviceManager.shared }
        /// Default constructor.
        public init() {}
    }
    
}
