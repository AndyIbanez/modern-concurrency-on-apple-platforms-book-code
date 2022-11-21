//
//  UserInfo.swift
//  ForumApp
//
//  Created by Andy Ibanez on 6/1/22.
//

import Foundation

struct UserInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case username
        case joinDateString = "join_date"
        case avatarURL = "avatar_url"
    }
    
    let username: String
    let joinDateString: String
    let avatarURL: URL
}
