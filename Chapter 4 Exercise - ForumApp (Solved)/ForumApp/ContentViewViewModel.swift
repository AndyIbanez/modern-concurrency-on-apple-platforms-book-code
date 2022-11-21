//
//  ContentViewViewModel.swift
//  ForumApp
//
//  Created by Andy Ibanez on 6/1/22.
//

import Foundation

@MainActor
class ContentViewViewModel: ObservableObject {
    var api: ForumAPI?
    
    @Published private(set) var loggedInUserInfo: UserInfo?
    @Published private(set) var loggedInUserForumStats: ForumStats?
    @Published private(set) var friendsProfiles: [UserInfo] = []
    
    func fetchLoggedInUserInfo() {
        guard let api = api else { return }
        Task {
            let info = try await fetchProfileAndForumStats()
            self.loggedInUserInfo = info.userInfo
            self.loggedInUserForumStats = info.forumStats
        }
    }
    
    func fetchProfileAndForumStats() async throws -> (userInfo: UserInfo, forumStats: ForumStats) {
        let api = self.api!
        async let userInfo = try api.fetchCurrentUserInfo()
        async let forumStats = try api.fetchForumStats()
        return try await (userInfo, forumStats)
    }
    
    func fetchFriends() {
        guard let api = api else { return }
        Task {
            let friendNames = try await api.fetchOnlineFriends().map { $0.username }
            let profiles = try await api.fetchProfiles(for: friendNames)
            self.friendsProfiles = profiles
        }
    }
}
