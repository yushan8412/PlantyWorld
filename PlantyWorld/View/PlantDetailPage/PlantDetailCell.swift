//
//  PlantDetailCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/16.
//

import UIKit

class PlantDetailCell: UITableViewCell {
    
    var bgView = UIView()
    
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var dateLB: UILabel!
    
    var plantList: [PlantsModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        setupLayout()
        nameLB.textColor = .black
        dateLB.textColor = .black
        backgroundColor = .clear
        
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
        contentView.addSubview(bgView)
        bgView.addSubview(nameLB)
        bgView.addSubview(dateLB)
        
        bgView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                      bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                      paddingTop: 4, paddingLeft: 20, paddingBottom: 4, paddingRight: 20)
        bgView.backgroundColor = .lightPeach
        bgView.layer.cornerRadius = 20
        
        nameLB.anchor(top: bgView.topAnchor, left: bgView.leftAnchor,
                      right: bgView.rightAnchor, paddingTop: 8,
                      paddingLeft: 24, paddingRight: 24)
        nameLB.font =  UIFont(name: "Chalkboard SE", size: 24)

        dateLB.anchor(top: nameLB.bottomAnchor, left: bgView.leftAnchor,
                      bottom: bgView.bottomAnchor, right: bgView.rightAnchor,
                      paddingTop: 8, paddingLeft: 24,
                      paddingBottom: 8, paddingRight: 24)
        dateLB.font =  UIFont(name: "Chalkboard SE", size: 20)

    }
    
}
