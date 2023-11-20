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
    
    func refreshToAccessToken(token: RefreshResponse) {
        UserDefaults.standard.set(token.token, forKey: "accessToken")
    }

    
    var accessToken: String {
        UserDefaults.standard.string(forKey: "accessToken") ?? "엑세스 토큰 없음"
    }
    
    var refreshToken: String {
        UserDefaults.standard.string(forKey: "refreshToken") ?? "리프레쉬 토큰 없음"
    }
}
