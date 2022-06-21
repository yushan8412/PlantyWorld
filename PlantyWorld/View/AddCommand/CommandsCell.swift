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
                          bottom: commandView.bottomAnchor, paddingTop: 8,
                          paddingLeft: 8, paddingBottom: 8, width: 50, height: 50)
    }
    
}
