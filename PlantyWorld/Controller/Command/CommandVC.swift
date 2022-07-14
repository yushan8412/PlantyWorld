//
//  CommandVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseAuth

class CommandVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var user: User?
    
    var plant: PlantsModel?
    
    var followList: [String]?
    
    var allPost = [PlantsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Planty Wall"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "32e3a86d9a8999f0632a696f3500c675")!)
        self.tableView.register(UINib(nibName: "CommandCell", bundle: nil),
                                forCellReuseIdentifier: "CommandCell")
        tableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserFriendList()
        
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
        } else {
            return
        }
    }
    
    func getUserFriendList() {
        if Auth.auth().currentUser != nil {
            self.followList?.removeAll()
            UserManager.shared.fetchUserData(userID: Auth.auth().currentUser?.uid ?? "") { result in
                switch result {
                case .failure:
                    print("Error")
                case .success(let user):
                    self.user = user
                    self.followList = self.user?.followList
                    self.followList?.append(Auth.auth().currentUser?.uid ?? "no user")
                    self.getAllPost()
                }
            }
        } else {
            self.allPost.removeAll()
            self.tableView.reloadData()
        }
    }

    func getAllPost() {
        self.allPost.removeAll()
        
        for aID in followList ?? [] {
            FirebaseManager.shared.fetchUserPlantsData(uid: aID) { plants in
                for plant in plants {
                    self.allPost.append(plant)
                    self.allPost.sort {
                        $0.createdTime.seconds > $1.createdTime.seconds
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

// MARK: TableView
extension CommandVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CommandCell") as? CommandCell
        else { return UITableViewCell() }
        
        cell.userImage.kf.setImage(with: URL(string: allPost[indexPath.row].userImage))
        cell.titleLB.text = allPost[indexPath.row].userName
        cell.commandLB.text = (allPost[indexPath.row].name)
        cell.mainImage.kf.setImage(with: URL(string: allPost[indexPath.row].image))
        
        self.plant = allPost[indexPath.row]
        
        cell.delegate = self

        return cell
    }
    
}

extension CommandVC: AddCommandBtnDelegate {
    func didTapped(sender: UIButton) {

        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        
        let addCommandVC = AddCommandVC()
    
        addCommandVC.modalPresentationStyle = .overCurrentContext
        navigationController?.present(addCommandVC, animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = true
        
        addCommandVC.plant = allPost[indexPath.row]
    }
    
}

extension CommandVC: BackBtnDelegate {
    func tappedToDissmis() {
        dismiss(animated: true)
    }
}
