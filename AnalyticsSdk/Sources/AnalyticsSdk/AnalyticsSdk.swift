// The Swift Programming Language
// https://docs.swift.org/swift-book

/// Entry point of the SDK.
public class AnalyticsSdk : Configurable {
    
    /// Configure model type.
    public typealias ConfigType = ConfigureModel
    
    /// Instance of the {@link AnalyticsSdk}.
    @MainActor public static let shared: AnalyticsSdk = .init()
    
    /// Instance of the {@link ConfigureModel}.
    internal private(set) var configure: ConfigType? = nil
    
    /// Method which provide the configure functional.
    /// - Parameter it: configure model.
    public func configure(it: ConfigType) {
        print("\(Self.self) was configured.")
        self.configure = it
    }
    
}
