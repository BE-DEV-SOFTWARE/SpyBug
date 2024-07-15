//
//  SpyBugConfig.swift
//
//
//  Created by Jonathan Bereyziat on 15/07/2024.
//

import Foundation

public class SpyBugConfig {
    static let shared = SpyBugConfig()
    
    private init() {}
    
    func setApiKey(_ apiKey: String) {
        let query = [
            kSecValueData: apiKey.data(using: .utf8)!,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: Constant.keychainAPIKeyLocation
        ] as CFDictionary
        
        // Try to delete old value if it exists
        SecItemDelete(query)
        
        // Add new value to keychain
        let status = SecItemAdd(query, nil)
    }
}


// Get API key function is separated to make that only setting the API key is public not accessing it
// This ensures that the access to the API key is
class SpyBugConfigAccessor {
    static let shared = SpyBugConfigAccessor()
    
    private init() {}
    
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
