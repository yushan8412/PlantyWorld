//
//  PlantDetailImageCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/16.
//

import UIKit

class PlantDetailImageCell: UITableViewCell {
    static let reuseidentify = "\(PlantDetailImageCell.self)"
    var image = UIImageView()
    var view = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(image)

        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(image)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(image)

        setup()
    }
    
    func setup() {
        image.anchor(top: contentView.topAnchor,
                     left: contentView.leftAnchor,
                     bottom: contentView.bottomAnchor,
                     right: contentView.rightAnchor,
                     paddingTop: 0, paddingLeft: 0,
                     paddingBottom: 16, paddingRight: 0, height: 500)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
  
    }
    
}
