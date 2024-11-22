//
//  MainViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 20.11.2024.
//

import Foundation
import AnalyticsSdk

/// View model for the {@link MainView}.
final class MainViewModel : AbsViewModel {
    /// {@link Int} value of the photo count.
    @Published var photoCount: Int? = nil
    /// {@link Int} value of the video count.
    @Published var videoCount: Int? = nil
    
    /// Method which provide the on appear functional.
    override func onAppear() {
        self.galleryManager.fetchGalleryCount { [weak self] photo, video in
            self?.photoCount = photo
            self?.videoCount = video
        }
    }
}
