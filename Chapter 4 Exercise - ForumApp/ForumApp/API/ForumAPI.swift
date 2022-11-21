//
//  ForumAPI.swift
//  ForumApp
//
//  Created by Andy Ibanez on 6/1/22.
//

import Foundation

class ForumAPI: ObservableObject {
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    private let forumFriendsURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/forum/friends_online.json")!
    private let userInfoURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/forum/user_info.json")!
    private let forumStatsURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/forum/forum_stats.json")!
    private let userProfileBaseURL = URL(string: "https://www.andyibanez.com/fairesepages.github.io/books/async-await/forum/profile")!
    
    private func downloadAndDecode<T>(_ type: T.Type, url: URL) async throws -> T where T: Codable {
        let (data, _) = try await urlSession.data(from: url)
        let object = try JSONDecoder().decode(T.self, from: data)
        return object
    }
    
    public func fetchCurrentUserInfo() async throws -> UserInfo {
        return try await downloadAndDecode(UserInfo.self, url: userInfoURL)
    }
    
    public func fetchForumStats() async throws -> ForumStats {
        return try await downloadAndDecode(ForumStats.self, url: forumStatsURL)
    }
    
    public func fetchOnlineFriends() async throws -> [ForumFriend] {
        return try await downloadAndDecode([ForumFriend].self, url: forumFriendsURL)
    }
    
    public func fetchProfile(for username: String) async throws -> UserInfo {
        let url = userProfileBaseURL.appendingPathComponent("\(username).json")
        return try await downloadAndDecode(UserInfo.self, url: url)
    }
    
    public func fetchProfiles(for usernames: [String]) async throws -> [UserInfo] {
        if usernames.count >= 3 {
            let firstFriend = try await fetchProfile(for: usernames[0])
            let secondFriend = try await fetchProfile(for: usernames[1])
            let thirdFriend = try await fetchProfile(for: usernames[2])
            return [firstFriend, secondFriend, thirdFriend]
        }
        return []
    }
}
