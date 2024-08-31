//
//  SpyBugConfig.swift
//
//
//  Created by Jonathan Bereyziat on 15/07/2024.
//

import Foundation

class SpyBugConfig {
    static let shared = SpyBugConfig()
    
    //Force users of SpyBugConfig to use the shared instance
    private init() {
        setApiKey()
    }
    
    private func setApiKey() {
        // Get API key from the .plist
        guard let apiKey = Bundle.main.infoDictionary?[Constant.plistAPIKeyLocation] as? String else {
            fatalError("⚠️`SpyBugAPIKey` key is missing in your Info.plist configuration file. Go to app.spybug.io to get copy the API key of your app and add it to your Info.plist file.⚠️")
        }
        // Store API key in keychain during usage
        let query = [
            kSecValueData: apiKey.data(using: .utf8)!,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Constant.keychainAPIKeyLocation
        ] as CFDictionary
        
        // Try to delete old value if it exists
        SecItemDelete(query)
        
        // Add new value to keychain
        let _ = SecItemAdd(query, nil)
    }
    
    func getApiKey() -> String? {
        let query = [
            kSecReturnData: kCFBooleanTrue!,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Constant.keychainAPIKeyLocation,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        if let data = result as? Data, let apiKeyStr = String(data: data, encoding: .utf8) {
            return apiKeyStr
        }
        
        return nil
    }
}


// Get API key function is separated to make that only setting the API key is public not accessing it
// This ensures that the access to the API key is
class SpyBugConfigAccessor {
    static let shared = SpyBugConfigAccessor()
    
    private init() {}
    
}
