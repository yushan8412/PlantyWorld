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
import Lottie

class AddPlantVC: UIViewController {
    
    var addBtn = UIButton()
    var picBackground = UIView()
    var imageArea = UIImageView()
    var addImageBtn = UIButton()
    let addPic = UIImage(systemName: "photo.on.rectangle.angled")
    var tableView = UITableView()
    let path = "image/\(UUID().uuidString).jpg"
    
    var plant: PlantsModel?
    var plantName: String = ""
    var plantDate: String = ""
    var plantNote: String = ""
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
       
        setupAddBtn()
        setupImageArea()
        setupDetilArea()
        setAddPlantBtn()
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        imageArea.image = UIImage(named: "plantBG")
        addBtn.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func lottie() {
        let animationView = loadAnimation(name: "51686-a-botanical-wreath-loading", loopMode: .loop)
        
        animationView.play()

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
        let cameraAction = UIAlertAction(title: "??????????????????", style: .default) { (_) in
            self.camera()
        }
        let libraryAction = UIAlertAction(title: "??????????????????", style: .default) { (_) in
            self.photopicker()
        }
        let cancelAction = UIAlertAction(title: "??????", style: .cancel, handler: nil)
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
        addBtn.setTitle("ADD", for: .normal)
        addBtn.setTitleColor(.black, for: .normal)
        addBtn.addTarget(self, action: #selector(tapToUpdate), for: .touchUpInside)
        addBtn.layer.cornerRadius = 10
    }
    
    func tapDismiss() {
        navigationController?.popViewController(animated: true)
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
                            PlantyWorld.FirebaseManager.shared.addPlant(
                                name: plantName, date: plantDate,
                                sun: sun, water: water, image: "\(url)", note: plantNote) { result in
                                switch result {
                                case .success:
                                    print("123")
                                    self.tapDismiss()
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
        self.lottie()
    }
    
    func setupImageArea() {
        view.addSubview(picBackground)
        picBackground.addSubview(imageArea)
        picBackground.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 100,
                             paddingLeft: 56, paddingRight: 56, height: 250)
        picBackground.backgroundColor = .lightGreen
        picBackground.layer.cornerRadius = 20
        
        imageArea.anchor(top: picBackground.topAnchor, left: picBackground.leftAnchor,
                         bottom: picBackground.bottomAnchor, right: picBackground.rightAnchor,
                         paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        imageArea.contentMode = .scaleAspectFill
        imageArea.clipsToBounds = true
    }
    
    func setupDetilArea() {
        
        tableView.anchor(top: picBackground.bottomAnchor, left: view.leftAnchor,
                         bottom: addBtn.topAnchor, right: view.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        tableView.backgroundColor = .pyellow
        
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
            print("??????????????????")
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
        
        guard let textViewCell = tableView.dequeueReusableCell(
            withIdentifier: "TextViewCell") as? TextViewCell
        else { return UITableViewCell() }
        
        sunCell.backgroundColor = .pyellow
        waterCell.backgroundColor = .pyellow
        cell.backgroundColor = .pyellow
        
        cell.textField.text = ""
        
        if indexPath.row == 0 {

            cell.titleLB.text = "Plant Name"
            cell.textField.attributedPlaceholder =
            NSAttributedString(string: "Name",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            cell.textField.textColor = .black
            cell.textField.text = self.plantName
            cell.textField.delegate = self

            return cell
            
        } else if indexPath.row == 1 {
            cell.textField.attributedPlaceholder =
            NSAttributedString(string: "yyyy.mm.dd",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            cell.titleLB.text = "Date"
            cell.textField.textColor = .black
            cell.textField.text = self.plantDate
            cell.textField.delegate = self

            return cell
            
        } else if indexPath.row == 2 {
            
            sunCell.sunLB.text = "Sun????"
            sunCell.delegate = self
            return sunCell
            
        } else if indexPath.row == 3 {
            
            waterCell.waterLB.text = "Water????"
            waterCell.delegate = self
            return waterCell
            
        } else if indexPath.row == 4 {
            
            textViewCell.title.text = "Note????"
            textViewCell.textView.text = "write some note"
            textViewCell.textView.delegate = self
            return textViewCell
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
        default:
            textField.text = "123"
        }
    }
}

extension AddPlantVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        plantNote = textView.text ?? "no note"
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
