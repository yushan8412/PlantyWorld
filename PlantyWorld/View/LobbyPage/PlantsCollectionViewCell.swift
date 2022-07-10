//
//  PlantsCollectionViewCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import UIKit

class PlantsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(PlantsCollectionViewCell.self)"
    
    var title = UILabel()
    var mainPic = UIImageView()
    var waterDrop = UIImageView()
    
    let blureview = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainPic)
        contentView.addSubview(waterDrop)
        contentView.addSubview(blureview)
        contentView.addSubview(title)
        contentView.backgroundColor = .trygreen
        blureview.layer.cornerRadius = 10
        blureview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        layoutSubviews()
        setup()
        
    }
    
    func setup() {

        mainPic.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       bottom: contentView.bottomAnchor,
                       right: contentView.rightAnchor,
                       paddingTop: 0, paddingLeft: 0,
                       paddingBottom: 0, paddingRight: 0)
        mainPic.layer.cornerRadius = 10
        
        blureview.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor,
                          right: contentView.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                          paddingRight: 0, height: 35)

        title.anchor(top: blureview.topAnchor,
                     left: blureview.leftAnchor,
                     bottom: blureview.bottomAnchor,
                     paddingTop: 8, paddingLeft: 12, paddingBottom: 8)
        title.font = UIFont(name: "Apple SD Gothic Neo Medium", size: 20)
        title.textColor = .white

        mainPic.contentMode = .scaleAspectFill
        mainPic.clipsToBounds = true
        
//        waterDrop.anchor(top: contentView.topAnchor, right: contentView.rightAnchor,
//                         paddingTop: 8, paddingRight: 8, width: 25, height: 30)
//        waterDrop.image = UIImage(named: "Vector-5")
        
    }

}
