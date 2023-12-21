//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI

struct SpyBugService {
    func createBugReport(apiKey: String, reportIn: ReportCreate) async throws -> Report {
        let parameters = [
            URLQueryItem(name: "key", value: apiKey),
        ]
        let request = try ServiceHelper().createRequest(endpoint: "/reports", method: .post, parameters: parameters, payload: reportIn)
        return try await ServiceHelper().fetchJSON(request: request)
    }

    func addPicturesToCreateBugReport(apiKey: String, reportId: UUID, pictures: [Data]) async throws -> Report {
        let parameters = [
            URLQueryItem(name: "key", value: apiKey),
        ]
        let request = try ServiceHelper().createDataRequest(endpoint: "/reports/\(reportId)/pictures", parameters: parameters)
        for picture in pictures {
            request.addDataField(named: "pictures", filename: "pet.jpeg", data: picture, mimeType: "image/jpeg")
        }
        return try await ServiceHelper().fetchJSON(request: request.asURLRequest())
    }
}

enum ReportType: String, Codable {
    case bug
    case improvement
    case question
    case feature
}

struct Report: Decodable {
    var description: String?
    var type: ReportType
    var authorEmail: String?
    var id: UUID
    var createdAt: Date?
    var pictureUrls: [String]?
}

struct ReportCreate: Encodable {
    var description: String?
    var type: ReportType
    var authorEmail: String?
}
