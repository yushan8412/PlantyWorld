//
//  PlantDetailCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/16.
//

import UIKit

class PlantDetailCell: UITableViewCell {
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var dateLB: UILabel!
    
    var plantList: [PlantsModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupFont() {
        nameLB.font = UIFont.systemFont(ofSize: 24)
        dateLB.font = UIFont.systemFont(ofSize: 18)
        dateLB.textColor = .darkGray
    }
    
    func setupLayout() {
        nameLB.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                      right: contentView.rightAnchor, paddingTop: 8,
                      paddingLeft: 24, paddingRight: 24)
        dateLB.anchor(top: nameLB.bottomAnchor, left: contentView.leftAnchor,
                      bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                      paddingTop: 8, paddingLeft: 24,
                      paddingBottom: 8, paddingRight: 24)
    }
    
}
