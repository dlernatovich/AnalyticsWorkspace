//
//  PlaceholderEmptyView.swift
//  AnalyticsWorkspace
//
//

import Foundation
import SwiftUI
import AnalyticsSdk

/// A SwiftUI view that displays a placeholder for empty states, featuring an image and a message in a vertical layout.
struct PlaceholderEmptyView: View {
    
    /// Value of the {@link GalleryTypeEnum}.
    let type: GalleryTypeEnum
    /// Refresh callback.
    let refresh: () -> Void
    
    /// The body of the view, representing the vertical stack with the image and text.
    var body: some View {
        VStack {
            (type == .photo ? Image.photo_on_rectangle_angled_fill : Image.video_slash_fill)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.accentColor)
            Text(type == .photo ? .emptyPhotos : .emptyVideos)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom)
            Button(action: { refresh() }) {
                Text(.refresh)
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
    static var emptyPhotos: Self { .init("No protos are vailable") }
    static var emptyVideos: Self { .init("No videos are vailable") }
    static var refresh: Self { .init("Refresh") }
}
