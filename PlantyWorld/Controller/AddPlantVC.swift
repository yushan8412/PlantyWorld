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

class AddPlantVC: UIViewController {
    
    var addBtn = UIButton()
    var picBackground = UIView()
    var imageArea = UIImageView()
    var addImageBtn = UIButton()
    let addPic = UIImage(systemName: "photo.on.rectangle.angled")
    var tableView = UITableView()
    let path = "image/\(UUID().uuidString).jpg"
//    var plant = PlantsModel(name: String, date: String, sun: Int, water: Int, note: String)
    
    override func viewDidLoad() {

        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "DetailSunCell", bundle: nil),
                                forCellReuseIdentifier: "DetailSunCell")
        self.tableView.register(UINib(nibName: "DetailWaterCell", bundle: nil),
                                forCellReuseIdentifier: "DetailWaterCell")
        self.tableView.register(UINib(nibName: "TextFieldCell", bundle: nil),
                                forCellReuseIdentifier: "TextFieldCell")
       
        setupAddBtn()
        setupImageArea()
        setupDetilArea()
        setAddPlantBtn()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        imageArea.image = UIImage(named: "Group")
//        nameTXF.text = ""
//        dateTXF.text = ""
//        sunTXF.text = ""
//        waterTXF.text = ""
    }
    
    func setAddPlantBtn() {
        picBackground.addSubview(addImageBtn)
        addImageBtn.anchor(bottom: picBackground.bottomAnchor,
                           right: picBackground.rightAnchor,
                           paddingBottom: 16, paddingRight: 16)
        addImageBtn.setImage(addPic, for: .normal)
        addImageBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
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
        addBtn.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)

    }
    
    @objc func tapDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapToUpdate() {
//        FirebaseManager.shared.addPlant(name: water, date: <#T##String#>, sun: <#T##String#>, water: <#T##String#>, image: <#T##String#>)
//        if nameTXF.text != "" && dateTXF.text != "" && sunTXF.text != "" && waterLB.text != "" {
//            FirebaseManager.shared.addPlant(name: nameTXF.text!,
//                                            date: dateTXF.text!,
//                                            sun: sunTXF.text!, water: waterTXF.text!, image: "url")
//            self.waterTXF.text = ""
//            self.sunTXF.text = ""
//            self.nameTXF.text = ""
//            self.dateTXF.text = ""
//
//        } else {
//            print("Error")
//        }
        
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
        
        tableView.anchor(top: picBackground.bottomAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
    }
    
    @objc func uploadPhoto() {
        guard imageArea != nil else {
            return
        }
        // create Storage ref
        let storageRef = Storage.storage().reference()

        // turn image into data
        let imageData = imageArea.image!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return }

        // specify the file path and name
//        let path = "image/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)

        // upload data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
            }
        }
        //save ref to firestore database
        let db = Firestore.firestore()
        db.collection("image").document().setData(["url": path])
        
    }
    
}

extension AddPlantVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage] as? UIImage
        imageArea.image = image
        
        let uniString = NSUUID().uuidString
        if let selectedImage = image {
            print("123123\(uniString), \(image)")
        }
        dismiss(animated: true, completion: nil)
    }

}

extension AddPlantVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "TextFieldCell") as? TextFieldCell
        else { return UITableViewCell() }
        
        guard let sunCell = tableView.dequeueReusableCell(
            withIdentifier: "DetailSunCell") as? DetailSunCell
        else { return UITableViewCell() }
        
        guard let waterCell = tableView.dequeueReusableCell(
            withIdentifier: "DetailWaterCell") as? DetailWaterCell
        else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            return cell
        } else if indexPath.row == 1 {
            return cell
        } else if indexPath.row == 2 {
            return sunCell
        } else if indexPath.row == 3 {
            return waterCell
        }
        return cell
    }
}
