//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI

struct SpyBugService {
    func markConversationAsRead() async throws -> Report {
        let request = try ServiceHelper().createRequest(endpoint: "reports", method: .post)
        return try await ServiceHelper().fetchJSON(request: request)
    }
}

struct Report: Decodable {
    let id: UUID
    let description: String
    let type: String
    let authorEmail: String
    let createdAt: Data
    let pictureUrls: [String]
}
