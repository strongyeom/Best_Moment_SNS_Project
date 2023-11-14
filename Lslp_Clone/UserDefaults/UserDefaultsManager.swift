//
//  UserDefaulsManager.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/14.
//

import Foundation
class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    
    private init() { }
    
    func initialScreenSave(isSelected: String) {
        print("UserDefaults - 초기화면 저장 \(isSelected)")
        UserDefaults.standard.set(isSelected, forKey: "isLaunched")
    }
    
    func initalScreenLoad() -> String {
        print("UserDefaults - 초기화면 로드")
        return UserDefaults.standard.string(forKey: "isLaunched") ?? "SelectedVC"
        
    }
    
}
