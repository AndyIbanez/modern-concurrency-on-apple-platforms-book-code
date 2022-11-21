//
//  UserInfo.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/12/22.
//

import Foundation

struct UserInfo: Codable {
    let username: String
    let avatarUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case username
        case avatarUrl = "avatar_url"
    }
}
