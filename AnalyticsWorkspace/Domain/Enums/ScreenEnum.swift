//
//  ScreenEnum.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 20.11.2024.
//

import Foundation

/// Enum for the screens.
enum ScreenEnum: Hashable, Identifiable {
    case main
    case device
    case images(count: Int)
    case videos(count: Int)
    var id: String {
        switch self {
        case .main: return "main"
        case .device: return "device"
        case .images(let count): return "images_\(count)"
        case .videos(let count): return "videos_\(count)"
        }
    }
}
