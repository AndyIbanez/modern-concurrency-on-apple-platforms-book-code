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
                let userApi = UserAPI()
                loadingStatus = .loading
                userInfo = try await userApi.fetchUserInfo()
                followingFollowersInfo = try await userApi.fetchFollowingAndFollowers()
                self.loadingStatus = .idle
            } catch {
                loadingStatus = .error(error)
            }
        }
    }
}
