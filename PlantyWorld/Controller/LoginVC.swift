import UIKit
import FirebaseAuth // 用來與 Firebase Auth 進行串接用的
import AuthenticationServices // Sign in with Apple 的主體框架
import CryptoKit // 用來產生隨機字串 (Nonce) 的
import FirebaseFirestore
import SwiftUI

var userUid: String = ""

protocol OpenEditVCDelegate {
    func askVCopen()
}

class LoginVC: UIViewController {
    
    var appleUserID: String?
    var bgView = UIView()
    var closeBtn = UIButton(type: .close)
    var loginLb = UILabel()
    var goEulaBtn = UIButton()
    var goPPage = UIButton()
    var delegate: OpenEditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgView)
        view.addSubview(loginLb)
        view.addSubview(goEulaBtn)
        view.addSubview(goPPage)

        self.tabBarController?.tabBar.isHidden = false
        self.setSignInWithAppleBtn()
        
        // Do any additional setup after loading the view.
            Auth.auth().addStateDidChangeListener { (_, user) in
                if user != nil {
                    guard let targetVC = self.storyboard?.instantiateViewController(
                        withIdentifier: "ProfileVC") as? ProfileVC
                    else {
                        return
                    }
                    self.navigationController?.pushViewController(targetVC, animated: true)
                } else {
                    return
                }
            }
            
        self.observeAppleIDState()
        self.checkAppleIDCredentialState(userID: appleUserID ?? "")
        setupBG()
    }
    
    func setupBG() {
        bgView.addSubview(closeBtn)
        bgView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                      right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                      paddingRight: 0, height: 350)
        bgView.backgroundColor = UIColor(patternImage: UIImage(named: "viewww")!)
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgView.layer.cornerRadius = 30
        
        closeBtn.anchor(top: bgView.topAnchor, right: bgView.rightAnchor,
                        paddingTop: 35, paddingRight: 35)
        closeBtn.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        
        loginLb.anchor(top: bgView.topAnchor, paddingTop: 100)
        loginLb.centerX(inView: bgView)
        loginLb.text = " Login to Record Your Plants? "
        loginLb.font = UIFont(name: "Marker Felt", size: 28)
        loginLb.textColor = .white
    
    }
    
    @objc func dissmiss() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 監聽目前的 Apple ID 的登入狀況
    // 主動監聽
    func checkAppleIDCredentialState(userID: String) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID) { credentialState, _ in
            switch credentialState {
            case .authorized:
                CustomFunc.customAlert(title: "使用者已授權！", message: "", vc: self, actionHandler: nil)
            case .revoked:
                CustomFunc.customAlert(title: "使用者憑證已被註銷！",
                                       message: "請到\n「設定 → Apple ID → 密碼與安全性 → 使用 Apple ID 的 App」\n將此 App 停止使用 Apple ID\n並再次使用 Apple ID 登入本 App！",
                                       vc: self, actionHandler: nil)
            case .transferred:
                CustomFunc.customAlert(title: "請與開發者團隊進行聯繫，以利進行使用者遷移！", message: "", vc: self, actionHandler: nil)
            default:
                break
            }
        }
    }
    
    // 被動監聽 (使用 Apple ID 登入或登出都會觸發)
    func observeAppleIDState() {
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
                                               object: nil, queue: nil) { (_: Notification) in
            CustomFunc.customAlert(title: "User Login or Logout", message: "", vc: self, actionHandler: nil)
        }
    }
    
    // MARK: - 在畫面上產生 Sign in with Apple 按鈕
    func setSignInWithAppleBtn() {
        
        let signInWithAppleBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                              authorizationButtonStyle: chooseAppleButtonStyle())
        view.addSubview(signInWithAppleBtn)
        signInWithAppleBtn.cornerRadius = 25
        signInWithAppleBtn.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        signInWithAppleBtn.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInWithAppleBtn.widthAnchor.constraint(equalToConstant: 280).isActive = true
        signInWithAppleBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInWithAppleBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
        
        goEulaBtn.anchor(top: signInWithAppleBtn.bottomAnchor, paddingTop: 8)
        goEulaBtn.centerX(inView: view)
        goEulaBtn.setTitle("Read EULA", for: .normal)
        goEulaBtn.titleLabel?.font = UIFont(name: "Arial", size: 14)
        goEulaBtn.addTarget(self, action: #selector(goEulaVC), for: .touchUpInside)
        
        goPPage.anchor(top: goEulaBtn.bottomAnchor, paddingTop: 0)
        goPPage.centerX(inView: view)
        goPPage.setTitle("Read Privacy Policies", for: .normal)
        goPPage.titleLabel?.font = UIFont(name: "Arial", size: 14)
        goPPage.addTarget(self, action: #selector(goWebVC), for: .touchUpInside)
    }
    
    @objc func goWebVC() {
        let nextVC = WebVC()
        present(nextVC, animated: true)
    }
    
    @objc func goEulaVC() {
        let nextVC = EulaVC()
        present(nextVC, animated: true)
    }

    func chooseAppleButtonStyle() -> ASAuthorizationAppleIDButton.Style {
        return (UITraitCollection.current.userInterfaceStyle == .light) ? .white : .white
        // 淺色模式就顯示黑色的按鈕，深色模式就顯示白色的按鈕 這裡我都想要白色
    }
    
    // MARK: - Sign in with Apple 登入
    fileprivate var currentNonce: String?
    
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

extension LoginVC {
    // MARK: - 透過 Credential 與 Firebase Auth 串接
    func firebaseSignInWithApple(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { _, error in
            guard error == nil else {
                CustomFunc.customAlert(title: "",
                                       message: "\(String(describing: error!.localizedDescription))",
                                       vc: self, actionHandler: nil)
                return
            }
            CustomFunc.customAlert(title: "Success", message: "", vc: self, actionHandler: self.getFirebaseUserInfo)
        }
    }

    // MARK: - Firebase 取得登入使用者的資訊
    func getFirebaseUserInfo() {
        let currentUser = Auth.auth().currentUser
        guard let user = currentUser else {
            CustomFunc.customAlert(title: "Can not get user data！", message: "", vc: self, actionHandler: nil)
            return
        }
       
        self.checkEmail(uid: Auth.auth().currentUser?.uid ?? "" )

        userUid = currentUser?.uid ?? ""
                        
        self.dismiss(animated: true)
        self.presentingViewController?.viewWillAppear(true)
        
    }
    
    func checkEmail(uid: String) {
        let dataBase = Firestore.firestore()
        
        // 在"user_data"collection裡，when the "email" in firebase is equal to chechEmail的參數email, than get that document.
        dataBase.collection("user").whereField("id", isEqualTo: uid).getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                if let document = querySnapshot.documents.first {
                    for data in querySnapshot.documents {
                        let userdata = data.data(with: ServerTimestampBehavior.none)
                        let userName = userdata["name"] as? String ?? ""
                        let userEmail = userdata["email"] as? String ?? ""
                        let userID = userdata["id"] as? String ?? ""
                        let userImage = userdata["image"] as? String ?? ""
                        let followList = userdata["followList"] as? [String] ?? [""]
                        let blockList = userdata["blockList"] as? [String] ?? [""]

                        _ = User(userID: userID, name: userName, userImage: userImage,
                                 useremail: userEmail, followList: followList, blockList: blockList)
                    }
                    
                    print("User already exist")
                        
                } else {
                    UserManager.shared.addUser(name: "user name",
                                               uid: Auth.auth().currentUser?.uid ?? "",
                                               email: Auth.auth().currentUser?.email ?? "",
                                               image: "") { error in
                        if error != nil {
                            print("error")
                        } else {
                            self.delegate?.askVCopen()
//                            let nextVC = EditProfileVC()
//                            print(self.navigationController)
//                            self.navigationController?.pushViewController(nextVC, animated: true)
//                            self.present(nextVC, animated: true)
                        }
                    }
                }
            }
        }
    }

}

// MARK: - ASAuthorizationControllerDelegate
// 用來處理授權登入成功或是失敗
extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        // 登入成功
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                CustomFunc.customAlert(title: "",
                                       message: "Unable to fetch identity token",
                                       vc: self, actionHandler: nil)
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                CustomFunc.customAlert(title: "",
                                       message: "Unable to serialize token string from data\n\(appleIDToken.debugDescription)",
                                       vc: self, actionHandler: nil)
                return
            }
            // 產生 Apple ID 登入的 Credential
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString, rawNonce: nonce)
            // 與 Firebase Auth 進行串接
            firebaseSignInWithApple(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 登入失敗，處理 Error
        switch error {
        case ASAuthorizationError.canceled:
            CustomFunc.customAlert(title: "Cancel Login", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.failed:
            CustomFunc.customAlert(title: "授權請求失敗", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.invalidResponse:
            CustomFunc.customAlert(title: "授權請求無回應", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.notHandled:
            CustomFunc.customAlert(title: "授權請求未處理", message: "", vc: self, actionHandler: nil)
        case ASAuthorizationError.unknown:
            CustomFunc.customAlert(title: "授權失敗，原因不知", message: "", vc: self, actionHandler: nil)
        default:
            break
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
// 在畫面上顯示授權畫面
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
