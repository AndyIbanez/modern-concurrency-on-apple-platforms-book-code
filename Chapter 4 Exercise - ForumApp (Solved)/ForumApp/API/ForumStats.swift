//
//  ForumStats.swift
//  ForumApp
//
//  Created by Andy Ibanez on 6/1/22.
//

import Foundation

struct ForumStats: Codable {
    enum CodingKeys: String, CodingKey {
        case totalPosts = "total_posts"
        case totalThreads = "total_threads"
        case postsSinceLastLogin = "posts_since_last_login"
    }
    
    let totalPosts: Int
    let totalThreads: Int
    let postsSinceLastLogin: Int
}
