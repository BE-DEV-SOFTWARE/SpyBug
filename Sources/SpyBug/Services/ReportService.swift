//
//  SpyBugService.swift
//
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct SpyBugService {
    func createBugReport(reportIn: ReportCreate) async throws -> Report {
        guard let apiKey = SpyBugConfig.shared.getApiKey() else {
            fatalError("SpyBug: it seems like you forgot to provide an API key 🤷🏻‍♂️")
        }
        let parameters = [
            URLQueryItem(name: "key", value: apiKey),
        ]
        let request = try ServiceHelper().createRequest(endpoint: "/reports/", method: .post, parameters: parameters, payload: reportIn)
        return try await ServiceHelper().fetchJSON(request: request)
    }

    func addPicturesToCreateBugReport(reportId: UUID, files: [Data]) async throws -> Report {
        guard let apiKey = SpyBugConfig.shared.getApiKey() else {
            fatalError("SpyBug: it seems like you forgot to provide an API key 🤷🏻‍♂️")
        }
        let parameters = [
            URLQueryItem(name: "key", value: apiKey),
        ]
        let request = try ServiceHelper().createDataRequest(endpoint: "/reports/\(reportId)/attachment", parameters: parameters)
        // TODO: change to handle files and not only jpeg
        for file in files {
            request.addDataField(named: "files", filename: "report.jpeg", data: file, mimeType: "image/jpeg")
        }
        return try await ServiceHelper().fetchJSON(request: request.asURLRequest())
    }
    
    func addFilesToReport(reportId: UUID, files: [URL]) async throws -> Report {
        guard let apiKey = SpyBugConfig.shared.getApiKey() else {
            fatalError("SpyBug: it seems like you forgot to provide an API key 🤷🏻‍♂️")
        }
        let parameters = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        let request = try ServiceHelper().createDataRequest(endpoint: "/reports/\(reportId)/attachment", parameters: parameters)
        for fileURL in files {
            let accessed = fileURL.startAccessingSecurityScopedResource()
            defer {
                if accessed { fileURL.stopAccessingSecurityScopedResource() }
            }
            
            guard let fileData = try? Data(contentsOf: fileURL) else { continue }
            let filename = fileURL.lastPathComponent
            let mimeType = mimeType(for: fileURL)
            
            request.addDataField(named: "files", filename: filename, data: fileData, mimeType: mimeType)
        }
        return try await ServiceHelper().fetchJSON(request: request.asURLRequest())
    }
    
    private func mimeType(for url: URL) -> String {
        let pathExtension = url.pathExtension.lowercased()
        
        switch pathExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "pdf":
            return "application/pdf"
        case "xls":
            return "application/vnd.ms-excel"
        case "xlsx":
            return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "gdoc":
            return "application/vnd.google-apps.document"
        case "gsheet":
            return "application/vnd.google-apps.spreadsheet"
        case "doc":
            return "application/msword"
        case "docx":
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "ppt":
            return "application/vnd.ms-powerpoint"
        case "pptx":
            return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case "txt":
            return "text/plain"
        
        default:
            if let uti = UTType(filenameExtension: pathExtension),
               let mimeType = uti.preferredMIMEType {
                return mimeType
            }
            return "application/octet-stream"
        }
    }
}
