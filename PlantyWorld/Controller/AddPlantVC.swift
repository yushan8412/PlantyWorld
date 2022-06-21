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
    var plant: PlantsModel?
    var plantName: String = "name"
    var plantDate: String = "date"
    var plantNote: [String] = ["note????"]
    var water: Int = 0
    var sun: Int = 0
    var plantImage: String = "111"
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func setAddPlantBtn() {
        picBackground.addSubview(addImageBtn)
        addImageBtn.anchor(bottom: picBackground.bottomAnchor,
                           right: picBackground.rightAnchor,
                           paddingBottom: 16, paddingRight: 16)
        addImageBtn.setImage(addPic, for: .normal)
        addImageBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
    }
    
    @objc func uploadFrom() {
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
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
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
    }
    
    @objc func tapDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapToUpdate() {
        
        let imageData = self.imageArea.image!.jpegData(compressionQuality: 0.8)
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
//                            self.plant?.image = "\(url)"
                            PlantyWorld.FirebaseManager.shared.addPlant(name: plantName, date: plantDate, sun: sun, water: water, image: "\(url)", note: plantNote)
                        case .failure:
                            break
                        }
                    }
                case .failure:
                    break
                }
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
        
        tableView.anchor(top: picBackground.bottomAnchor, left: view.leftAnchor,
                         bottom: addBtn.topAnchor, right: view.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        
    }
    
}

extension AddPlantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            DispatchQueue.main.async {
                self.imageArea.image = image
            }
        } else {
            print("沒有選到相片")
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddPlantVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        
        cell.textField.text = ""
        
        if indexPath.row == 0 {

            cell.titleLB.text = "Plant Name"
            cell.textField.placeholder = "Name"
            cell.textField.delegate = self

            return cell
            
        } else if indexPath.row == 1 {

            cell.textField.placeholder = "yyyy.mm.dd"
            cell.titleLB.text = "Date"
            cell.textField.delegate = self

            return cell
            
        } else if indexPath.row == 2 {
            
            sunCell.sunLB.text = "Sun🌻"
            sunCell.delegate = self
            return sunCell
            
        } else if indexPath.row == 3 {
            
            waterCell.waterLB.text = "Water🌧"
            waterCell.delegate = self
            return waterCell
            
        } else if indexPath.row == 4 {
            cell.titleLB.text = "Note"
            cell.textField.placeholder = "Write some note"
            cell.textField.delegate = self

            return cell
        }
        return cell
    }
}

extension AddPlantVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Name":
            plantName = textField.text ?? "no value"
        case "yyyy.mm.dd":
            plantDate = textField.text ?? "no date"
        case "Write some note":
            plantNote[0] = textField.text ?? "no note"
        default:
            textField.text = "123"
        }
    }
}
extension AddPlantVC: SunLevelDelegate {
    func passSunLV(_ sunLevel: Int) {
        self.sun = sunLevel
    }
}
extension AddPlantVC: WaterLevelDelegate {
    func passWaterLV(_ waterLevel: Int) {
        self.water = waterLevel
    }
}
