//
//  MainViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 20.11.2024.
//

import Foundation
import AnalyticsSdk

//MARK: - MainViewModel
/// View model for the {@link MainView}.
final class MainViewModel : AbsViewModel {
    /// {@link Int} value of the photo count.
    @Published var photoCount: Int? = nil
    /// {@link Int} value of the video count.
    @Published var videoCount: Int? = nil
    
    /// Menu array.
    @Published var menu: [ScreenEnum] = []
    
    /// Init functional.
    override init() {
        super.init()
        self.updateMenu()
        self.galleryManager.fetchGalleryCount(self)
    }
    
    /// Method which provide the menu.
    func updateMenu() {
        self.menu = [
            .device,
            .images(count: photoCount ?? 0),
            .videos(count: videoCount ?? 0)
        ]
    }
}

//MARK: - MainViewModel - GalleryManagerDelegate
/// Extension which provide the {@link GalleryManagerDelegate} implementation.
extension MainViewModel : GalleryManagerDelegate {
    
    /// Method which provide the action when photos and videos count was defined.
    /// - Parameters:
    ///   - photos: count.
    ///   - videos: count.
    func galleryManagerCountRecieved(photos: Int?, videos: Int?) {
        self.photoCount = photos
        self.videoCount = videos
        self.updateMenu()
    }
    
    /// Method which provide the action when item was recieved.
    /// - Parameter item: instance.
    func galleryManagerItemRecieved(item: MetaDataModel) {
        
    }
    
    /// Method which provide the result for the {@link GalleryManager}.
    /// - Parameters:
    ///   - status: value.
    ///   - items: array.
    func galleryManagerOnResult(status: ProgressStatusEnum, items: [MetaDataModel]?) {
        
    }
    
}
