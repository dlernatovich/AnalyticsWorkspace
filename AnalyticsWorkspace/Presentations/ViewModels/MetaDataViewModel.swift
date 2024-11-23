//
//  ImagesViewModel.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI
import AnalyticsSdk

//MARK: - MetaDataViewModel
/// View model for images screen.
final class MetaDataViewModel : AbsViewModel {
    /// Array of the meta data model.
    @Published var items: [MetaDataModel] = []
    /// {@link Int} value of the count.
    @Published var count: Int = 0
    /// Value of the {@link ProgressStatusEnum}
    @Published var status: ProgressStatusEnum = .none
    /// Value of the type.
    private var type: GalleryTypeEnum = .photo
    
    /// Method which provide the init functional.
    init(type: GalleryTypeEnum) {
        super.init()
        self.type = type
        self.fetch()
    }
    
    /// Method which provide the functional when view was disapear.
    override func onDisapear() {
        self.cancel()
    }
    
    /// Method which provide the fetch functional.
    func fetch() {
        self.items.removeAll()
        self.count = 0
        self.galleryManager.fetchMetaData(type: type, delegate: self)
    }
    
    /// Method which provide the cancel.
    func cancel() {
        self.galleryManager.finishCurentWork()
    }
    
}

//MARK: - MetaDataViewModel - GalleryManagerDelegate
/// Extension which provide the {@link GalleryManagerDelegate} implementation.
extension MetaDataViewModel : GalleryManagerDelegate {
    
    /// Method which provide the action when photos and videos count was defined.
    /// - Parameters:
    ///   - photos: count.
    ///   - videos: count.
    func galleryManagerCountRecieved(photos: Int?, videos: Int?) {
    }
    
    /// Method which provide the action when item was recieved.
    /// - Parameter item: instance.
    func galleryManagerItemRecieved(item: MetaDataModel) {
        self.items.append(item)
        self.count = items.count - 1
    }
    
    /// Method which provide the result for the {@link GalleryManager}.
    /// - Parameters:
    ///   - status: value.
    ///   - items: array.
    func galleryManagerOnResult(status: ProgressStatusEnum, items: [MetaDataModel]?) {
        self.status = status
    }
    
}
