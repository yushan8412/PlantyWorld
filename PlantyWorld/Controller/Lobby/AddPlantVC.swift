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
    
    var addPlantBtn = UIButton()
    var picBackground = UIView()
    var plantImage = UIImageView()
    var addImageBtn = UIButton()
    let cameraBtnPic = UIImage(systemName: "camera.on.rectangle.fill")
    var tableView = UITableView()
    var lottieAnimation = "51686-a-botanical-wreath-loading"
    
    var plantName: String = ""
    var plantDate: String = ""
    var plantNote: String = ""
    var water: Int = 0
    var sun: Int = 0
    var backgroundImage = "addplantsbg"
    var plant = PlantsModel()
    
    override func viewDidLoad() {

        view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImage) ?? UIImage())
        addSubView()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
       
        setupAddBtn()
        setupImageArea()
        setupTableView()
        setAddPlantBtn()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        plantImage.image = UIImage(named: "plantBG")
        addPlantBtn.isEnabled = true
    }
    
    func registerCell() {
        self.tableView.register(UINib(nibName: "DetailSunCell", bundle: nil),
                                forCellReuseIdentifier: "DetailSunCell")
        self.tableView.register(UINib(nibName: "DetailWaterCell", bundle: nil),
                                forCellReuseIdentifier: "DetailWaterCell")
        self.tableView.register(UINib(nibName: "TextFieldCell", bundle: nil),
                                forCellReuseIdentifier: "TextFieldCell")
        self.tableView.register(UINib(nibName: "TextViewCell", bundle: nil),
                                forCellReuseIdentifier: "TextViewCell")
    }
    
    func addSubView() {
        view.addSubview(tableView)
        view.addSubview(addPlantBtn)
        view.addSubview(picBackground)
        view.addSubview(plantImage)
        view.addSubview(addImageBtn)
    }
    
    func setLottie() {
        let animationView = loadAnimation(name: lottieAnimation, loopMode: .loop)
        animationView.play()
    }
    
    func setAddPlantBtn() {
        addImageBtn.anchor(bottom: picBackground.bottomAnchor,
                           right: picBackground.rightAnchor,
                           paddingBottom: 8, paddingRight: 8, width: 30, height: 30)
        addImageBtn.setImage(cameraBtnPic, for: .normal)
        addImageBtn.backgroundColor = .lightGray
        addImageBtn.layer.cornerRadius = 15
        addImageBtn.tintColor = .black
        addImageBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
    }
    
    @objc func uploadFrom() {
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
        addPlantBtn.anchor(left: view.leftAnchor,
                      bottom: view.bottomAnchor,
                      right: view.rightAnchor,
                      paddingLeft: 24, paddingBottom: 32, paddingRight: 24, height: 45)
        addPlantBtn.backgroundColor = .dPeach
        addPlantBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        addPlantBtn.setTitle("ADD NEW PLANT", for: .normal)
        addPlantBtn.setTitleColor(.black, for: .normal)
        addPlantBtn.addTarget(self, action: #selector(uploadNewPlant), for: .touchUpInside)
        addPlantBtn.layer.cornerRadius = 10
    }
    
    func dismissVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func uploadNewPlant() {
        FirebaseManager.shared.tryUploadPhoto(plant: plant, image: plantImage.image ?? UIImage()) { result in
            switch result {
            case .success:
                self.dismissVC()
            case .failure:
                print("error")
            }
        }
        self.addPlantBtn.isEnabled = false
        self.setLottie()
    }
    
    func setupImageArea() {
        picBackground.anchor(top: view.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 100,
                             paddingLeft: 56, paddingRight: 56, height: 250)
        picBackground.backgroundColor = .lightGreen
        picBackground.alpha = 0.7
        picBackground.layer.cornerRadius = 20
        
        plantImage.anchor(top: picBackground.topAnchor, left: picBackground.leftAnchor,
                         bottom: picBackground.bottomAnchor, right: picBackground.rightAnchor,
                         paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        plantImage.contentMode = .scaleAspectFill
        plantImage.clipsToBounds = true
        plantImage.alpha = 1
    }
    
    func setupTableView() {
        tableView.anchor(top: picBackground.bottomAnchor, left: view.leftAnchor,
                         bottom: addPlantBtn.topAnchor, right: view.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        tableView.backgroundColor = .clear
    }
    
}

extension AddPlantVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            DispatchQueue.main.async {
                self.plantImage.image = image
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
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "TextFieldCell") as? TextFieldCell
            else { return UITableViewCell() }
            cell.titleLB.text = "Plant Name"
            cell.textField.attributedPlaceholder =
            NSAttributedString(string: "Name",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            cell.textField.text = self.plantName
            cell.textField.delegate = self
            return cell

        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "TextFieldCell") as? TextFieldCell
            else { return UITableViewCell() }
            cell.textField.attributedPlaceholder =
            NSAttributedString(string: "yyyy.mm.dd",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            cell.titleLB.text = "Date"
            cell.textField.text = self.plantDate
            cell.textField.delegate = self
            return cell
            
        case 2:
            guard let sunCell = tableView.dequeueReusableCell(
                withIdentifier: "DetailSunCell") as? DetailSunCell
            else { return UITableViewCell() }
            sunCell.delegate = self
            return sunCell
            
        case 3:
            guard let waterCell = tableView.dequeueReusableCell(
                withIdentifier: "DetailWaterCell") as? DetailWaterCell
            else { return UITableViewCell() }
            waterCell.delegate = self
            return waterCell
            
        case 4:
            guard let textViewCell = tableView.dequeueReusableCell(
                withIdentifier: "TextViewCell") as? TextViewCell
            else { return UITableViewCell() }
            textViewCell.textView.text = "write some note"
            textViewCell.textView.delegate = self
            return textViewCell
    
        default:
            return UITableViewCell()
        }
    }
}

extension AddPlantVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.placeholder {
        case "Name":
            plantName = textField.text ?? "no value"
            self.plant.name = textField.text ?? "QQ"
        case "yyyy.mm.dd":
            plantDate = textField.text ?? "no date"
            self.plant.date = textField.text ?? "QQ"
        default:
            textField.text = "123"
        }
    }
}

extension AddPlantVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        plantNote = textView.text ?? "no note"
        self.plant.note = textView.text
    }
}
extension AddPlantVC: SunLevelDelegate {
    func passSunLevel(_ sunLevel: Int) {
        self.sun = sunLevel
        self.plant.sun = sunLevel
    }
}
extension AddPlantVC: WaterLevelDelegate {
    func passWaterLevel(_ waterLevel: Int) {
        self.water = waterLevel
        self.plant.water = waterLevel
    }
}
