//
//  PlantDetailVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/16.
//

import Foundation
import UIKit
import Kingfisher
import SwiftUI

class PlantDetailVC: UIViewController {
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        goEditVC()
    }
    var tableView = UITableView()
    var calenderBtn = UIButton()
    var measureBtn = UIButton()
    var deleteBtn = UIButton()
    var btnStackView = UIStackView()
    
    var plant: PlantsModel?
    var plantID = ""
    
    override func viewDidLoad() {

        view.addSubview(tableView)
        view.addSubview(btnStackView)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "32e3a86d9a8999f0632a696f3500c675")!)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(PlantDetailImageCell.self, forCellReuseIdentifier: PlantDetailImageCell.reuseidentify)
        self.tableView.register(UINib(nibName: "PlantDetailCell", bundle: nil),
                                forCellReuseIdentifier: "PlantDetailCell")
        self.tableView.register(UINib(nibName: "NoteCell", bundle: nil),
                                forCellReuseIdentifier: "NoteCell")
        self.tableView.register(UINib(nibName: "SunAndWaterCell", bundle: nil),
                                forCellReuseIdentifier: "SunAndWaterCell")
        setup()
        setupStackView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        }
        
    override func viewDidLayoutSubviews() {
        tableView.layoutIfNeeded()
    
    }
    
    func goEditVC() {
        let editVC = EditVC()
        editVC.plant = self.plant
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func setupStackView() {
        btnStackView.axis = .horizontal
        btnStackView.alignment = .center
        btnStackView.distribution = .equalSpacing
        
        btnStackView.addArrangedSubview(calenderBtn)
        btnStackView.addArrangedSubview(measureBtn)
        btnStackView.addArrangedSubview(deleteBtn)
        
    }
    
    func setup() {
        
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor,
                         bottom: btnStackView.topAnchor, right: view.rightAnchor,
                         paddingTop: 0, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0)
        tableView.backgroundColor = .clear
        
        btnStackView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                            right: view.rightAnchor, paddingLeft: 24,
                            paddingBottom: 32, paddingRight: 24)
        btnStackView.backgroundColor = .clear
        
        deleteBtn.setImage(UIImage(named: "fa6-regular_trash-can-4"), for: .normal)
        deleteBtn.tintColor = .black
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.anchor(width: 50, height: 38)
        
        calenderBtn.setImage(UIImage(named: "Vector-3"), for: .normal)
        calenderBtn.tintColor = .black
        calenderBtn.layer.cornerRadius = 5
        calenderBtn.anchor(width: 50, height: 38)

        measureBtn.anchor(width: 50, height: 38)
        measureBtn.setImage(UIImage(named: "Group-4"), for: .normal)
        measureBtn.tintColor = .black
        measureBtn.layer.cornerRadius = 5
             
        calenderBtn.addTarget(self, action: #selector(toCalenderVC), for: .touchUpInside)
        measureBtn.addTarget(self, action: #selector(toMeasureVC), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(tapToDelete), for: .touchUpInside)
        
    }
    
    @objc func toCalenderVC() {
        // 傳值到calendar
        let calendarVC = CalendarVC()
        calendarVC.plant = self.plant
                            
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func toMeasureVC() {
        let measureVC = MeasureVC()
        measureVC.plant = self.plant
        
        navigationController?.pushViewController(measureVC, animated: true)
    }
    
    @objc func tapToDelete() {
        let deleteAlert = UIAlertController(title: "Delete", message: "Are You Sure? \n All Data Will Be Lost.",
                                            preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        deleteAlert.addAction(cancelAction)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            self.deletPlant()
        }
        deleteAlert.addAction(deleteAction)
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func deletPlant() {
        FirebaseManager.shared.deleteDate(plantID: self.plant?.id ?? "" )
        navigationController?.popToRootViewController(animated: true)
    }
}

 // MARK: TableView
extension PlantDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let imageCell = tableView.dequeueReusableCell(
            withIdentifier: PlantDetailImageCell.reuseidentify,
            for: indexPath) as? PlantDetailImageCell
        else { return UITableViewCell() }
        
        guard let titleCell = tableView.dequeueReusableCell(
            withIdentifier: "PlantDetailCell") as? PlantDetailCell
        else { return UITableViewCell() }
        
        guard let noteCell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell") as? NoteCell
        else { return UITableViewCell() }
        
        guard let swCell = tableView.dequeueReusableCell(
            withIdentifier: SunAndWaterCell.reuseidentify,
            for: indexPath) as? SunAndWaterCell
        else { return UITableViewCell() }
        
        titleCell.nameLB.text = "Name : \(plant?.name ?? "")"
        titleCell.dateLB.text = "Purchase Date : \(plant?.date ?? "")"
        noteCell.noteLB.text = "Note : "
        noteCell.noteContent.text = plant?.note ?? "Don't have any note yet"
        imageCell.image.kf.setImage(with: URL(string: plant?.image ?? ""))
                
        if indexPath.row == 0 {
            
            imageCell.backgroundColor = .clear
            imageCell.isUserInteractionEnabled = false
            return imageCell
            
        } else if indexPath.row == 1 {
            
            titleCell.backgroundColor = .clear
            titleCell.isUserInteractionEnabled = false
            titleCell.bgView.backgroundColor = .pyellow
            titleCell.bgView.layer.cornerRadius = 25
            return titleCell
            
        } else if indexPath.row == 2 {
            swCell.backgroundColor = .clear
            swCell.sunLb.text = "\(plant?.sun ?? 0) / 5 "
            swCell.waterLb.text = "\(plant?.water ?? 0) / 5 "
            return swCell
                
        } else if indexPath.row == 3 {
            noteCell.backgroundColor = .clear
            noteCell.isUserInteractionEnabled = false
            noteCell.noteContent.text = plant?.note
            noteCell.bgView.backgroundColor = .pyellow
            noteCell.bgView.layer.cornerRadius = 25
            noteCell.noteLB.textColor = .black
            noteCell.noteContent.textColor = .black

            return noteCell
        }
        
        return UITableViewCell()
    }
}
