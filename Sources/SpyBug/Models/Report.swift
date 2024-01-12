//
//  Report.swift
//
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import SwiftUI
import Foundation

enum ReportType: String, Codable, CaseIterable {
    case bug
    case improvement
    case question
    case feature
    
    var title: LocalizedStringKey {
        switch self {
        case .bug:
            return "Report a problem"
        case .improvement:
            return "Request improvement"
        case .question:
            return "Ask a question"
        case .feature:
            return "Propose a feature"
        }
    }
    
    var icon: Image {
        switch self {
        case .bug:
            return Image.bug
        case .improvement:
            return Image.rocket
        case .question:
            return Image.circleQuestion
        case .feature:
            return Image.wand
        }
    }
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
