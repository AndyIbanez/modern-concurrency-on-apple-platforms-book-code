//
//  UserProfileView.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/18/22.
//

import SwiftUI
import LocalAuthentication

struct UserProfileView: View {
    @StateObject private var viewModel: UserProfileViewModel
    
    init() {
        // NOTE TO SELF: Something changed after Xcode 13.3 that it yields a warning
        // when initializing this property on the declaration level. Hopefully
        // I will find a better solution by the time the book is released.
        _viewModel = StateObject(wrappedValue: UserProfileViewModel())
    }
    
    var body: some View {
        if let userInfo = viewModel.userInfo, viewModel.isAuthenticated {
            VStack {
                GroupBox {
                    AsyncImage(url: userInfo.avatarUrl)
                        .frame(width: 150, height: 150)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    Text(userInfo.username)
                        .font(.title)
                    HStack {
                        VStack {
                            Text(String(viewModel.followingFollowersInfo?.following ?? 0))
                                .font(.title3)
                            Text("Following")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text(String(viewModel.followingFollowersInfo?.followers ?? 0))
                                .font(.title3)
                            Text("Followers")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                Spacer()
            }
        } else {
            Button {
                Task {
                    await viewModel.authenticateAndFetchProfile()
                }
            } label: {
                if viewModel.availableBiometricType == .none {
                    Text("Authenticate")
                } else {
                    Label {
                        Text("Authenticate")
                    } icon: {
                        Image(systemName: imageNameForBiometricType(viewModel.availableBiometricType))
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func imageNameForBiometricType(_ biometricType: LABiometryType) -> String {
        if biometricType == .faceID {
            return "faceid"
        }
        return "touchid"
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

