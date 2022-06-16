//
//  AddPlantViewController.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class AddPlantVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var addBtn = UIButton()
    var picBackground = UIView()
    var imageArea = UIImageView()
    var nameLB = UILabel()
    var nameTXF = UITextField()
    var dateLB = UILabel()
    var dateTXF = UITextField()
    var sunLB = UILabel()
    var sunTXF = UITextField()
    var waterLB = UILabel()
    var waterTXF = UITextField()
    var addImageBtn = UIButton()
    let addPic = UIImage(systemName: "photo.on.rectangle.angled")
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(nameLB)
        view.addSubview(nameTXF)
        view.addSubview(dateLB)
        view.addSubview(dateTXF)
        view.addSubview(sunLB)
        view.addSubview(sunTXF)
        view.addSubview(waterLB)
        view.addSubview(waterTXF)
        setupAddBtn()
        setupImageArea()
        setupDetilArea()
        setAddPlantBtn()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        imageArea.image = UIImage(named: "Group")
        nameTXF.text = ""
        dateTXF.text = ""
        sunTXF.text = ""
        waterTXF.text = ""
    }
    
    func setAddPlantBtn() {
        picBackground.addSubview(addImageBtn)
        addImageBtn.anchor(bottom: picBackground.bottomAnchor,
                           right: picBackground.rightAnchor,
                           paddingBottom: 16, paddingRight: 16)
        addImageBtn.setImage(addPic, for: .normal)
        addImageBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
//        addImageBtn.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
    }
    
    @objc func uploadFrom() -> UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { (_) in
            self.camera()
        }
        let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (_) in
            self.photopicker()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
        return UIAlertController()
    }
    
    func camera() {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
    }
    func photopicker() {
        let photoController = UIImagePickerController()
        photoController.delegate = self
        photoController.sourceType = .photoLibrary
        present(photoController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        imageArea.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func setupAddBtn() {
        view.addSubview(addBtn)
        addBtn.anchor(left: view.leftAnchor,
                      bottom: view.bottomAnchor,
                      right: view.rightAnchor,
                      paddingLeft: 24, paddingBottom: 32, paddingRight: 24)
        addBtn.backgroundColor = .systemPink
        addBtn.setTitle("ADD", for: .normal)
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(tapToUpdate), for: .touchUpInside)
    }
    
    @objc func tapDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapToUpdate() {
        if nameTXF.text != "" && dateTXF.text != "" && sunTXF.text != "" && waterLB.text != "" {
            FirebaseManager.shared.addPlant(name: nameTXF.text!,
                                            date: dateTXF.text!,
                                            sun: sunTXF.text!, water: waterTXF.text!)
            self.waterTXF.text = ""
            self.sunTXF.text = ""
            self.nameTXF.text = ""
            self.dateTXF.text = ""
        } else {
            print("Error")
        }
        
        guard imageArea != nil else { print("=======imageares is nil")
            return
        }
        
        // create Storage ref
        let storageRef = Storage.storage().reference()
        
        // turn image into data
        let imageData = imageArea.image!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return }
        
        //specify the file path and name
        let fileRef = storageRef.child("image/\(UUID().uuidString).jpg")
        
        //upload data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            print("=======\(error)")
            if error == nil && metadata != nil {
            }
        }
        
        
    }
    
    func setupImageArea() {
        view.addSubview(picBackground)
        picBackground.addSubview(imageArea)
        picBackground.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 100,
                             paddingLeft: 64, paddingRight: 64, height: 300)
        picBackground.backgroundColor = .systemMint
        
        imageArea.anchor(top: picBackground.topAnchor, left: picBackground.leftAnchor,
                         right: picBackground.rightAnchor, paddingTop: 24,
                         paddingLeft: 24, paddingRight: 24, height: 250)
        imageArea.contentMode = .scaleToFill
    }
    
    func setupDetilArea() {
        nameLB.anchor(top: picBackground.bottomAnchor, left: view.leftAnchor,
                      paddingTop: 30, paddingLeft: 64)
        nameLB.text = "Name"
        nameTXF.anchor(top: nameLB.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 10,
                       paddingLeft: 64, paddingRight: 64)
        nameTXF.layer.borderWidth = 1
        nameTXF.layer.borderColor = UIColor.gray.cgColor
        nameTXF.font = .systemFont(ofSize: 24)
        
        dateLB.anchor(top: nameTXF.bottomAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, paddingTop: 16,
                      paddingLeft: 64, paddingRight: 64)
        dateLB.text = "Date"
        dateTXF.anchor(top: dateLB.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 10,
                       paddingLeft: 64, paddingRight: 64)
        dateTXF.layer.borderWidth = 1
        dateTXF.layer.borderColor = UIColor.gray.cgColor
        dateTXF.font = .systemFont(ofSize: 24)
        
        sunLB.anchor(top: dateTXF.bottomAnchor, left: view.leftAnchor,
                     paddingTop: 16, paddingLeft: 64)
        sunLB.text = "Sunlight"
        sunTXF.anchor(top: sunLB.bottomAnchor, left: view.leftAnchor,
                      right: view.rightAnchor, paddingTop: 10,
                      paddingLeft: 64, paddingRight: 64)
        sunTXF.layer.borderWidth = 1
        sunTXF.layer.borderColor = UIColor.gray.cgColor
        sunTXF.font = .systemFont(ofSize: 24)
        
        waterLB.anchor(top: sunTXF.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 16,
                       paddingLeft: 64, paddingRight: 64)
        waterLB.text = "Water"
        waterTXF.anchor(top: waterLB.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingTop: 10,
                        paddingLeft: 64, paddingRight: 64)
        waterTXF.layer.borderWidth = 1
        waterTXF.layer.borderColor = UIColor.gray.cgColor
        waterTXF.font = .systemFont(ofSize: 24)
        
    }
    
//    @objc func uploadPhoto() {
//        guard imageArea != nil else { print("=======imageares is nil")
//            return
//        }
//
//
//        // create Storage ref
//        let storageRef = Storage.storage().reference()
//
//        // turn image into data
//        let imageData = imageArea.image!.jpegData(compressionQuality: 0.8)
//        guard imageData != nil else { return }
//
//        //specify the file path and name
//        let fileRef = storageRef.child("image/\(UUID().uuidString).jpg")
//
//        //upload data
//        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
//            if error == nil && metadata != nil {
//                print("=======\(error)")
//            }
//        }
//
//        //save ref to firestore database
//    }
    
}
