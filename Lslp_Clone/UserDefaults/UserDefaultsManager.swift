//
//  UserDefaulsManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/14.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    func saveToken(token: TokenResponse) {
        UserDefaults.standard.set(token.token, forKey: "accessToken")
        UserDefaults.standard.set(token.refreshToken, forKey: "refreshToken")
        print("UD에 저장 AT, RT", token.token, token.refreshToken)
    }
    
    func loadToken() {
        UserDefaults.standard.string(forKey: "accessToken")
        UserDefaults.standard.string(forKey: "refreshToken")
    }
}
