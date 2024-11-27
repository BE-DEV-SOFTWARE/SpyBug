//
//  Report.swift
//
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import SwiftUI
import Foundation

public enum ReportType: String, Codable, CaseIterable {
    case bug
    case improvement
    case question
    case feature
    
    var title: LocalizedStringKey {
        return switch self {
        case .bug:
            "Report a problem"
        case .improvement:
            "Request improvement"
        case .question:
            "Ask a question"
        case .feature:
            "Propose a feature"
        }
    }
    
    var shortTitle: LocalizedStringKey {
        return switch self {
        case .bug:
            "Problem"
        case .improvement:
            "Improvement"
        case .question:
            "Question"
        case .feature:
            "Feature"
        }
    }
    
    var icon: Image {
        return switch self {
        case .bug:
            Image(.bug)
        case .improvement:
            Image(.rocket)
        case .question:
            Image(.circleQuestion)
        case .feature:
            Image(.wand)
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
