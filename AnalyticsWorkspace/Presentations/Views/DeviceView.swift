//
//  DeviceView.swift
//  AnalyticsWorkspace
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation
import SwiftUI

//MARK: - View
/// View for the device information.
struct DeviceView : View {
    /// Instance of the {@link DeviceViewModel}.
    @StateObject private var vm: DeviceViewModel = .init()
    /// Instance of the {@link AnalyticsRouter}.
    @EnvironmentObject private var router: AnalyticsRouter
    
    /// Instance of the {@link View}.
    var body: some View {
        List {
            if vm.info == nil {
                Text(.noInfo)
            } else {
                Section(.software) {
                    getView(
                        image: .info_circle,
                        desc: .manufacturer,
                        text: vm.info?.manufacturer
                    )
                    getView(
                        image: .apple_logo,
                        desc: .operationSystem,
                        text: vm.info?.osVersion
                    )
                }
                Section(.hardware) {
                    getView(
                        image: .iphone_badge_exclamationmark,
                        desc: .deviceModel,
                        text: vm.info?.deviceModel
                    )
                    getView(
                        image: .square_resize,
                        desc: .screenResolution,
                        text: vm.info?.getDeviceResolution()
                    )
                }
            }
        }
        .onAppear { vm.onAppear() }
        .onDisappear { vm.onDisapear() }
        .navigationTitle(.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Method which provide to get view from value.
    /// - Parameters:
    ///   - image: value.
    ///   - text: value.
    /// - Returns: view.
    private func getView(
        image: Image,
        desc: LocalizedStringKey,
        text: String?
    ) -> some View {
        return HStack {
            image.aspectRatio(contentMode: .fit)
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
    static var title: Self = .init("Device")
    static var noInfo: Self = .init("No device information found.")
    static var software: Self = .init("Software")
    static var hardware: Self = .init("Hardware")
    static var manufacturer: Self = .init("Manufacturer")
    static var operationSystem: Self = .init("Operation system")
    static var osVersion: Self = .init("OS version")
    static var deviceModel: Self = .init("Device model")
    static var screenResolution: Self = .init("Screen resolution")
}
