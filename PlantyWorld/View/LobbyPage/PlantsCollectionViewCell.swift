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

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        contentView.addSubview(mainPic)
        contentView.addSubview(waterDrop)
        contentView.backgroundColor = .pgreen
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
    }
    
    func setup() {
        
        title.anchor(top: self.contentView.topAnchor,
                     left: self.contentView.leftAnchor,
                     paddingTop: 16, paddingLeft: 14)
        
        mainPic.anchor(top: title.bottomAnchor,
                       left: contentView.leftAnchor,
                       bottom: contentView.bottomAnchor,
                       right: contentView.rightAnchor,
                       paddingTop: 8, paddingLeft: 12,
                       paddingBottom: 12, paddingRight: 12, width: 120)
        mainPic.contentMode = .scaleAspectFill
        mainPic.clipsToBounds = true

    }

}
