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
    var bgView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
//        contentView.backgroundColor = .lightPeach
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        contentView.addSubview(bgView)
        bgView.addSubview(noteLB)
        bgView.addSubview(noteContent)
        bgView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                      bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                      paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)
        noteLB.anchor(top: bgView.topAnchor, left: bgView.leftAnchor,
                      right: bgView.rightAnchor, paddingTop: 8,
                      paddingLeft: 16, paddingRight: 16)
        noteLB.numberOfLines = 0
        noteContent.anchor(top: noteLB.bottomAnchor, left: bgView.leftAnchor,
                           bottom: bgView.bottomAnchor, right: bgView.rightAnchor,
                           paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        noteContent.numberOfLines = 0
        
    }
    
}
