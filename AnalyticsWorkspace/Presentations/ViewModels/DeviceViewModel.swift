//
//  DeviceViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI
import AnalyticsSdk

/// View model for the device screen.
final class DeviceViewModel : AbsViewModel {
    /// Instance of the {@link DeviceInfoModel}.
    @Published var info: DeviceInfoModel? = nil
    
    /// Method which provide the appear functional.
    override func onAppear() {
        self.deviceManager.fethDeviceInfo { [weak self] device in self?.info = device }
    }
}
