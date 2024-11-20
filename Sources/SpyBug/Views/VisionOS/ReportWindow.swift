//
//  ReportWindow.swift
//  SpyBug
//
//  Created by Jonathan Bereyziat on 11/17/24.
//

import SwiftUI

#if os(visionOS)
public func ReportWindow(reportTypes: [ReportType] = ReportType.allCases) -> some Scene {
    WindowGroup(id: Constant.reportWindowId){
        ReportOptionsView(reportTypes: reportTypes)}
    .defaultSize(width: 550, height: 1000)
}
#endif
