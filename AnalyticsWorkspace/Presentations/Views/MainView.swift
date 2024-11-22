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
    @StateObject private var vm: MainViewModel = .init()
    
    /// Array of the menu.
    private let menu: [ScreenModel] = [
        .init(image: "iphone.gen2.motion", text: "Device", screen: .device),
        .init(image: "photo", text: "Images", screen: .images),
        .init(image: "video", text: "Videos", screen: .videos)
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
                                .frame(width: 20)
                            Text(it.text).font(.body)
                            Spacer()
                            Text(verbatim: getCount(it.screen)).font(.caption).opacity(0.6)
                        }
                    }
                }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisapear() }
        .navigationTitle(.title)
        .navigationBarTitleDisplayMode(.large)
    }
    
    /// Method which provide to get count.
    /// - Parameter it: screen type.
    /// - Returns: value.
    func getCount(_ it: ScreenEnum) -> String {
        switch it {
        case .images: return vm.photoCount?.description ?? "-"
        case .videos: return vm.videoCount?.description ?? "-"
        default: return ""
        }
    }
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var title: Self = .init("Analytics")
    static var group1: Self = .init("Categories")
}
