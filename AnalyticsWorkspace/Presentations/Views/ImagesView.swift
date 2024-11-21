//
//  ImagesView.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI

//MARK: - View
/// View for the Images.
struct ImagesView : View {
    
    /// Instance of the {@link ImagesViewModel}.
    @ObservedObject private var vm: ImagesViewModel = .init()
    
    /// Instance of the {@link AnalyticsRouter}.
    @EnvironmentObject private var router: AnalyticsRouter
    
    /// Instance of the {@link View}.
    var body: some View {
        ZStack {
            
        }
        .onAppear { vm.onCreate() }
        .onDisappear { vm.onDestroy() }
        .navigationTitle(.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var title: Self = .init("Images")
}
