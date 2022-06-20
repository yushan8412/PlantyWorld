//
//  PlantDetailVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/16.
//

import Foundation
import UIKit
import Kingfisher

class PlantDetailVC: UIViewController {
    
    var tableView = UITableView()
    var calenderBtn = UIButton()
    var measureBtn = UIButton()
    
    var plant: PlantsModel?
    
    override func viewDidLoad() {

        view.backgroundColor = .systemYellow
        view.addSubview(tableView)
        tableView.addSubview(calenderBtn)
        tableView.addSubview(measureBtn)
        
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
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewDidLayoutSubviews() {
        tableView.layoutIfNeeded()
    }
    
    func setup() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 0, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0)
        tableView.backgroundColor = .systemMint
        calenderBtn.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                           paddingLeft: 32, paddingBottom: 32)
        measureBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor,
                          paddingBottom: 32, paddingRight: 32)
        measureBtn.setTitle("Measure", for: .normal)
        calenderBtn.setTitle("Calendar", for: .normal)
        measureBtn.backgroundColor = .systemYellow
        calenderBtn.backgroundColor = .systemYellow
        calenderBtn.addTarget(self, action: #selector(toCalenderVC), for: .touchUpInside)
        measureBtn.addTarget(self, action: #selector(toMeasureVC), for: .touchUpInside)
        
    }
    
    @objc func toCalenderVC() {
        // 傳值到calendar
        let calendarVC = CalendarVC()
        calendarVC.plant = self.plant
                            
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func toMeasureVC() {
        let measureVC = MeasureVC()
        
        navigationController?.pushViewController(measureVC, animated: true)
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
        imageCell.image.image = UIImage(named: "山烏龜")
        sunCell.sunLB.text = "Sunny"
        waterCell.waterLB.text = "Water"
        noteCell.noteLB.text = "Note"
        noteCell.noteContent.text = plant?.note[0] ?? "Don't have any note yet"
        imageCell.image.kf.setImage(with: URL(string: plant?.image ?? ""))
        
        if indexPath.row == 0 {
            return imageCell
        } else if indexPath.row == 1 {
            return titleCell
        } else if indexPath.row == 2 {
            sunCell.isUserInteractionEnabled = false
            
//            switch plant?.sun {
//            case 1:
//                sunCell.sunLevel = .one
//            case 2:
//                sunCell.sunLevel = .two
//            case 3:
//                sunCell.sunLevel = .three
//            case 4:
//                sunCell.sunLevel = .four
//            case 5:
//                sunCell.sunLevel = .five
//            default: 0
//                
//            }
            return sunCell
        } else if indexPath.row == 3 {
            waterCell.isUserInteractionEnabled = false
            return waterCell
        } else if indexPath.row == 4 {
            return noteCell
        }
        
        return UITableViewCell()
    }
}
