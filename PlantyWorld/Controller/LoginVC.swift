//
//  LoginVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/27.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import UIKit

class LoginVC: UIViewController {
    
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightPeach
        setSignInWithAppleBtn()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func setSignInWithAppleBtn() {
        let signInWithAppleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp,
                                                              authorizationButtonStyle: chooseAppleButtonStyle())
        view.addSubview(signInWithAppleBtn)
        signInWithAppleBtn.cornerRadius = 25
        signInWithAppleBtn.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        signInWithAppleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInWithAppleBtn.widthAnchor.constraint(equalToConstant: 280).isActive = true
        signInWithAppleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInWithAppleBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true

    }

    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
        return (UITraitCollection.current.userInterfaceStyle == .light) ? .white : .white
        // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕, 只有這兩個模式
    }
    
    @objc func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
//        UserManager.shared.addUser(name: , email: <#T##String#>)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
}

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//
//                // Save authorised user ID for future reference
//                UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
//
//                // Retrieve the secure nonce generated during Apple sign in
//                guard let nonce = self.currentNonce else {
//                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                }
//
//                // Retrieve Apple identity token
//                guard let appleIDToken = appleIDCredential.identityToken else {
//                    print("Failed to fetch identity token")
//                    return
//                }
//
//                // Convert Apple identity token to string
//                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                    print("Failed to decode identity token")
//                    return
//                }
//
//                // Initialize a Firebase credential using secure nonce and Apple identity token
//                let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
//                                                                  idToken: idTokenString,
//                                                                  rawNonce: nonce)
//
//                // Sign in with Firebase
//                Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
//
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//
//                    // Mak a request to set user's display name on Firebase
//                    let changeRequest = authResult?.user.createProfileChangeRequest()
//                    changeRequest?.displayName = appleIDCredential.fullName?.givenName
//                    changeRequest?.commitChanges(completion: { (error) in
//
//                        if let error = error {
//                            print(error.localizedDescription)
//                        } else {
//                            print("wait")
////                            print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
//                        }
//                    })
//                }
//
//            }
        
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                showAlert(title: "", message: "Unable to fetch identity token", buttonTitle: "", vc: self)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                showAlert(title: "",
                          message: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)",
                          buttonTitle: "", vc: self)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let changeRequest = authResult?.user.createProfileChangeRequest()
//        changeRequest?.displayName = appleIDProvider.fullName?.givenName
//        changeRequest?.commitChanges(completion: { (error) in
//
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
//            }
//        })

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
//        case ASAuthorizationError.canceled:
//            showAlert(title: "使用者取消登入", message: "", buttonTitle: "")
            
        case ASAuthorizationError.failed:
            showAlert(title: "授權請求失敗", message: "", buttonTitle: "", vc: self)
            
        case ASAuthorizationError.invalidResponse:
            showAlert(title: "授權請求無回應", message: "", buttonTitle: "", vc: self)
            
        case ASAuthorizationError.notHandled:
            showAlert(title: "授權請求未處理", message: "", buttonTitle: "", vc: self)
            
        case ASAuthorizationError.unknown:
            showAlert(title: "授權失敗，原因不知", message: "", buttonTitle: "", vc: self)
            
        default:
            break
        }
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension LoginVC {
    // MARK: - 透過 Credential 與 Firebase Auth 串接
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else {
                self.showAlert(title: "", message: "\(String(describing: error!.localizedDescription))", buttonTitle: "", vc: self)
                return
            }
            self.showAlert(title: "登入成功！", message: "", buttonTitle: "Close", vc: self)
        }
    }
    // MARK: - Firebase 取得登入使用者的資訊
    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else {
            showAlert(title: "無法取得使用者資料！", message: "", buttonTitle: "", vc: self)
            return
        }
        let uid = user.uid
        let email = user.email
        showAlert(title: "使用者資訊", message: "UID：\(uid)\nEmail：\(email!)", buttonTitle: "", vc: self)
    }
    
// MARK: - 監聽目前的 Apple ID 的登入狀況
// 主動監聽
    func checkAppleIDCredentialState(userID: String) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { credentialState, _ in
            switch credentialState {
            case .authorized:
                self.showAlert(title: "使用者已授權！", message: "", buttonTitle: "", vc: self)
            case .revoked:
                self.showAlert(title: "使用者憑證已被註銷！",
                               message: "請到\n「設定 → Apple ID → 密碼與安全性 → 使用 Apple ID 的 App」\n將此 App 停止使用 Apple ID\n並再次使用 Apple ID 登入本 App！",
                               buttonTitle: "", vc: self)
            case .notFound:
                self.showAlert(title: "", message: "使用者尚未使用過 Apple ID 登入！", buttonTitle: "", vc: self)
            case .transferred:
                self.showAlert(title: "請與開發者團隊進行聯繫，以利進行使用者遷移！", message: "", buttonTitle: "", vc: self)
            default:
                break
            }
        }
        
        func observeAppleIDState() {
            NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (notification: Notification) in
                self.showAlert(title: "使用者登入或登出", message: "", buttonTitle: "", vc: self)
            }
        }
    }
}
