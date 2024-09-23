//
//  ReportTypeConfigurationManager.swift
//  SpyBug
//
//  Created by Pavel Kurzo on 23/09/2024.
//

import SwiftUI

class ReportTypeConfigurationManager {
    private let reportTypesKey = "selectedReportTypes"
    
    func saveSelectedReportTypes(_ reportTypes: [ReportType]) {
        let encodedData = try? JSONEncoder().encode(reportTypes)
        UserDefaults.standard.set(encodedData, forKey: reportTypesKey)
    }
    
    func loadSelectedReportTypes() -> [ReportType] {
        guard let savedData = UserDefaults.standard.data(forKey: reportTypesKey),
              let decodedReportTypes = try? JSONDecoder().decode([ReportType].self, from: savedData) else {
            return ReportType.allCases
        }
        return decodedReportTypes
    }
}
