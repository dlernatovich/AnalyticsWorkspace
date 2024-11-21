//
//  ScreenModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI

/// Model for the home screen menu.
struct ScreenModel: Identifiable {
    
    /// Instance of the ID.
    let id = UUID()
    
    /// Instance of the {@link Image}.
    let image: String
    
    /// Instance of the {@link LocalizedStringKey}.
    let text: LocalizedStringKey
    
    /// Value of the {@link ScreenEnum}.
    let screen: ScreenEnum
    
    /// Constructor which provide to create an object from image system name and text.
    /// - Parameters:
    ///   - image: image system name.
    ///   - text: text value.
    ///   - screen: screen enum value.
    init(image: String, text: String, screen: ScreenEnum) {
        self.image = image
        self.text = LocalizedStringKey(text)
        self.screen = screen
    }
    
}
