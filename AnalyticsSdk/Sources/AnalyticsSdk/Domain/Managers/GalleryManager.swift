//
//  File.swift
//  AnalyticsSdk
//
//

import Foundation
import UIKit
import Photos

//MARK: - GalleryManager
/// Manager for gallery functional.
public final class GalleryManager {
    
    /// Instance of the {@link GalleryManager}.
    public static let shared: GalleryManager = .init()
    
    /// Property wrapper for the {@link GalleryManager}.
    @propertyWrapper
    public struct Wrapper {
        /// Instance of the {@link GalleryManager}.
        public var wrappedValue: GalleryManager { GalleryManager.shared }
        /// Default constructor.
        public init() {}
    }
    
}

//MARK: - GalleryManager - Authorization
/// Extension which provide the authorization.
private extension GalleryManager {
    
    /// Method which provide to request authorization.
    /// - Parameter it: callback instance.
    func requestAuthorization(_ it: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            it(status)
        }
    }
}

//MARK: - GalleryManager - Count
/// Extension which provide the count functional.
public extension GalleryManager {
    
    /// Method which provide to get photo count.
    /// - Parameter it: callback instance.
    public func fetchPhotoCount(_ it: @escaping (Int?) -> Void) {
        self.fetchAssetCount { [it] photo, video in it(photo) }
    }
    
    /// Method which provide to getting of the videos count.
    /// - Parameter it: callback instance.
    public func fetchVideoCount(_ it: @escaping (Int?) -> Void) {
        self.fetchAssetCount { [it] photo, video in it(video) }
    }
    
    /// Method which provide to fetch gallery items count.
    /// - Parameter it: callback instance.
    public func fetchGalleryCount(
        _ it: @Sendable @escaping (_ photo: Int?, _ video: Int?) -> Void
    ) { self.fetchAssetCount(completion: it) }
    
    /// Method which provide to get of the assets count.
    /// - Parameters:
    ///   - mediaType: value.
    ///   - completion: callback.
    private func fetchAssetCount(completion: @escaping (_ photo: Int?, _ video: Int?) -> Void) {
        self.requestAuthorization { status in
            var photoCount: Int? = nil
            var videoCount: Int? = nil
            if status != .authorized {
                print("\(Self.self) access to gallery forbiden.")
            } else {
                let fetchOptions = PHFetchOptions()
                let photoFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                let videoFetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                photoCount = photoFetchResult.count
                videoCount = videoFetchResult.count
            }
            DispatchQueue.main.async { completion(photoCount, videoCount) }
        }
    }
}

//MARK: - GalleryManager - Fetch
/// Extension which provide the fetch functional.
public extension GalleryManager {
    
    /// Method which provide to fetch meta data for type.
    /// - Parameters:
    ///   - type: value.
    ///   - it: callback instance.
    public func fetchMetaData(
        type: GalleryTypeEnum,
        _ it: @escaping (_ items: [MetaDataModel]) -> Void
    ) {
        self.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            guard status == .authorized else { return it([]) }
            switch type {
            case .photo: self.fetchPhotoMetaData(it)
            case .video: self.fetchVideoMetaData(it)
            }
        }
    }
    
    
    /// Method which provide to fetch photo meta data.
    /// - Parameter it: callback instance.
    private func fetchPhotoMetaData(_ it: @escaping (_ items: [MetaDataModel]) -> Void) {
        var result: [MetaDataModel] = []
        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects { asset, _, _ in
            let resource = PHAssetResource.assetResources(for: asset)
            let fileName = resource.first?.originalFilename ?? "Unknown"
            var sizeOnDisk: Int64? = 0
            let dimensions = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            if let resource = resource.first {
                let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
                sizeOnDisk = Int64(bitPattern: UInt64(unsignedInt64!))
            }
            let item = MetaDataModel(
                type: .photo,
                name: fileName,
                date: asset.creationDate,
                size: sizeOnDisk,
                dimensions: dimensions,
                duration: nil
            )
            result.append(item)
        }
        DispatchQueue.main.async { it(result) }
    }
    
    /// Method which provide to send the video meta data.
    /// - Parameter it: callback instance.
    private func fetchVideoMetaData(_ it: @escaping (_ items: [MetaDataModel]) -> Void) {
        var result: [MetaDataModel] = []
        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        fetchResult.enumerateObjects { asset, _, _ in
            let resource = PHAssetResource.assetResources(for: asset)
            let fileName = resource.first?.originalFilename ?? "Unknown"
            let dimensions = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let imageManager = PHImageManager.default()
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            imageManager.requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
                guard let urlAsset = avAsset as? AVURLAsset else { return }
                let fileName = urlAsset.url.lastPathComponent
                let fileSize = self.getFileSize(url: urlAsset.url)
                let duration = asset.duration
                let item = MetaDataModel(
                    type: .video,
                    name: fileName,
                    date: asset.creationDate,
                    size: fileSize,
                    dimensions: dimensions,
                    duration: duration
                )
                result.append(item)
            }
        }
        DispatchQueue.main.async { it(result) }
    }
    
    /// Method which provide to get the video file size.
    /// - Parameter url: value.
    /// - Returns: value.
    private func getFileSize(url: URL) -> Int64? {
        do {
            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
            return Int64(resourceValues.fileSize ?? 0)
        } catch {
            print("Can't get a file size: \(error)")
            return nil
        }
    }
}

// MARK: - GalleryManager - Fetch Thumbnail
/// Extension which provide to fetch thumbnail.
private extension GalleryManager {
    
    /// Method to fetch thumbnail for asset.
    /// - Parameters:
    ///   - asset: The PHAsset for the photo.
    ///   - size: The target size for the thumbnail.
    ///   - completion: Callback with the generated UIImage.
    func fetchThumbnail(
        for asset: PHAsset,
        size: CGSize,
        completion: @escaping (UIImage?) -> Void
    ) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.resizeMode = .exact
        options.isSynchronous = false
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options) { image, _ in
            completion(image)
        }
    }
}
