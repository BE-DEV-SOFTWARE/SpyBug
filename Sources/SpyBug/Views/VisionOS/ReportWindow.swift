//
//  ReportWindow.swift
//  SpyBug
//
//  Created by Jonathan Bereyziat on 11/17/24.
//

import SwiftUI

#if os(visionOS)
public func ReportWindow(reportTypes: [ReportType] = ReportType.allCases, width: CGFloat = 400, height: CGFloat = 580 ) -> some Scene {
    WindowGroup(id: Constant.reportWindowId) {
        ReportOptionsView(reportTypes: reportTypes)
    }
    .defaultSize(width: width, height: height)
}
#endif
