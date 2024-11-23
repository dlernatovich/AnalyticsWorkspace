//
//  PlaceholderLoadingView.swift
//  AnalyticsWorkspace
//
//

import Foundation
import SwiftUI

/// View for the placeholder of the loding.
struct PlaceholderLoadingView : View {
    /// State to track the current progress.
    @Binding var progress: Int
    /// Maximum number of items to load.
    let max: Int
    /// Cancel callback.
    let cancel: () -> Void
    
    /// {@link View} instance.
    var body: some View {
        VStack {
            Text(.fetching)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            ProgressView(value: Double(progress.clamped(to: 0...max)), total: Double(max))
                .progressViewStyle(LinearProgressViewStyle())
                .padding(.horizontal, 32)
                .padding(.bottom)
            Button(action: { cancel() }) {
                Text(.cancel)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(.infinity)
            }
        }.padding(.top, -44)
    }
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var fetching: Self { .init("Fetching items. Please wait...") }
    static var cancel: Self { .init("Cancel") }
}
