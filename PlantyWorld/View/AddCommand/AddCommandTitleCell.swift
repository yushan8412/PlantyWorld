//
//  AddCommandTitleCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/21.
//

import UIKit

class AddCommandTitleCell: UITableViewCell {

    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        plantImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                          bottom: contentView.bottomAnchor, paddingTop: 8,
                          paddingLeft: 8, paddingBottom: 8, width: 100, height: 80)
        plantImage.contentMode = .scaleAspectFill
        plantImage.layer.cornerRadius = 15
        
        title.anchor(top: contentView.topAnchor, left: plantImage.rightAnchor,
                     right: contentView.rightAnchor, paddingTop: 12,
                     paddingLeft: 8, paddingBottom: 8)
        title.textColor = .darkGray
        
        date.anchor(top: title.bottomAnchor, left: plantImage.rightAnchor,
                    right: contentView.rightAnchor, paddingTop: 8,
                    paddingLeft: 8, paddingRight: 8)
        date.textColor = .darkGray
    }
    
}
