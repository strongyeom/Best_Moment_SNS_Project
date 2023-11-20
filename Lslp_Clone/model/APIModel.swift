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
    let nick: String
}

struct Login: Encodable {
    let email: String
    let password: String
}


// MARK: - Decoding
// 어떤 시점에 이메일을 저장할지 중요함 ex) 회원가입할때 네트워크 끊겼는데 닉네임이 저장되면 안되기 때문에 그러한 사항 고려
struct JoinResponse: Decodable {
    let _id: String
    let email: String
    let nick : String
}

struct TokenResponse: Decodable {
    let token: String
    let refreshToken: String
}

struct ValidateEmailResponse : Decodable {
    let message: String
}

struct ContentResponse: Decodable {
    var likes: [String]
    var image: [String]
    var hashTags: [String]
    var comments: [String]
    var _id: String
    var creator: Creator
    var time: String
    var title: String
    var content: String
    var product_id: String
}

struct Creator: Decodable {
    var _id: String
    var nick: String
}

/*
 {
     "likes": [],
     "image": [],
     "hashTags": [],
     "comments": [],
     "_id": "655b19795b34e559bca094b5",
     "creator": {
         "_id": "655af52ac096a84b01079694",
         "nick": "yeom4"
     },
     "time": "2023-11-20T08:31:53.603Z"
 }
 */

struct RefreshResponse: Decodable {
    let accessToken: String
}

struct LogOutResponse: Decodable {
    let _id: String
    let email: String
    let nick: String
}
