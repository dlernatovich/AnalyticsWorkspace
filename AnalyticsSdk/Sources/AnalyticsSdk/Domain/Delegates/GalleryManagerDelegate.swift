//
//  File.swift
//  AnalyticsSdk
//
//

import Foundation
import UIKit
import SwiftUI

/// Delegate for the {@link GalleryManager}.
public protocol GalleryManagerDelegate: AnyObject {
    
    /// Method which provide the action when photos and videos count was defined.
    /// - Parameters:
    ///   - photos: count.
    ///   - videos: count.
    func galleryManagerCountRecieved(photos: Int?, videos: Int?)
    
    /// Method which provide the action when item was recieved.
    /// - Parameter item: instance.
    func galleryManagerItemRecieved(item: MetaDataModel)
    
    /// Method which provide the result for the {@link GalleryManager}.
    /// - Parameters:
    ///   - status: value.
    ///   - items: array.
    func galleryManagerOnResult(status: ProgressStatusEnum, items: [MetaDataModel]?)
    
}
