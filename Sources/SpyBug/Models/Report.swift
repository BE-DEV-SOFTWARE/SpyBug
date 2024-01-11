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
    
    private var resourceName: String {
        switch self {
        case .bug:
            return "bug-regular"
        case .improvement:
            return "rocket-launch-regular"
        case .question:
            return "circle-question-regular"
        case .feature:
            return "wand-magic-sparkles-regular"
        }
    }
    
    var icon: Image {
        Image(packageResource: self.resourceName, ofType: "png")
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
