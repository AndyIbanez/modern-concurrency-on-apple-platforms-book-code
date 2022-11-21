//
//  UserAPI.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/12/22.
//

import Foundation

class UserAPI {
    func fetchUserInfo() async throws -> UserInfo {
        let url = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/user_profile.json")!
        let session = URLSession.shared
        let (userInfoData, _) = try await session.data(from: url)
        let userInfo = try JSONDecoder().decode(UserInfo.self, from: userInfoData)
        return userInfo
    }
    
    func fetchFollowingAndFollowers() async throws -> FollowerFollowingInfo {
        let url = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/user_followers.json")!
        let session = URLSession.shared
        let (data, _) = try await session.data(from: url)
        let followingFollowers = try JSONDecoder().decode(FollowerFollowingInfo.self, from: data)
        return followingFollowers
    }
}
