//
//  HttpServices.swift
//  
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import Foundation
import SwiftUI

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct APIErrorMessage: Decodable {
    var statusCode: Int
    var message: String
    var error: String
}

enum APIError: Error {
    case errorCreatingURL
    case errorCreatingRequest
    case decodingError
}

struct ServiceHelper {
    private func isResponseOK(statusCode:  Int) -> Bool {
        return (200...299).contains(statusCode)
    }
    
    private func createURL(endpoint: String, parameters: [URLQueryItem]? = []) -> URL? {
        var component = URLComponents()
        component.scheme = Constant.apiScheme
        component.path = Constant.baseURL + endpoint
        component.queryItems = parameters
        return component.url
    }
    
    private func handelHttpError(data: Data, response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            let statusCode = response.statusCode
            guard !isResponseOK(statusCode: statusCode) else { return }
            do {
                let decoder = JSONDecoder()
                let apiErrorMessage = try decoder.decode(APIErrorMessage.self, from: data)
#if DEBUG
                print(apiErrorMessage)
#endif
            } catch {
                print("Decoding error message from API failed 😢")
                print("Response Data:", String(data: data, encoding: .utf8) ?? "Empty")
                print("Status Code:", statusCode)
                //TODO: handle decoding errors
            }
            if let status = HttpStatus(rawValue: statusCode) {
                throw NetworkError.httpStatus(status)
            } else {
                throw NetworkError.unknownHttpStatus(statusCode)
            }
        }
    }
    
    func createRequest(endpoint: String, method: HTTPMethod, parameters: [URLQueryItem]? = [], payload: Encodable? = nil, tokenString: String? = nil) throws -> URLRequest {
        guard let url = createURL(endpoint: endpoint, parameters: parameters) else { throw APIError.errorCreatingURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let payload {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .formatted(DateFormatter.isoFull)
            request.httpBody = try encoder.encode(payload)
        }
        return request
    }
    
    func createDataRequest(endpoint: String, parameters: [URLQueryItem]? = []) throws -> MultipartFormDataRequest {
        guard let url = createURL(endpoint: endpoint, parameters: parameters) else { throw APIError.errorCreatingURL }
        return MultipartFormDataRequest(url: url)
    }
    
    func fetchJSON<T:Decodable>(request: URLRequest) async throws -> T {
        let sesssion = URLSession.shared
#if DEBUG
        request.debug()
#endif
        let (data, response) = try await sesssion.data(for: request)
        
        try handelHttpError(data: data, response: response)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategyFormatters = [
            DateFormatter.standard,
            DateFormatter.isoFull,
            DateFormatter.yearMonthDay,
            DateFormatter.iso8601
        ]
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            // Print the detailed decoding error
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Data corrupted:", context.debugDescription)
                    
                case .keyNotFound(let key, let context):
                    print("Key not found:", key.stringValue)
                    print("Debug description:", context.debugDescription)
                    
                case .typeMismatch(let type, let context):
                    print("Type mismatch:", type)
                    print("Debug description:", context.debugDescription)
                    
                case .valueNotFound(let type, let context):
                    print("Value not found for type:", type)
                    print("Debug description:", context.debugDescription)
                    
                @unknown default:
                    print("Unknown decoding error")
                }
            } else {
                print("Decoding error:", error.localizedDescription)
            }
            throw error
        }
    }
}

fileprivate extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields ?? "No headers")
        print("Body:")
        if let httpBody = self.httpBody {
            print(String(data: httpBody, encoding: .ascii)!)
        } else {
            print("No body :(")
        }
    }
}
