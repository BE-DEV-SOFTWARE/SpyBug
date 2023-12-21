//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
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
