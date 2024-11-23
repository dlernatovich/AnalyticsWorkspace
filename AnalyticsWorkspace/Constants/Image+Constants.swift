//
//  Image+Constants.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 23.11.2024.
//

import Foundation
import SwiftUI

/// Image which provide the constants for the {@link Image}.
extension Image {
    static var info_circle: Self { .init(systemName: "info.circle") }
    static var apple_logo: Self { .init(systemName: "apple.logo") }
    static var iphone_badge_exclamationmark: Self { .init(systemName: "iphone.badge.exclamationmark") }
    static var square_resize: Self { .init(systemName: "square.resize") }
    static var calendar: Self { .init(systemName: "calendar") }
    static var shippingbox: Self { .init(systemName: "shippingbox") }
    static var video_badge_waveform: Self { .init(systemName: "video.badge.waveform") }
    static var tray: Self = .init(systemName: "tray")
    static var photo_on_rectangle_angled_fill: Self { .init(systemName: "photo.on.rectangle.angled.fill") }
    static var video_slash_fill: Self { .init(systemName: "video.slash.fill") }
    static var gear_badge_xmark: Self { .init(systemName: "gear.badge.xmark") }
    static var iphone_gen2_motion: Self { .init(systemName: "iphone.gen2.motion") }
    static var photo: Self { .init(systemName: "photo") }
    static var video: Self { .init(systemName: "video") }
}
