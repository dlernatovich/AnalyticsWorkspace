//
//  AppDelegate.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import UIKit
import AnalyticsSdk

/// Class which provide the entry point.
class AppDelegate: NSObject, UIApplicationDelegate {
    
    /// Method which provide an action when app is started.
    /// - Parameters:
    ///   - application: instance.
    ///   - launchOptions: instance.
    /// - Returns: if it was launched.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AnalyticsSdk.shared.configure(it: ConfigureModel())
        return true
    }
}
