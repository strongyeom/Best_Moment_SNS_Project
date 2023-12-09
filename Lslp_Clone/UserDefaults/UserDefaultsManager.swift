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
    
    func saveUserID(_ id: String) {
        UserDefaults.standard.set(id, forKey: "UserID")
    }
    
    func loadUserID() -> String {
        
        guard let userid = UserDefaults.standard.string(forKey: "UserID") else { return "" }
        
        return userid
    }
    
    // 로그아웃 하거나 토큰이 만료되어 로그인뷰로 갔을때 초기화
    
    // 로그인 버튼 눌렀을 때  다시 id값 저장

    
    func saveNickname(_ nick: String) {
        UserDefaults.standard.set(nick, forKey: "nickname")
    }
    
    func loadNickname() -> String {
        guard let nickname = UserDefaults.standard.string(forKey: "nickname") else {
            return ""
        }
        return nickname
    }

    func backToRoot(isRoot: Bool = false) {
        UserDefaults.standard.set(isRoot, forKey: "isVaild")
    }
    
    func backToCall() -> Bool {
        return UserDefaults.standard.bool(forKey: "isVaild")
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
