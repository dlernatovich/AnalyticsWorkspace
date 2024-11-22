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
    /// {@link Bool} value if it is snimating.
    @State private var isAnimating = false
    /// Instance of the {@link ImagesViewModel}.
    @StateObject private var vm: ImagesViewModel = .init()
    
    /// Instance of the {@link View}.
    var body: some View {
        List {
            if vm.items.count > 0 {
                ForEach(vm.items) { item in
                    Section(header: Text(verbatim: item.name)) {
                        getView(image: "calendar", desc: .dateCreated, text: item.getDate())
                        getView(image: "shippingbox", desc: .fileSize, text: item.size?.description)
                        getView(image: "square.resize", desc: .dimensions, text: item.getDimensions())
                    }
                }
            } else {
                Section(.status) {
                    VStack {
                        Image(systemName: "hourglass.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.accentColor)
                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: isAnimating
                            ).onAppear {
                                isAnimating = true
                            }.padding(.bottom)
                        Text(.loadingMessage).font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisapear() }
        .navigationTitle(.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Method which provide to get view.
    /// - Parameters:
    ///   - image: name value.
    ///   - desc: value.
    ///   - text: value.
    /// - Returns: view instance.
    private func getView(image: String, desc: LocalizedStringKey, text: String?) -> some View {
        return HStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .frame(width: 20)
            Text(desc).font(.body)
            Spacer()
            Text(verbatim: text ?? "-").font(.caption).opacity(0.6)
        }
    }
}

//MARK: - Constants
/// Extension which provide the constants functional.
private extension LocalizedStringKey {
    static var title: Self = .init("Images")
    static var loading: Self = .init("Loading Information")
    static var name: Self = .init("File name")
    static var dateCreated: Self = .init("Date created")
    static var fileSize: Self = .init("File size")
    static var dimensions: Self = .init("Dimensions")
    static var status: Self = .init("Status")
    static var loadingMessage: Self = .init("Loading information from gallery...")
}
