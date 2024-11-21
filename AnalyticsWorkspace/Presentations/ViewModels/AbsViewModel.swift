//
//  AbsViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI

/// Base view model class.
open class AbsViewModel : ObservableObject {
    
    /// Method which provide the create functional.
    open func onCreate() {
        print("\(Self.self) was created.")
    }
    
    /// Method which provide the destroy functional.
    open func onDestroy() {
        print("\(Self.self) was destroyed.")
    }
    
}
