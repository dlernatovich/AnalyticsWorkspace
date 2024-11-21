//
//  AnalyticsRouter.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI

/// Router for the application.
class AnalyticsRouter : ObservableObject {
    
    /// Instance of the {@link NavigationPath}.
    @Published var path: NavigationPath = .init()
    
    /// Method which privide to navigate functional.
    /// - Parameter it: path.
    func navigate(it: ScreenEnum) {
        guard it != .main else { return self.navigateHome() }
        self.path.append(it)
    }
    
    /// Method which provide to navigate back.
    func navigateBack() { self.path.removeLast() }
    
    /// Method which provide to navigate home.
    func navigateHome() { self.path.removeLast(path.count) }
    
}
