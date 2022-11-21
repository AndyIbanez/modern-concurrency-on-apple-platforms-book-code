//
//  UserProfileViewModel.swift
//  Chapter 2 - Social Media App (iOS)
//
//  Created by Andy Ibanez on 4/18/22.
//

import Foundation
import LocalAuthentication

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

    private func fetchUserInfo() {
        let userApi = UserAPI()
        print("Beginning data download")
        print("Downloading User info")
        userApi.fetchUserInfo { userInfo, error in
            DispatchQueue.main.async {
                print("User info downloaded")
                if let error = error {
                    self.loadingStatus = .error(error)
                } else if let userInfo = userInfo {
                    self.loadingStatus = .idle
                    self.userInfo = userInfo
                }
            }
        }
        print("Ending function")
    }
    
    private func authenticateWithBiometrics(
        completionHandler: @escaping (_ success: Bool) -> Void
    ) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To fetch your profile") { success, _ in
            DispatchQueue.main.async {
                completionHandler(success)
            }
        }
    }
    
    func authenticateAndFetchProfile() {
        authenticateWithBiometrics { success in
            if success {
                self.isAuthenticated = true
                
                let userApi = UserAPI()
                userApi.fetchUserInfo { userInfo, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.loadingStatus = .error(error)
                        } else if let userInfo = userInfo {
                            self.loadingStatus = .idle
                            self.userInfo = userInfo
                        }
                    }
                }
            }
        }
    }
}
