//
//  NoteCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/19.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteLB: UILabel!
    @IBOutlet weak var noteContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        noteLB.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                      right: contentView.rightAnchor, paddingTop: 8,
                      paddingLeft: 8, paddingRight: 8)
        noteLB.numberOfLines = 0
        noteContent.anchor(top: noteLB.bottomAnchor, left: contentView.leftAnchor,
                           bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                           paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        noteContent.numberOfLines = 0
        
    }
    
}
