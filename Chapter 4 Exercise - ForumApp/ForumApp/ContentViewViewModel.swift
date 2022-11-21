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
            self.loggedInUserInfo = try await api.fetchCurrentUserInfo()
            self.loggedInUserForumStats = try await api.fetchForumStats()
        }
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
