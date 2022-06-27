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
    
    var tableView = UITableView()
    var calenderBtn = UIButton()
    var measureBtn = UIButton()
    var deleteBtn = UIButton()
    var btnStackView = UIStackView()
    
    var plant: PlantsModel?
    
    override func viewDidLoad() {

        view.addSubview(tableView)
        view.addSubview(btnStackView)
        view.backgroundColor = .lightYellow
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(PlantDetailImageCell.self, forCellReuseIdentifier: PlantDetailImageCell.reuseidentify)
        self.tableView.register(UINib(nibName: "PlantDetailCell", bundle: nil),
                                forCellReuseIdentifier: "PlantDetailCell")
        self.tableView.register(UINib(nibName: "DetailSunCell", bundle: nil),
                                forCellReuseIdentifier: "DetailSunCell")
        self.tableView.register(UINib(nibName: "DetailWaterCell", bundle: nil),
                                forCellReuseIdentifier: "DetailWaterCell")
        self.tableView.register(UINib(nibName: "NoteCell", bundle: nil),
                                forCellReuseIdentifier: "NoteCell")
        setup()
        setupStackView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewDidLayoutSubviews() {
        tableView.layoutIfNeeded()
    
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
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: btnStackView.topAnchor, right: view.rightAnchor,
                         paddingTop: 0, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0)
        tableView.backgroundColor = .lightYellow
        
        btnStackView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                            right: view.rightAnchor, paddingLeft: 24,
                            paddingBottom: 32, paddingRight: 24)
        btnStackView.backgroundColor = .lightYellow
        
        deleteBtn.setImage(UIImage(named: "fa6-regular_trash-can-3"), for: .normal)
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.anchor(width: 50, height: 38)
        
        calenderBtn.setImage(UIImage(named: "Vector-3"), for: .normal)
        calenderBtn.layer.cornerRadius = 5
        calenderBtn.anchor(width: 50, height: 38)

        measureBtn.anchor(width: 50, height: 38)
        measureBtn.setImage(UIImage(named: "Group-3"), for: .normal)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let imageCell = tableView.dequeueReusableCell(
            withIdentifier: PlantDetailImageCell.reuseidentify,
            for: indexPath) as? PlantDetailImageCell
        else { return UITableViewCell() }
        
        guard let titleCell = tableView.dequeueReusableCell(
            withIdentifier: "PlantDetailCell") as? PlantDetailCell
        else { return UITableViewCell() }
        
        guard let sunCell = tableView.dequeueReusableCell(
            withIdentifier: "DetailSunCell") as? DetailSunCell
        else { return UITableViewCell() }
        
        guard let waterCell = tableView.dequeueReusableCell(
            withIdentifier: "DetailWaterCell") as? DetailWaterCell
        else { return UITableViewCell() }
        
        guard let noteCell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell") as? NoteCell
        else { return UITableViewCell() }
        
        titleCell.nameLB.text = plant?.name ?? ""
        titleCell.dateLB.text = plant?.date ?? ""
        sunCell.sunLB.text = "Sun🌼"
        waterCell.waterLB.text = "Water🌧"
        noteCell.noteLB.text = "Note"
        noteCell.noteContent.text = plant?.note[0] ?? "Don't have any note yet"
        imageCell.image.kf.setImage(with: URL(string: plant?.image ?? ""))
                
        if indexPath.row == 0 {
            
            imageCell.backgroundColor = .lightYellow
            imageCell.isUserInteractionEnabled = false
            return imageCell
            
        } else if indexPath.row == 1 {
            
            titleCell.backgroundColor = .lightYellow
            titleCell.isUserInteractionEnabled = false
            return titleCell
            
        } else if indexPath.row == 2 {
            sunCell.backgroundColor = .lightYellow
            sunCell.isUserInteractionEnabled = false
            sunCell.sunColor(sunLevel: plant?.sun ?? 0)
            return sunCell
            
        } else if indexPath.row == 3 {
            
            waterCell.backgroundColor = .lightYellow
            waterCell.isUserInteractionEnabled = false
            waterCell.waterColor(waterLevel: plant?.water ?? 0)
            return waterCell
                
        } else if indexPath.row == 4 {
            noteCell.backgroundColor = .lightYellow
            return noteCell
        }
        
        return UITableViewCell()
    }
}
