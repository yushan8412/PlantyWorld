//
//  SunAndWaterCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/2.
//

import UIKit

class SunAndWaterCell: UITableViewCell {
    
    static let reuseidentify = "\(SunAndWaterCell.self)"
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var sunBG: UIView!
    @IBOutlet weak var sunPic: UIImageView!
    @IBOutlet weak var sunLb: UILabel!
    @IBOutlet weak var waterBG: UIView!
    @IBOutlet weak var waterPic: UIImageView!
    @IBOutlet weak var waterLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        contentView.backgroundColor = .clear
        setStackView()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setStackView() {
        stackView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 20, paddingBottom: 8, paddingRight: 20)
        stackView.distribution = .fillEqually
    }
    
    func setup() {
        waterBG.addSubview(waterPic)
        waterBG.addSubview(waterLb)
        sunBG.addSubview(sunPic)
        sunBG.addSubview(sunLb)
        
        sunBG.anchor(width: (UIScreen.width/2)-20, height: 120)
        sunBG.backgroundColor = .pyellow
        sunBG.layer.cornerRadius = 30

        sunPic.anchor(top: sunBG.topAnchor, left: sunBG.leftAnchor,
                      paddingTop: 8, paddingLeft: 8,
                      width: (UIScreen.width/2)-50, height: 70)
        sunPic.centerX(inView: sunBG)
        sunPic.image = UIImage(named: "sunny")
        sunPic.contentMode = .scaleAspectFit

        sunLb.anchor(top: sunPic.bottomAnchor, bottom: sunBG.bottomAnchor,
                     paddingTop: 8, paddingBottom: 8)
        sunLb.centerX(inView: sunBG)
        sunLb.font =  UIFont(name: "Chalkboard SE", size: 20)
        sunLb.textColor = .black
        waterBG.anchor(width: (UIScreen.width/2)-20, height: 120)
        waterBG.backgroundColor = .pyellow
        waterBG.layer.cornerRadius = 30

        waterPic.anchor(top: waterBG.topAnchor, left: waterBG.leftAnchor,
                      paddingTop: 8, paddingLeft: 8,
                      width: (UIScreen.width/2)-50, height: 70)
        waterPic.centerX(inView: waterBG)
        waterPic.image = UIImage(named: "drop")
        waterPic.contentMode = .scaleAspectFit
        
        waterLb.anchor(top: waterPic.bottomAnchor, bottom: waterBG.bottomAnchor,
                     paddingTop: 8, paddingBottom: 8)
        waterLb.centerX(inView: waterBG)
        waterLb.textColor = .black
        waterLb.font =  UIFont(name: "Chalkboard SE", size: 20)

    }
}
