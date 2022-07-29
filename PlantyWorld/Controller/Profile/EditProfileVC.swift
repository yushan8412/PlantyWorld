//
//  EditProfileVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/29.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class EditProfileVC: UIViewController {
    
    var userImage = UIImageView()
    var nameLB = UILabel()
    var emailLB = UILabel()
    var email = UILabel()
    var userTF = UITextField()
    var addPicBtn = UIButton()
    var comfirmBtn = UIButton()
    let addPic = UIImage(named: "add-photo")
    let cameraPic = UIImage(systemName: "camera.on.rectangle.fill")
    var userData: User?

    override func viewDidLoad() {
        view.layoutIfNeeded()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg4")!)
        addView()
        setBtnUp()
        userTF.layer.cornerRadius = 10
        email.layer.cornerRadius = 10
        userImage.image = UIImage(named: "About us")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
        showPic()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        
    }
    
    private func addView() {
        view.addSubview(userImage)
        view.addSubview(nameLB)
        view.addSubview(userTF)
        view.addSubview(comfirmBtn)
        view.addSubview(addPicBtn)
        view.addSubview(emailLB)
        view.addSubview(email)
    }
    
    private func setup() {
        userImage.centerX(inView: view)
        userImage.anchor(top: view.topAnchor, paddingTop: 170, width: 250, height: 250)
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 30
        userImage.image = UIImage(named: "About us")
        
        nameLB.anchor(top: userImage.bottomAnchor, paddingTop: 16)
        nameLB.centerX(inView: view)
        nameLB.textColor = .black
        nameLB.text = " Your Name "
        nameLB.font = UIFont(name: "Chalkboard SE", size: 24)
        
        userTF.anchor(top: nameLB.bottomAnchor, paddingTop: 16, width: 200, height: 40)
        userTF.centerX(inView: view)
        userTF.backgroundColor = .white
        userTF.textColor = .black
        userTF.text = "\(userData?.name ?? "")"
        userTF.placeholder = "Name"
        userTF.layer.borderWidth = 0.5
        userTF.setLeftPaddingPoints(8)

        emailLB.anchor(top: userTF.bottomAnchor, paddingTop: 16)
        emailLB.centerX(inView: view)
        emailLB.text = "Email"
        emailLB.textColor = .black
        emailLB.font = UIFont(name: "Chalkboard SE", size: 24)

        email.anchor(top: emailLB.bottomAnchor, paddingTop: 16, width: 300, height: 40)
        email.centerX(inView: view)
        email.text = Auth.auth().currentUser?.email
        email.textColor = .darkGray
        email.backgroundColor = .white
        email.layer.borderWidth = 0.5
        
    }
    
    private func setBtnUp() {
        comfirmBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 32, height: 40)
        comfirmBtn.centerX(inView: view)
        comfirmBtn.setTitle(" Comfirm ", for: .normal)
        comfirmBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 26)
        comfirmBtn.backgroundColor = .dPeach
        comfirmBtn.layer.cornerRadius = 10
        
        addPicBtn.anchor(bottom: userImage.bottomAnchor, right:
                            userImage.rightAnchor, paddingBottom: 8, paddingRight: 8, width: 30, height: 30)
        addPicBtn.setImage(cameraPic, for: .normal)
        addPicBtn.tintColor = .black
        addPicBtn.backgroundColor = .lightGray
        addPicBtn.layer.cornerRadius = 15
        
        addPicBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
        comfirmBtn.addTarget(self, action: #selector(tapToUpdate), for: .touchUpInside)
    }
    
    private func lottie() {
        let animationView = loadAnimation(name: "51686-a-botanical-wreath-loading", loopMode: .loop)
        animationView.play()

    }
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func uploadFrom() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.camera()
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.photopicker()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    private func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    private func photopicker() {
        let photoController = UIImagePickerController()
        photoController.delegate = self
        photoController.sourceType = .photoLibrary
        present(photoController, animated: true, completion: nil)
    }
    
    private func showPic() {
        if userData?.userImage != "" {
            self.userImage.kf.setImage(with: URL(string: userData?.userImage ?? ""))
        } else {
            self.userImage.image = UIImage(named: "About us")
        }
    }
    
    @objc private func tapToUpdate() {
        
        let imageData = self.userImage.image!.jpegData(compressionQuality: 0.3)
        guard imageData != nil else {
            return
        }
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data  = imageData {
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success:
                    fileReference.downloadURL { [self] result in
                        switch result {
                        case .success(let url):
                            UserManager.shared.updateUserInfo(uid: Auth.auth().currentUser?.uid ?? "", image: "\(url)", name: userTF.text ?? "empty name") { result in
                                switch result {
                                case .success:
                                    self.dismissVC()
                                    navigationController?.viewWillAppear(true)
                                    print("update user info")
                                case .failure:
                                    print("ERRRRRROR")
                                }
                            }
                        case .failure:
                            break
                        }
                    }
                case .failure:
                    break
                }
            }
            
        }
        self.comfirmBtn.isEnabled = false
        self.lottie()
        PlantDetailVC().viewWillAppear(true)
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            DispatchQueue.main.async {
                self.userImage.image = image
            }
        } else {
            print("No Image")
        }
        dismiss(animated: true, completion: nil)
    }
    
}
