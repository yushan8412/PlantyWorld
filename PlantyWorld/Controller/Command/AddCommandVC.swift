//
//  AddCommandVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/20.
//

import Foundation
import UIKit
import Kingfisher

protocol BackBtnDelegate: AnyObject {
    func tappedToDissmis()
}

struct UserData: Codable {
    var user: User
    var comment: PublishModel
}

class AddCommandVC: UIViewController {
    
    var commandView = UIView()
    
    var user: [UserData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var backBtn = UIButton(type: .close)
    
    var commandField = UITextField()
    var sendCommandBtn = UIButton()
    var tableView = UITableView()
    
    var plant: PlantsModel?
    var newCommand = "no"
    var commandList: [PublishModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        setupBackBtn()
        setupSendBtn()
        setTextfield()
        view.isOpaque = false
      
        self.tableView.register(UINib(nibName: "AddCommandTitleCell", bundle: nil),
                                forCellReuseIdentifier: "AddCommandTitleCell")
        self.tableView.register(UINib(nibName: "CommandsCell", bundle: nil),
                                forCellReuseIdentifier: "CommandsCell")
        
        tabBarController?.tabBar.isHidden = true
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getComment()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        commandView.layoutIfNeeded()
        cornerRadius()
        
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.init(white: 0.1, alpha: 0.1)
        view.addSubview(commandView)
        commandView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        commandView.backgroundColor = .lightYellow
        commandView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                           right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                           paddingRight: 0, height: 500)
        
        commandView.addSubview(tableView)
        tableView.backgroundColor = .lightYellow
        tableView.anchor(top: commandView.topAnchor, left: commandView.leftAnchor,
                         right: commandView.rightAnchor,
                         paddingTop: 24, paddingLeft: 0, paddingRight: 0)
        
        tableView.addSubview(backBtn)
        backBtn.anchor(top: commandView.topAnchor, right: commandView.rightAnchor,
                       paddingTop: 36, paddingRight: 8)
        
        commandView.addSubview(commandField)
        commandField.anchor(top: tableView.bottomAnchor, left: commandView.leftAnchor,
                            bottom: commandView.bottomAnchor, paddingTop: 16,
                            paddingLeft: 16, paddingBottom: 35, height: 40)
        
        commandView.addSubview(sendCommandBtn)
        sendCommandBtn.anchor(top: tableView.bottomAnchor, left: commandField.rightAnchor,
                              bottom: commandView.bottomAnchor, right: commandView.rightAnchor,
                              paddingTop: 16, paddingLeft: 16, paddingBottom: 35, paddingRight: 16, height: 40)
    }
    
    func cornerRadius() {
        commandView.layer.cornerRadius = 30
        commandView.clipsToBounds = true
        commandView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
    }
    
    func setupBackBtn() {
        backBtn.setTitle("", for: .normal)
        backBtn.tintColor = .black
        backBtn.addTarget(self, action: #selector(tappedToDismiss), for: .touchUpInside)
    }
    
    func setupSendBtn() {
        sendCommandBtn.layer.cornerRadius = 10
        sendCommandBtn.backgroundColor = .dPeach
        sendCommandBtn.setTitle(" Send ", for: .normal)
        sendCommandBtn.addTarget(self, action: #selector(tappedToSend), for: .touchUpInside)
    }
    
    func setTextfield() {
        commandField.borderStyle = .roundedRect
        commandField.layer.borderWidth = 0.5
        commandField.attributedPlaceholder =
        NSAttributedString(string: "Add comment",
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        commandField.textColor = .darkGray
        commandField.backgroundColor = .white
        commandField.layer.cornerRadius = 10
    }
    
    @objc func tappedToDismiss() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedToSend() {
        
        FirebaseManager.shared.addCommand(name: plant?.name ?? "no name",
                                          id: plant?.id ?? "no id",
                                          newcommand: commandField.text ?? "nono")
        self.commandField.text = ""
        FirebaseManager.shared.fetchCommandData(plantID: plant?.id ?? "", completion: { commandlist in
            self.commandList = commandlist
            self.getComment()
            self.tableView.reloadData()}) // 要在這裡面reload
    }

    func getComment() {
        FirebaseManager.shared.fetchCommandData(plantID: plant?.id ?? "") { comments in
            for comment in comments {
                self.addUserData(comment: comment)
                self.tableView.reloadData()
            }
        }
        
    }
    
    func addUserData(comment: PublishModel) {
        self.user.removeAll()
        UserManager.shared.fetchUserData(userID: comment.userID) { result in
            switch result {
            case let .success(user):
                let userData = UserData(user: user, comment: comment)
                self.user.append(userData)
                self.user.sort { $0.comment.time > $1.comment.time }
                self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
            case.failure:
                print("Error")
                
            }
          
        }
    }
    
}

extension AddCommandVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return user.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "AddCommandTitleCell") as? AddCommandTitleCell
            else { return UITableViewCell() }
            cell.backgroundColor = .lightYellow
            cell.plantImage.kf.setImage(with: URL(string: plant?.image ?? ""))
            cell.title.text = plant?.name ?? ""
            cell.date.text = plant?.date ?? ""
            return cell
            
        } else {
            
            guard let commandCell = tableView.dequeueReusableCell(
                withIdentifier: "CommandsCell") as? CommandsCell
            else { return UITableViewCell() }
  
            commandCell.backgroundColor = .lightYellow
            commandCell.command.text = user[indexPath.row].comment.commands.command
            commandCell.profilePic.kf.setImage(with: URL(string: user[indexPath.row].user.userImage))
            commandCell.name.text = user[indexPath.row].user.name

            
            return commandCell
            
        }
        
    }
    
}
