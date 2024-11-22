//
//  ImagesViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI
import AnalyticsSdk

/// View model for images screen.
final class ImagesViewModel : AbsViewModel {
    /// Array of the meta data model.
    @Published var items: [MetaDataModel] = []
    
    /// Method which provide on appear functional.
    override func onAppear() {
        self.galleryManager.fetchMetaData(type: .photo) { [weak self] items in
            self?.items = items
        }
    }
}
