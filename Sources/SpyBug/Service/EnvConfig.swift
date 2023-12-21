//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import Foundation

enum EnvConfig: String {
    
    // MARK: - Configurations
    
    case debug
    case staging
    case production
    
    // MARK: - Current Configuration
    
    static let current: EnvConfig = {
        guard let rawValue = Bundle.main.infoDictionary?["EnvConfig"] as? String else {
            fatalError("No environment configuration Found")
        }
        guard let envConfig = EnvConfig(rawValue: rawValue.lowercased()) else {
            fatalError("Invalid Environment configuration")
        }
        return envConfig
    }()
    
    static var baseURL: String {
        switch EnvConfig.current {
        case .debug:
            return "http://localhost/docs"
        case .staging:
            return "http://localhost/docs"
        case .production:
            //TODO: Change for production
            return "http://localhost/docs"
        }
    }
    
    static var apiScheme: String {
        switch EnvConfig.current {
        case .debug:
            return "http"
        case .staging, .production:
            return "https"
        }
    }
    
    static var port: Int? {
        switch EnvConfig.current {
        case .debug:
            return 3000
        case .staging, .production:
            return nil
        }
    }
}
