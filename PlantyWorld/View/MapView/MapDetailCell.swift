//
//  MapDetailCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/6.
//

import UIKit

class MapDetailCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var storeImage: UIImageView!
    
    @IBOutlet weak var storeName: UILabel!
    
    @IBOutlet weak var storeAddress: UILabel!
    
    static let reuseIdentify = "\(MapDetailCell.self)"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    
    }
    
    func setup() {
        bgView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                      bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                      paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//        bgView.backgroundColor = .lightYellow
        bgView.backgroundColor = UIColor(patternImage: UIImage(named: "mapbg")!)

        bgView.layer.cornerRadius = 20
        
        storeName.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, paddingTop: 8, paddingLeft: 8)
        storeName.centerX(inView: bgView)
        
        storeAddress.anchor(top: storeName.bottomAnchor, left: bgView.leftAnchor,
                            right: bgView.rightAnchor, paddingTop: 4, paddingLeft: 8, paddingRight: 8)
        
        storeImage.anchor(top: storeAddress.bottomAnchor, bottom: bgView.bottomAnchor, paddingTop: 8,
                          paddingBottom: 8, width: 250)
        storeImage.centerX(inView: bgView)
        storeImage.contentMode = .scaleAspectFill
        storeImage.clipsToBounds = true
        storeImage.layer.cornerRadius = 20
        
        storeName.textColor = .black
        storeName.font = UIFont(name: "Chalkboard SE", size: 20)
        storeName.textAlignment = .center
        
        storeAddress.textColor = .black
        storeAddress.textAlignment = .center
        storeAddress.font = UIFont(name: "Chalkboard SE", size: 14)
        
    }

}
