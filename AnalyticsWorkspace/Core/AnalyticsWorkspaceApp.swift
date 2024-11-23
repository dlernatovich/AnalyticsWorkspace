//
//  AnalyticsWorkspaceApp.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 20.11.2024.
//

import SwiftUI


/// Instance of the {@link App}.
@main
struct AnalyticsWorkspaceApp: App {
    
    /// Instance of the AppDelegate.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Instance of the {@link AnalyticsRouter}.
    @ObservedObject private var router: AnalyticsRouter = .init()
    
    /// Instance of the {@link Scene}.
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MainView().navigationDestination(for: ScreenEnum.self) { it in
                    switch it {
                    case .main: EmptyView() // Can't navigate to main screen.
                    case .device: DeviceView().environmentObject(router)
                    case .images(let count): MetadatasView(type:.photo, count: count).environmentObject(router)
                    case .videos(let count): MetadatasView(type: .video, count: count).environmentObject(router)
                    }
                }
            }
        }
    }
}
