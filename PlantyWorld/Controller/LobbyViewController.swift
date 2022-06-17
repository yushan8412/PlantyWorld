//
//  ViewController.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/14.
//

import UIKit
import IQKeyboardManagerSwift

class LobbyViewController: UIViewController {

    @IBOutlet weak var plantsCollectionView: UICollectionView!
    @IBOutlet weak var addPlantBtn: UIBarButtonItem!
    @IBAction func addPlant(_ sender: Any) {
        toAddVC()
    }
    var addPlantVC = AddPlantVC()
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.plantsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantsCollectionView.delegate = self
        plantsCollectionView.dataSource = self
        
        plantsCollectionView.register(PlantsCollectionViewCell.self,
                                              forCellWithReuseIdentifier: PlantsCollectionViewCell.reuseIdentifier)
        setupItem()
        setupBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        FirebaseManager.shared.fetchData(completion: { plantList in self.plantList = plantList ?? [] })
    }
    
    func setupItem() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        plantsCollectionView.collectionViewLayout = layout
        plantsCollectionView.register(PlantsCollectionViewCell.self,
                                      forCellWithReuseIdentifier: PlantsCollectionViewCell.reuseIdentifier)
    }
    
    func setupBtn() {
        addPlantBtn.customView?.layer.borderWidth = 1
        addPlantBtn.customView?.layer.borderColor = UIColor.black.cgColor
    }
    
    func toAddVC () {
        navigationController?.pushViewController(addPlantVC, animated: true)

    }

}

// MARK: collectionView
extension LobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlantsCollectionViewCell.reuseIdentifier,
            for: indexPath) as? PlantsCollectionViewCell

        else { return UICollectionViewCell() }
        cell.title.text = plantList[indexPath.item].name
        cell.contentView.layer.cornerRadius = 10
        cell.mainPic.image = UIImage(named: "山烏龜")
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//        self.navigationController?.pushViewController(PlantDetailVC(), animated: true)
        performSegue(withIdentifier: "showDetailPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailPage" {
            if let indexPath = plantsCollectionView.indexPathsForSelectedItems?.first {
                guard let nextVC = segue.destination as? PlantDetailVC else { return }
                        nextVC.plant = plantList[indexPath.item]
            }
        }
    }
}
// MARK: FlowLayout
extension LobbyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = (collectionView.bounds.width - 32 - 15)/2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
    }
    
}
