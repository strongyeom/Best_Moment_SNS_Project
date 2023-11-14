//
//  APIModel.swift
//  Lslp_Clone
//
//  Created by 염성필 on 2023/11/13.
//

import Foundation

struct Signup: Encodable {
    let email: String
    let password: String
    let nickname: String
}

struct Login: Encodable {
    let email: String
    let password: String
}


// MARK: - Decoding
// 어떤 시점에 이메일을 저장할지 중요함 ex) 회원가입할때 네트워크 끊겼는데 닉네임이 저장되면 안되기 때문에 그러한 사항 고려
struct JoinResponse: Decodable {
    let email: String
    let nick : String
}

struct Token: Decodable {
    let token: String
    let refreshToken: String
}
