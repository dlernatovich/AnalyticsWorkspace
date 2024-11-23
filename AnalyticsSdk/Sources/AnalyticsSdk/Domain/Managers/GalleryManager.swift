//
//  File.swift
//  AnalyticsSdk
//

import Foundation
import UIKit
import Photos

//MARK: - GalleryManager
/// Manager for gallery functionality.
public final class GalleryManager {
    
    /// Instance of the `GalleryManager`.
    public static let shared: GalleryManager = .init()
    
    // Serial queue for ensuring sequential execution of onResult.
    private let serialQueue = DispatchQueue(label: "com.gallerymanager.serialQueue", qos: .userInteractive)
    /// Serial queue for ensuring sequential execution of processing.
    private let fetchQueue = DispatchQueue(label: "com.gallerymanager.fetch", qos: .background)
    /// Current `DispatchWorkItem` for tracking active fetch.
    private var currentWorkItem: DispatchWorkItem?
    
    /// Instance of the `GalleryManagerDelegate`.
    fileprivate weak var delegate: GalleryManagerDelegate? {
        didSet { invalidateCurentWork() }
    }
    
    /// Set of allowed statuses.
    let statuses: Set<PHAuthorizationStatus> = [.authorized, .limited]
    
    
    
    /// Property wrapper for the {@link GalleryManager}.
    @propertyWrapper
    public struct Wrapper {
        /// Instance of the {@link GalleryManager}.
        public var wrappedValue: GalleryManager { GalleryManager.shared }
        /// Default constructor.
        public init() {}
    }
    
}

//MARK: - GalleryManager - Work
/// Extension providing work functionality.
public extension GalleryManager {
    
    /// Invalidates the current fetch by cancelling the `DispatchWorkItem`.
    public func finishCurentWork() {
        self.invalidateCurentWork()
        self.onResult { delegate in
            delegate?.galleryManagerOnResult(status: .cancelled, items: nil)
        }
    }
    
    /// Invalidates the current fetch by cancelling the `DispatchWorkItem`.
    private func invalidateCurentWork() {
        if let work = self.currentWorkItem {
            print("\(Self.self) work was finished \(work)")
            work.cancel()
        }
        self.currentWorkItem = nil
    }
}

//MARK: - GalleryManager - Authorization
/// Extension providing authorization functionality.
private extension GalleryManager {
    
    /// Method to request authorization.
    /// - Parameter it: Callback instance.
    func requestAuthorization(_ it: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            it(status)
        }
    }
}

//MARK: - GalleryManager - OnResult
/// Extension providing result handling functionality.
private extension GalleryManager {
    
    /// Method to handle results on the main thread asynchronously.
    /// - Parameter it: Callback.
    func onResult(_ it: @escaping (_ delegate: GalleryManagerDelegate?) -> Void) {
        serialQueue.async { [weak self] in
            DispatchQueue.main.sync { [weak self] in it(self?.delegate) }
        }
    }
}

//MARK: - GalleryManager - Count
/// Extension which provide the count functional.
public extension GalleryManager {
    
    /// Method which provide to get the assets count.
    /// - Parameter it: delegate instance.
    public func fetchGalleryCount(_ it: GalleryManagerDelegate?) {
        self.delegate = it
        var workItem: DispatchWorkItem?
        workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.onResult { delegate in
                delegate?.galleryManagerOnResult(status: .progress, items: nil)
            }
            self.requestAuthorization { [weak self, statuses] status in
                guard let self = self else { return }
                guard let workItem = workItem, !workItem.isCancelled else { return }
                guard statuses.contains(status) else {
                    self.onResult { delegate in
                        delegate?.galleryManagerOnResult(status: .accessDenied, items: nil)
                    }
                    return print("\(Self.self) access to gallery forbidden.")
                }
                let fetchOptions = PHFetchOptions()
                let photoFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                let videoFetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                let photoCount = photoFetchResult.count
                let videoCount = videoFetchResult.count
                self.onResult { [photoCount, videoCount] delegate in
                    delegate?.galleryManagerCountRecieved(photos: photoCount, videos: videoCount)
                }
                self.invalidateCurentWork()
            }
        }
        self.currentWorkItem = workItem
        self.fetchQueue.async(execute: workItem!)
    }
}

//MARK: - GalleryManager - Fetch
/// Extension providing fetch functionality.
public extension GalleryManager {
    
    /// Method to fetch metadata for a specific type.
    /// - Parameters:
    ///   - type: The type of gallery item to fetch.
    ///   - delegate: Callback instance.
    func fetchMetaData(type: GalleryTypeEnum, delegate: GalleryManagerDelegate?) {
        self.delegate = delegate
        var workItem: DispatchWorkItem?
        workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.onResult { delegate in
                delegate?.galleryManagerOnResult(status: .progress, items: nil)
            }
            self.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                guard let workItem = workItem, !workItem.isCancelled else { return }
                guard self.statuses.contains(status) else {
                    self.onResult { delegate in
                        delegate?.galleryManagerOnResult(status: .accessDenied, items: nil)
                    }
                    return print("\(Self.self) access to gallery forbidden.")
                }
                switch type {
                case .photo: self.fetchPhotoMetaData(workItem: workItem)
                case .video: self.fetchVideoMetaData(workItem: workItem)
                }
            }
        }
        self.currentWorkItem = workItem
        self.fetchQueue.async(execute: workItem!)
    }
    
    /// Method to fetch photo metadata.
    private func fetchPhotoMetaData(workItem: DispatchWorkItem) {
        var result: [MetaDataModel] = []
        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        guard fetchResult.count > 0 else {
            return finishFetch(workItem: workItem, status: .successEmpty, items: nil)
        }
        fetchResult.enumerateObjects { [weak self] asset, _, _ in
            guard let self = self else { return }
            guard !workItem.isCancelled else { return }
            let resource = PHAssetResource.assetResources(for: asset)
            let fileName = resource.first?.originalFilename ?? "Unknown"
            let sizeOnDisk = self.getSize(resource)
            let dimensions = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let item = MetaDataModel(
                type: .photo,
                name: fileName,
                date: asset.creationDate,
                size: sizeOnDisk,
                dimensions: dimensions,
                duration: nil
            )
            self.onResult { [item] delegate in
                delegate?.galleryManagerItemRecieved(item: item)
            }
            result.append(item)
        }
        self.finishFetch(
            workItem: workItem,
            status: result.count > 0 ? .success : .successEmpty,
            items: result
        )
    }
    
    /// Method to fetch video metadata.
    private func fetchVideoMetaData(workItem: DispatchWorkItem) {
        var result: [MetaDataModel] = []
        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        let fetchCount = fetchResult.count
        guard fetchCount > 0 else {
            return self.finishFetch(workItem: workItem, status: .successEmpty, items: nil)
        }
        fetchResult.enumerateObjects { [weak self, fetchCount] asset, _, _ in
            guard let self = self else { return }
            guard !workItem.isCancelled else { return }
            let resource = PHAssetResource.assetResources(for: asset)
            let fileName = resource.first?.originalFilename ?? "Unknown"
            let dimensions = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            var fileSize: Int64? = nil
            var duration: TimeInterval? = nil
            let imageManager = PHImageManager.default()
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            imageManager.requestAVAsset(forVideo: asset, options: options) { [weak self, fetchCount] avAsset, _, _ in
                guard let self = self else { return }
                guard !workItem.isCancelled else { return }
                if let urlAsset = avAsset as? AVURLAsset {
                    fileSize = self.getSize(urlAsset.url)
                    duration = asset.duration
                }
                let item = MetaDataModel(
                    type: .video,
                    name: fileName,
                    date: asset.creationDate,
                    size: fileSize,
                    dimensions: dimensions,
                    duration: duration
                )
                self.onResult { [item] delegate in
                    delegate?.galleryManagerItemRecieved(item: item)
                }
                result.append(item)
                if (result.count >= fetchCount) {
                    self.finishFetch(
                        workItem: workItem,
                        status: result.count > 0 ? .success : .successEmpty,
                        items: result
                    )
                }
            }
        }
    }
    
    /// Method which provide to finish fetch.
    /// - Parameters:
    ///   - status: value.
    ///   - items: array.
    private func finishFetch(
        workItem: DispatchWorkItem,
        status: ProgressStatusEnum,
        items: [MetaDataModel]?
    ) {
        self.onResult { [weak self, items] delegate in
            guard !workItem.isCancelled else { return }
            delegate?.galleryManagerOnResult(status: status, items: items)
            self?.invalidateCurentWork()
        }
    }
    
    /// Method to get the video file size.
    /// - Parameter url: URL of the video.
    /// - Returns: Size value.
    private func getSize(_ url: URL) -> Int64? {
        do {
            let resourceValues = try url.resourceValues(forKeys: [.fileSizeKey])
            return Int64(resourceValues.fileSize ?? 0)
        } catch {
            print("Can't get a file size: \(error)")
            return nil
        }
    }
    
    /// Method to get size of an asset resource.
    /// - Parameter it: Array of `PHAssetResource`.
    /// - Returns: Size value.
    private func getSize(_ it: [PHAssetResource]) -> Int64? {
        guard let resource = it.first else { return nil }
        let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
        return unsignedInt64 != nil ? Int64(bitPattern: UInt64(unsignedInt64!)) : nil
    }
}
