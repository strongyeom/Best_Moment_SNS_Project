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

struct AddPostResponse: Decodable {
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

struct ReadPostResponse: Decodable {
    var data: [ElementReadPostResponse]
    var next_cursor: String
}

struct ElementReadPostResponse: Decodable {
    var likes: [String]
    var image: [String]
    var hashTags: [String]
    var comments: [String]
    var _id: String
    var creator: Creator
    var time: String
    var title: String
    var content: String
//    var content1: String
//    var content2: String
//    var content3: String
//    var content4: String
//    var content5: String
    var product_id: String
}

struct Creator: Decodable {
    var _id: String
    var nick: String
}

struct RefreshResponse: Decodable {
    let token: String
}

struct LogOutResponse: Decodable {
    let _id: String
    let email: String
    let nick: String
}

struct LikeResponse: Decodable {
    let like_status: Bool
}

struct RemovePostResponse: Decodable {
    let _id: String
}
