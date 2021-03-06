//
//  CommandCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit

protocol AddCommandBtnDelegate: AnyObject {
    func didTapped(sender: UIButton)
}

class CommandCell: UITableViewCell {
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var commandLB: UILabel!
    @IBOutlet weak var commandBtn: UIButton!
    var delegate: AddCommandBtnDelegate?
    
    @IBAction func tapToCommand(_ sender: UIButton) {
        delegate?.didTapped(sender: commandBtn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        backgroundColor = .clear
        basicView.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 12, paddingLeft: 24,
                         paddingBottom: 12, paddingRight: 24, height: 255)
        basicView.backgroundColor = .pgreen
        basicView.layer.cornerRadius = 20
        
        mainImage.anchor(top: basicView.topAnchor, left: basicView.leftAnchor,
                         right: basicView.rightAnchor, paddingTop: 0,
                         paddingLeft: 0, paddingRight: 0, height: 180)
        mainImage.layer.cornerRadius = 20
        mainImage.contentMode = .scaleAspectFill
        mainImage.image = UIImage(named: "山烏龜")
        
        titleLB.anchor(top: mainImage.bottomAnchor, left: basicView.leftAnchor,
                       right: basicView.rightAnchor, paddingTop: 8,
                       paddingLeft: 8, paddingRight: 8)
        titleLB.font =  UIFont(name: "Chalkboard SE", size: 20)

        commandLB.anchor(top: titleLB.bottomAnchor, left: basicView.leftAnchor,
                         bottom: basicView.bottomAnchor, right: basicView.rightAnchor,
                         paddingTop: 8, paddingLeft: 8,
                         paddingBottom: 8, paddingRight: 8)
        commandLB.font =  UIFont(name: "Chalkboard SE", size: 14)

        commandBtn.anchor(bottom: basicView.bottomAnchor, right: basicView.rightAnchor,
                          paddingBottom: 8, paddingRight: 8)
        commandBtn.setImage(UIImage(named: "conversation 1"), for: .normal)
        commandBtn.backgroundColor = .peach
        commandBtn.layer.cornerRadius = 22
        commandBtn.setTitle("", for: .normal)

    }
    
}
