//
//  File.swift
//  AnalyticsSdk
//
//  Created by Dmitry Lernatovich on 21.11.2024.
//

import Foundation

/// Protocol which provide the configure functional.
public protocol Configurable {
    
    /// Type for the configuration.
    associatedtype ConfigType
    
    /// Method which provide the configure functional.
    /// - Parameter it: model instance.
    func configure(it: ConfigType)
    
}
