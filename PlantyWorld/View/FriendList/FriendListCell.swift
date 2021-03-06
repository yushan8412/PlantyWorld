//
//  FriendListCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/5.
//

import UIKit

protocol BlockUserDelegate: AnyObject {
    func tapToBlock(cell: UITableViewCell)
}

protocol UnfollowDelegate: AnyObject {
    func tapToUnfollow(cell: UITableViewCell)
}

class FriendListCell: UITableViewCell {
    
    var delegate: BlockUserDelegate?
    var unfollowDelegate: UnfollowDelegate?
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var unfollowBtn: UIButton!
    
    @IBOutlet weak var blockBtn: UIButton!
    
    @IBAction func tapToUnfollow(_ sender: UIButton) {
        unfollowDelegate?.tapToUnfollow(cell: self)
    }
    @IBAction func tapToBlock(_ sender: UIButton) {
        delegate?.tapToBlock(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        contentView.backgroundColor = .clear

        setupUI()
    }
    
    func setupUI() {
        backView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                        bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                        paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        backView.layer.cornerRadius = 30
        backView.backgroundColor = .lightPeach
        
        friendImage.anchor(top: backView.topAnchor, left: backView.leftAnchor,
                           bottom: backView.bottomAnchor, paddingTop: 8, paddingLeft: 8,
                           paddingBottom: 8, width: 100, height: 80)
        friendImage.image = UIImage(named: "山烏龜")
        friendImage.layer.cornerRadius = 30
        friendImage.contentMode = .scaleAspectFill
        friendImage.clipsToBounds = true
        
        nameLb.anchor(left: friendImage.rightAnchor, paddingLeft: 8)
        nameLb.centerY(inView: contentView)
        nameLb.font = UIFont(name: "Chalkboard SE", size: 30)
        nameLb.text = "123123"
        nameLb.textColor = .black
        
        unfollowBtn.anchor(top: backView.topAnchor, right: backView.rightAnchor, paddingTop: 8, paddingRight: 8)
        unfollowBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 16)
        unfollowBtn.titleLabel?.text = "UNFOLLOW"

        blockBtn.anchor(right: backView.rightAnchor, paddingRight: 8, width: 40, height: 40)
        blockBtn.centerY(inView: backView)
        blockBtn.setImage(UIImage(named: "blockUser"), for: .normal)
        blockBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 20)
        blockBtn.setTitle("", for: .normal)
                
    }
    
}
