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

class AddPlantVC: UIViewController {
     
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
        setupBtn()
        setupImageArea()
        setupDetilArea()
        tabBarController?.tabBar.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true

    }
    
    func setupBtn() {
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
                                            dateOfPurchase: dateTXF.text!,
                                            sun: sunTXF.text!, water: waterTXF.text!)
            self.waterTXF.text = ""
            self.sunTXF.text = ""
            self.nameTXF.text = ""
            self.dateTXF.text = ""
        } else {
            print("Error")
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
        imageArea.image = UIImage(named: "山烏龜")
        
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
    
    func popAlert(title: String, message: String) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
        
    }
    
}
