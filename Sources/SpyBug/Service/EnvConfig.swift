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
        return "localhost/api/v1"
    }
    
    static var apiScheme: String {
        return "http"
    }
    
    static var port: Int? {
        return nil
    }
}
