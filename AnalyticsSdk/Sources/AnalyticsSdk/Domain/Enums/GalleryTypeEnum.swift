//
//  File.swift
//  AnalyticsSdk
//
//

import Foundation
import Photos

/// Gallery type enum.
public enum GalleryTypeEnum {
    case photo, video
}

/// Extension for the {@link GalleryTypeEnum} for the internal usage.
internal extension GalleryTypeEnum {
    
    /// Value of the {@link PHAssetMediaType}.
    var type: PHAssetMediaType {
        switch self {
        case .photo: return .image
        case .video: return .video
        }
    }
    
}
