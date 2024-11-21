//
//  MainView.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 20.11.2024.
//

import Foundation
import SwiftUI

//MARK: - View
/// View for the main screen.
struct MainView: View {
    
    /// Instance of the {@link MainViewModel}.
    @ObservedObject private var vm: MainViewModel = .init()
    
    /// Array of the menu.
    private let menu: [ScreenModel] = [
        .init(image: "iphone.circle.fill", text: "Device", screen: .device),
        .init(image: "photo.circle.fill", text: "Images", screen: .images),
        .init(image: "video.circle.fill", text: "Videos", screen: .videos)
    ]
    
    /// Instance of the {@link View}.
    var body: some View {
        List {
            Section(.group1) {
                ForEach(menu) { it in
                    NavigationLink(value: it.screen) {
                        HStack {
                            Image(systemName: it.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.accentColor)
                                .frame(width: 25, height: 25)
                            Text(it.text)
                        }
                    }
                }
            }
        }
        .navigationTitle(.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var title: Self = .init("Analytics")
    static var group1: Self = .init("Categories")
}
