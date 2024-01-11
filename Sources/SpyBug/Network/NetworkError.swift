//
//  NetworkError.swift
//
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import SwiftUI

enum NetworkError : Error, LocalizedError {
    case noInternet
    case httpStatus(HttpStatus)
    case unknownHttpStatus(Int)
    case unknown(Error)
    
    public var description: String? {
        switch self {
            case .noInternet:
                return "No Internet"
                
            case .httpStatus(let code):
                return "HTTP status code: \(code)"
                
            case .unknown(let error):
                return "Error: \(error)"
            
            case .unknownHttpStatus(let code):
                return "Unknown HTTP status code: \(code)"
        }
    }
    
    public var localizedDescription: LocalizedStringKey? {
        guard let description else { return nil }
        return LocalizedStringKey(description)
    }
}
