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
    
    /// Instance of the {@link View}.
    var body: some View {
        List {
            Section(.group1) {
                ForEach(vm.menu) { it in
                    NavigationLink(value: it) {
                        HStack {
                            getImage(it)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.accentColor)
                                .frame(width: 20)
                            Text(getText(it)).font(.body)
                            Spacer()
                            Text(verbatim: getCount(it)).font(.caption).opacity(0.6)
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
    
    /// Method which provide to return image.
    /// - Parameter it: screen type value.
    /// - Returns: image instance.
    private func getImage(_ it: ScreenEnum) -> Image {
        switch it {
        case .main: return .apple_logo
        case .device: return .iphone_gen2_motion
        case .images(_): return .photo
        case .videos(_): return .video
        }
    }
    
    /// Method which provide to return text.
    /// - Parameter it: screen type value.
    /// - Returns: image instance.
    private func getText(_ it: ScreenEnum) -> LocalizedStringKey {
        switch it {
        case .main: return .init("")
        case .device: return .init("Device")
        case .images(_): return .init("Images")
        case .videos(_): return .init("Videos")
        }
    }
    
    /// Method which provide to get count.
    /// - Parameter it: screen type.
    /// - Returns: value.
    private func getCount(_ it: ScreenEnum) -> String {
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
