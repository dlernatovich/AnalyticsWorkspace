//
//  PlaceholderDeniedView.swift
//  AnalyticsWorkspace
//
//

import Foundation
import SwiftUI

struct PlaceholderDeniedView : View {
    
    /// Instance of the {@link View}.
    var body: some View {
        VStack {
            Image.gear_badge_xmark.resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)
            Text(.text)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom)
            Button(action: { openAppSettings() }) {
                Text(.openSettings)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(.infinity)
            }
        }.padding(.top, -44)
    }
    
    /// Method which provide to open settings.
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:]) { success in
                if success { print("Successfully opened app settings.") } else {
                    print("Failed to open app settings.")
                }
            }
        } else { print("Cannot open app settings.") }
    }
    
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var text: Self { .init("Access denied. Open settings and give access to a gallery.") }
    static var openSettings: Self { .init("Open settings") }
}
