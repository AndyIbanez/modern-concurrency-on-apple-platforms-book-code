//
//  UserProfileViewModel.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/18/22.
//

import Foundation
import LocalAuthentication

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published private(set) var userInfo: UserInfo?
    @Published private(set) var loadingStatus: LoadingStatus?
    @Published private(set) var isAuthenticated = false
    @Published private(set) var followingFollowersInfo: FollowerFollowingInfo?
    
    var availableBiometricType: LABiometryType {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return .none }
        return context.biometryType
    }
    
    private func authenticateWithBiometrics() async -> Bool {
        let context = LAContext()
        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To fetch your profile")
            return success
        } catch {
            return false
        }
    }
    
    func authenticateAndFetchProfile() async {
        isAuthenticated = await authenticateWithBiometrics()
        if isAuthenticated {
            do {
                loadingStatus = .loading
                let data = try await fetchData()
                userInfo = data.userInfo
                followingFollowersInfo = data.followingFollowersInfo
                self.loadingStatus = .idle
            } catch {
                loadingStatus = .error(error)
            }
        }
    }
    
    func fetchData() async throws -> (userInfo: UserInfo, followingFollowersInfo: FollowerFollowingInfo) {
        let userApi = UserAPI()
        async let userInfo = userApi.fetchUserInfo()
        async let followers = userApi.fetchFollowingAndFollowers()
        return (try await userInfo, try await followers)
    }
}
