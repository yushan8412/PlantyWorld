//
//  PlantDetailVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/16.
//

import Foundation
import UIKit

class PlantDetailVC: UIViewController {
    
    var tableView = UITableView()
    
    var plant: PlantsModel?
    
    override func viewDidLoad() {

        view.backgroundColor = .red
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(PlantDetailImageCell.self, forCellReuseIdentifier: PlantDetailImageCell.reuseidentify)
        self.tableView.register(UINib(nibName: "PlantDetailCell", bundle: nil),
                                forCellReuseIdentifier: "PlantDetailCell")
        self.tableView.register(UINib(nibName: "DetailSunCell", bundle: nil),
                                forCellReuseIdentifier: "DetailSunCell")
        self.tableView.register(UINib(nibName: "DetailWaterCell", bundle: nil),
                                forCellReuseIdentifier: "DetailWaterCell")
        setup()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func setup() {
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 0, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0)
        tableView.backgroundColor = .systemMint
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
        
        guard let sunCell = tableView.dequeueReusableCell(
            withIdentifier: "DetailSunCell") as? DetailSunCell
        else { return UITableViewCell() }
        
        guard let waterCell = tableView.dequeueReusableCell(
            withIdentifier: "DetailWaterCell") as? DetailWaterCell
        else { return UITableViewCell() }
        
        titleCell.nameLB.text = plant?.name ?? ""
        titleCell.dateLB.text = plant?.date ?? ""
        imageCell.image.image = UIImage(named: "山烏龜")
        sunCell.sunLB.text = "Sunny"
        waterCell.waterLB.text = "Water"
        
        if indexPath.row == 0 {
            return imageCell
        } else if indexPath.row == 1 {
            return titleCell
        } else if indexPath.row == 2 {
            return sunCell
        } else if indexPath.row == 3 {
            return waterCell
        }
        return UITableViewCell()
    }
    
}
