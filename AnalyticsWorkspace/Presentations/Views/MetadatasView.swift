//
//  ImagesView.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI
import AnalyticsSdk

//MARK: - View
/// View for the Images.
struct MetadatasView : View {
    /// Type enum.
    let type: GalleryTypeEnum
    /// Items count.
    let count: Int?
    /// Instance of the {@link ImagesViewModel}.
    @StateObject private var vm: MetaDataViewModel
    
    /// Initializer.
    init(type: GalleryTypeEnum, count: Int?) {
        self.type = type
        self.count = count
        _vm = StateObject(wrappedValue: MetaDataViewModel(type: type))
    }
    
    /// Instance of the {@link View}.
    var body: some View {
        ZStack {
            switch vm.status {
            case .none, .cancelled, .successEmpty: PlaceholderEmptyView(type: type) {
                vm.fetch()
            }
            case .progress: PlaceholderLoadingView(
                progress: $vm.count,
                max: count ?? 0
            ) { vm.cancel() }
            case .accessDenied: PlaceholderDeniedView()
            case .success: List(vm.items) { item in
                Section(header: Text(verbatim: item.name)) {
                    getView(image: .calendar, desc: .dateCreated, text: item.getDate())
                    getView(image: .shippingbox, desc: .fileSize, text: item.size?.description)
                    getView(image: .square_resize, desc: .dimension, text: item.getDimensions())
                    if type == .video {
                        getView(image: .video_badge_waveform, desc: .duration, text: item.getDuration())
                    }
                }
            }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisapear() }
        .navigationTitle(type == .photo ? .images : .videos)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text(verbatim: count?.description ?? "")
                    .font(.caption)
                    .opacity(0.6)
            }
        }
    }
    
    /// Method which provide to get view.
    /// - Parameters:
    ///   - image: name value.
    ///   - desc: value.
    ///   - text: value.
    /// - Returns: view instance.
    private func getView(
        image: Image,
        desc: LocalizedStringKey,
        text: String?
    ) -> some View {
        return HStack {
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            Text(desc)
                .font(.body)
            Spacer()
            Text(verbatim: text ?? "-")
                .font(.caption)
                .opacity(0.6)
        }
    }
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var images: Self { .init("Images") }
    static var videos: Self { .init("Videos") }
    static var loading: Self { .init("Loading Information") }
    static var name: Self { .init("File name") }
    static var dateCreated: Self { .init("Date created") }
    static var fileSize: Self { .init("File size") }
    static var dimension: Self { .init("Dimension") }
    static var duration: Self { .init("Duration") }
    static var status: Self { .init("Status") }
}
