//
//  MultipartFormDataRequest.swift
//
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import SwiftUI
import Foundation

struct MultipartFormDataRequest {
    private let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()
    let url: URL
    let token: Token?

    public init(url: URL, token: Token?) {
        self.url = url
        self.token = token
    }

    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }

    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\";\r\n"
        fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
        fieldString += "Content-Transfer-Encoding: 8bit\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    func addDataField(named name: String, filename: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(named: name, filename: filename, data: data, mimeType: mimeType))
    }

    private func dataFormField(named name: String,
                               filename: String,
                               data: Data,
                               mimeType: String) -> Data
    {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }

    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token {
            request.setValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
        }

        httpBody.append("--\(boundary)--")

        request.httpBody = httpBody as Data
        return request
    }
}

extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension URLSession {
    func dataTask(with request: MultipartFormDataRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask
    {
        return dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
    }
}
