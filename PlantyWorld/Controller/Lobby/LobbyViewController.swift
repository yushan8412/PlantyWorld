//
//  ViewController.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/14.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import FirebaseAuth
import CHTCollectionViewWaterfallLayout

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
        view.backgroundColor = UIColor(patternImage: UIImage(named: "32e3a86d9a8999f0632a696f3500c675")!)
                
        plantsCollectionView.backgroundColor = .clear
        plantsCollectionView.delegate = self
        plantsCollectionView.dataSource = self
        
        plantsCollectionView.register(PlantsCollectionViewCell.self,
                                              forCellWithReuseIdentifier: PlantsCollectionViewCell.reuseIdentifier)
        setupItem()
        setupBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.plantList.removeAll()
//        FirebaseManager.shared.fetchUserPlantsData(uid: "SvPOVniW2hVeiT1kbmXXZGx45Fr2", completion: { plantList in self.plantList = plantList ?? [] })
        // MARK: 正式模式
        FirebaseManager.shared.fetchUserPlantsData(
            uid: Auth.auth().currentUser?.uid ?? "",
            completion: { plantList in self.plantList = plantList
                print(plantList)
            })
        
        self.plantsCollectionView.reloadData()
        print(plantList.count)
        
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
            self.plantsCollectionView.numberOfItems(inSection: 0)
        } else {
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupItem() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        
//        let flowLayout = UICollectionViewFlowLayout()
        
//        let cellWidth = (view.frame.width / 2 - 15)
//
//        let cellHeight = cellWidth * 1.3
//        flowLayout.itemSize = CGSize(width: cellWidth, height: CGFloat.random(in: 150...250))
//        flowLayout.estimatedItemSize = .zero
//        flowLayout.minimumInteritemSpacing = 1
//        flowLayout.scrollDirection = .vertical
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//        plantsCollectionView.collectionViewLayout = flowLayout
        
        
        layout.scrollDirection = .vertical
        plantsCollectionView.collectionViewLayout = layout
        
//        let layout = CHTCollectionViewWaterfallLayout()
//        layout.itemRenderDirection = .leftToRight
//        layout.columnCount = 2
        plantsCollectionView.register(PlantsCollectionViewCell.self,
                                      forCellWithReuseIdentifier: PlantsCollectionViewCell.reuseIdentifier)
    }
    
    func setupBtn() {
        addPlantBtn.customView?.layer.borderWidth = 1
        addPlantBtn.customView?.layer.borderColor = UIColor.black.cgColor
    }
    
    func toAddVC () {
        navigationController?.pushViewController(AddPlantVC(), animated: true)
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
        cell.mainPic.kf.setImage(with: URL(string: plantList[indexPath.row].image))
        cell.waterDrop.isHidden = true
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailPage" {
            if let indexPath = plantsCollectionView.indexPathsForSelectedItems?.first {
                guard let nextVC = segue.destination as? PlantDetailVC else { return }
                        nextVC.plant = plantList[indexPath.item]
//                nextVC.plantID = plantList[indexPath.item].id
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
        let cellHeight = cellWidth * 1.3
//        if indexPath.item.isMultiple(of: 2) {
//            return CGSize(width: cellWidth, height: cellHeight)
//        } else {
//            return CGSize(width: cellWidth, height: 150)
//        }
        return CGSize(width: cellWidth, height: cellHeight)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)

    }

//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let cellWidth = (collectionView.bounds.width - 32 - 15)/2
//        let cellHeight = cellWidth * 1.3
//        if indexPath.item % 3 == 1 {
//            return CGSize(width: cellWidth, height: cellHeight)
//        } else if indexPath.item % 3 == 2 {
//            return CGSize(width: cellWidth, height: cellHeight)
//        } else {
//            return CGSize(width: cellWidth, height: 150)
//        }
//         if indexPath.item.isMultiple(of: 2) {
//             return CGSize(width: cellWidth, height: cellHeight)
//         } else {
//             return CGSize(width: cellWidth, height: 200)
//         }
//     }
}
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
////        UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
//
//    }
//
//}


//extension LobbyViewController: CHTCollectionViewDelegateWaterfallLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let cellWidth = (collectionView.bounds.width - 32 - 15)/2
//        let cellHeight = cellWidth * 1.3
//        return CGSize(width: cellWidth, height: CGFloat.random(in: 200...350))
//    }
//}
