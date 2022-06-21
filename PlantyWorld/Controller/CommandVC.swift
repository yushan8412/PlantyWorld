//
//  CommandVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import Foundation
import UIKit
import Kingfisher

class CommandVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var plant: PlantsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            self.tableView.register(UINib(nibName: "CommandCell", bundle: nil),
                                    forCellReuseIdentifier: "CommandCell")
            
            FirebaseManager.shared.fetchData(completion: { plantList in self.plantList = plantList ?? [] })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()

    }

}

// MARK: TableView
extension CommandVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommandCell") as? CommandCell
        else { return UITableViewCell() }
        
        cell.titleLB.text = plantList[indexPath.row].name
        cell.commandLB.text = plantList[indexPath.row].date
        cell.mainImage.kf.setImage(with: URL(string: plantList[indexPath.row].image))
        self.plant = plantList[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}

extension CommandVC: AddCommandBtnDelegate {
    func didTapped(sender: UIButton) {

        let addCommandVC = AddCommandVC()
        addCommandVC.plant = plant
        addCommandVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(addCommandVC, animated: true, completion: nil)
    }
    
}

extension CommandVC: BackBtnDelegate {
    func tappedToDissmis() {
        dismiss(animated: true)
    }
}
