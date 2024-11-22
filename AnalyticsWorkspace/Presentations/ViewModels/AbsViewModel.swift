//
//  AbsViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI
import AnalyticsSdk

/// Base view model class.
open class AbsViewModel : ObservableObject {
    /// INstance of the {@link DeviceManager}.
    @DeviceManager.Wrapper var deviceManager
    /// Instance of the {@link GalleryManager}.
    @GalleryManager.Wrapper var galleryManager
    
    /// Method which provide the appear functional.
    open func onAppear() { print("\(Self.self) was appeared.") }
    
    /// Method which provide the disapear functional.
    open func onDisapear() { print("\(Self.self) was disappeared.") }
    
    /// Deinit functional.
    deinit { print("\(Self.self) was destroyed.") }
}
