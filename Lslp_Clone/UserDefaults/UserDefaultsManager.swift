//
//  UserDefaulsManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/14.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    func saveAccessToken(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
    }
    
    func saveRefreshToken(refreshToken: String) {
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
    }
 
    func backToRoot(isRoot: Bool = false) {
        UserDefaults.standard.set(isRoot, forKey: "isVaild")
    }
    
    func backToCall() -> Bool {
        return UserDefaults.standard.bool(forKey: "isVaild")
    }
 
    var accessToken: String {
        UserDefaults.standard.string(forKey: "accessToken") ?? "엑세스 토큰 없음"
    }
    
    var refreshToken: String {
        UserDefaults.standard.string(forKey: "refreshToken") ?? "리프레쉬 토큰 없음"
    }
}
