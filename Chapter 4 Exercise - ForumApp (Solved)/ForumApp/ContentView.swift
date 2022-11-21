//
//  ContentView.swift
//  ForumApp
//
//  Created by Andy Ibanez on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var api: ForumAPI
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        ScrollView {
            if let userInfo = viewModel.loggedInUserInfo {
                profileView(userInfo: userInfo)
            } else {
                ProgressView()
            }
            if let forumStast = viewModel.loggedInUserForumStats {
                GroupBox {
                    HStack {
                        textPair(title: "Total Posts", data: String(forumStast.totalPosts))
                        Spacer()
                        textPair(title: "Total Threads", data: String(forumStast.totalThreads))
                        Spacer()
                        textPair(title: "New Posts", data: String(forumStast.postsSinceLastLogin))
                    }
                }
            } else {
                ProgressView()
            }
            if !viewModel.friendsProfiles.isEmpty {
                HStack {
                    Text("Online Friends")
                        .font(.title)
                    Spacer()
                }
                ForEach(viewModel.friendsProfiles, id: \.username) {
                    profileView(userInfo: $0)
                }
            } else {
                ProgressView()
            }
        }
        .padding(.horizontal)
        .onAppear {
            if viewModel.api == nil {
                viewModel.api = api
                viewModel.fetchLoggedInUserInfo()
                viewModel.fetchFriends()
            }
        }
    }
    
    @ViewBuilder
    func textPair(title: String, data: String) -> some View {
        VStack {
            Text(title)
                .font(.footnote)
            Text(data)
                .font(.title3)
        }
    }
    
    @ViewBuilder
    func profileView(userInfo: UserInfo) -> some View {
        GroupBox {
            HStack {
                AsyncImage(url: userInfo.avatarURL)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                    Text(userInfo.username)
                        .font(.title)
                    HStack {
                        Spacer()
                        Text("Member since: \(userInfo.joinDateString)")
                            .font(.footnote)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
