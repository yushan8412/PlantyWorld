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
//import FirebaseUI

class LoginVC: UIViewController {
    
    fileprivate var currentNonce: String?
    
    lazy var appleLogInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .default,
                                                  authorizationButtonStyle: .white)
        button.cornerRadius = 10
//        button.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(appleLogInButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appleLogInButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

    }
    
    private func setUpButton() {
        let guide = view.safeAreaLayoutGuide
        appleLogInButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 50).isActive = true
        appleLogInButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -50).isActive = true
        appleLogInButton.topAnchor.constraint(equalTo: guide.bottomAnchor, constant: 40).isActive = true
        appleLogInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func handleLogInWithAppleID() {
        
        let nonce = randomNonceString()
        
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        
        let request = provider.createRequest()
        
        request.requestedScopes = [.email]
        
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
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
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }

    
}

extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                
                if let error = error {
                    
                    self.showAlert(title: "登入失敗", message: "請重新登入", buttonTitle: "確認")
                    print(error.localizedDescription)
                    return
                }
                
                if let additionalUserInfo = authResult?.additionalUserInfo,
                   additionalUserInfo.isNewUser {
                    
                    FirebaseManager.shared.createUserInfo(name: "新的草主", imageURL: nil, imageID: nil) { [weak self] isSuccess in
                        guard let self = self else { return }
                        
                        if isSuccess {
                            
                            let storyBoard = UIStoryboard(name: "EditProfile", bundle: nil)
                            
                            let viewController = storyBoard.instantiateViewController(
                                withIdentifier: String(describing: EditProfileViewController.self))
                            
                            guard let editProfileVC = viewController as? EditProfileViewController else { return }
                            
                            editProfileVC.modalPresentationStyle = .fullScreen
                            
                            self.present(editProfileVC, animated: true, completion: nil)
                            
                        } else {
                            
                            self.showAlert(title: "無法建立使用者", message: "請確認網路狀態並重啟APP", buttonTitle: "確認")
                        }
                    }
                    
                } else {
                    
                    FirebaseManager.shared.fetchCurrentUserInfo { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                            
                        case .success:
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        case .failure:
                            
                            self.showAlert(title: "登入失敗", message: "請重新登入", buttonTitle: "確認")
                            
                            return
                            
                        }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showAlert(title: "登入失敗", message: "請重新登入", buttonTitle: "確認")
        print("Sign in with Apple errored: \(error)")
    }
}


extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let window = self.view.window {
            return window
        } else {
            return UIWindow()
        }
    }
}
