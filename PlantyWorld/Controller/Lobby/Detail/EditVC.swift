//
//  EditVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/2.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Kingfisher
import Lottie

class EditVC: UIViewController {
    
    var detailVC = PlantDetailVC()
    var plant: PlantsModel?
    var addBtn = UIButton()
    var picBackground = UIView()
    var imageArea = UIImageView()
    var addImageBtn = UIButton()
    let addPic = UIImage(systemName: "photo.on.rectangle.angled")
    var tableView = UITableView()
    let path = "image/\(UUID().uuidString).jpg"
    
    var plantName: String = "name"
    var plantDate: String = "date"
    var plantNote: String = "note????"
    var water: Int = 0
    var sun: Int = 0
    var plantImage: String = "111"
    
    override func viewDidLoad() {
        view.backgroundColor = .pyellow
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "DetailSunCell", bundle: nil),
                                forCellReuseIdentifier: "DetailSunCell")
        self.tableView.register(UINib(nibName: "DetailWaterCell", bundle: nil),
                                forCellReuseIdentifier: "DetailWaterCell")
        self.tableView.register(UINib(nibName: "TextFieldCell", bundle: nil),
                                forCellReuseIdentifier: "TextFieldCell")
        self.tableView.register(UINib(nibName: "TextViewCell", bundle: nil),
                                forCellReuseIdentifier: "TextViewCell")
        self.tableView.register(UINib(nibName: "PlantDetailCell", bundle: nil),
                                forCellReuseIdentifier: "PlantDetailCell")
       
        setupAddBtn()
        setupImageArea()
        setupDetilArea()
        setAddPlantBtn()
        tabBarController?.tabBar.isHidden = true
//        print(plant)
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
//        imageArea.kf.setImage(with: URL(string: plant?.image ?? ""))
        addBtn.isEnabled = true
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
        addImageBtn.tintColor = .pgreen
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
        addBtn.backgroundColor = .dPeach
        addBtn.setTitle("UPDATE", for: .normal)
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.addTarget(self, action: #selector(tapToUpdate), for: .touchUpInside)
        addBtn.layer.cornerRadius = 10
    }
    
    func tapDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func toLobbyVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          guard let loginVC = mainStoryboard.instantiateViewController(
            withIdentifier: "LobbyViewController") as? LobbyViewController else { return }
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func tapToUpdate() {
        
        let imageData = self.imageArea.image!.jpegData(compressionQuality: 0.5)
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
                            PlantyWorld.FirebaseManager.shared.updatePlantInfo(plantID:
                                                                                plant?.id ?? "", image: "\(url)", name: plantName,
                                                                               water: water, sun: sun, note: plantNote) { result in
                                switch result {
                                case .success:
                                    print("123")
                                    self.toLobbyVC()
                                case .failure:
                                    print("error")
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
        self.addBtn.isEnabled = false
        detailVC.viewWillAppear(true)
        self.lottie()
        
    }
    
    func setupImageArea() {
        view.addSubview(picBackground)
        picBackground.addSubview(imageArea)
        picBackground.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 100,
                             paddingLeft: 64, paddingRight: 64, height: 300)
        picBackground.backgroundColor = .lightGreen
        picBackground.layer.cornerRadius = 20
        
        imageArea.anchor(top: picBackground.topAnchor, left: picBackground.leftAnchor,
                         right: picBackground.rightAnchor, paddingTop: 24,
                         paddingLeft: 24, paddingRight: 24, height: 250)
        imageArea.contentMode = .scaleAspectFill
        imageArea.clipsToBounds = true
        imageArea.kf.setImage(with: URL(string: plant?.image ?? ""))
    }
    
    func lottie() {
        let animationView = loadAnimation(name: "51686-a-botanical-wreath-loading", loopMode: .loop)
        
        animationView.play()

    }

    func setupDetilArea() {
        
        tableView.anchor(top: picBackground.bottomAnchor, left: view.leftAnchor,
                         bottom: addBtn.topAnchor, right: view.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        tableView.backgroundColor = .pyellow
        
    }
    
}
extension EditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension EditVC: UITableViewDelegate, UITableViewDataSource {
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
        
        guard let textViewCell = tableView.dequeueReusableCell(
            withIdentifier: "TextViewCell") as? TextViewCell
        else { return UITableViewCell() }
        
        guard let detailCell = tableView.dequeueReusableCell(
            withIdentifier: "PlantDetailCell") as? PlantDetailCell
        else { return UITableViewCell() }
        
        sunCell.backgroundColor = .pyellow
        waterCell.backgroundColor = .pyellow
        cell.backgroundColor = .pyellow
        
        cell.textField.text = ""
        
        if indexPath.row == 0 {

            detailCell.bgView.backgroundColor = .lightPeach
            detailCell.bgView.layer.cornerRadius = 20
            detailCell.backgroundColor = .pyellow
            detailCell.nameLB.textAlignment = .center
            detailCell.dateLB.textAlignment = .center
            detailCell.nameLB.text = "Name: \(plant?.name ?? "")"
            detailCell.dateLB.text = "Purchase Date: \(plant?.date ?? "")"
            
            return detailCell
            
        } else if indexPath.row == 1 {
            
            sunCell.sunLB.text = "Sun🌻"
            sunCell.sunColor(sunLevel: plant?.sun ?? 0)
            self.sun = plant?.sun ?? 0
            sunCell.delegate = self
            return sunCell
            
        } else if indexPath.row == 2 {
            
            waterCell.waterLB.text = "Water🌧"
            waterCell.waterColor(waterLevel: plant?.water ?? 0)
            self.water = plant?.water ?? 0
            waterCell.delegate = self
            return waterCell
            
        } else if indexPath.row == 3 {
            
            textViewCell.title.text = "Note📝"
            textViewCell.textView.text = plant?.note
            self.plantNote = plant?.note ?? "something wrong"
            textViewCell.textView.delegate = self
            return textViewCell
        }
        return cell
    }
}

//extension EditVC: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        switch textField.placeholder {
//        case "\(plant?.name ?? "")":
//            plantName = textField.text ?? "no value"
//        case "\(plant?.date ?? "")":
//            plantDate = textField.text ?? "no date"
//        default:
//            textField.text = "123"
//        }
//    }
//}

extension EditVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        plantNote = textView.text ?? "no note"
    }
}
extension EditVC: SunLevelDelegate {
    func passSunLV(_ sunLevel: Int) {
        self.sun = sunLevel
    }
}
extension EditVC: WaterLevelDelegate {
    func passWaterLV(_ waterLevel: Int) {
        self.water = waterLevel
    }
}
