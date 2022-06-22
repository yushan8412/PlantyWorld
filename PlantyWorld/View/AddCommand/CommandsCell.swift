//
//  CommandsCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/21.
//

import UIKit

class CommandsCell: UITableViewCell {

    @IBOutlet weak var commandView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var command: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        commandView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                           bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                           paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        commandView.backgroundColor = .systemYellow
        commandView.addSubview(profilePic)
        profilePic.anchor(top: commandView.topAnchor, left: commandView.leftAnchor,
                          paddingTop: 8, paddingLeft: 8, width: 50, height: 50)
        commandView.addSubview(name)
        name.anchor(top: commandView.topAnchor, left: profilePic.rightAnchor, paddingTop: 8, paddingLeft: 8)
        name.backgroundColor = .systemYellow
        
        commandView.addSubview(command)
        command.anchor(top: name.bottomAnchor, left: profilePic.rightAnchor,
                       bottom: commandView.bottomAnchor,
                       right: commandView.rightAnchor, paddingTop: 8,
                       paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        command.numberOfLines = 0
        command.backgroundColor = .systemYellow
    }
    
}