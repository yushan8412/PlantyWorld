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
        
        contentView.backgroundColor = .clear

        setupUI()
    }
    
    func setupUI() {
        backView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                        bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                        paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        backView.layer.cornerRadius = 30
        backView.backgroundColor = .lightPeach
        
        friendImage.anchor(top: backView.topAnchor, left: backView.leftAnchor,
                           bottom: backView.bottomAnchor, paddingTop: 8, paddingLeft: 8,
                           paddingBottom: 8, width: 80, height: 80)
        friendImage.image = UIImage(named: "山烏龜")
        friendImage.layer.cornerRadius = 40
        friendImage.contentMode = .scaleAspectFill
        friendImage.clipsToBounds = true
        
        nameLb.anchor(left: friendImage.rightAnchor, paddingLeft: 8)
        nameLb.centerY(inView: contentView)
        nameLb.font = UIFont(name: "Chalkboard SE", size: 22)
        nameLb.text = "123123"
        
        unfollowBtn.anchor(top: backView.topAnchor, right: backView.rightAnchor, paddingTop: 8, paddingRight: 8)
        unfollowBtn.setTitle("UNFOLLOW", for: .normal)
        
        blockBtn.anchor(bottom: backView.bottomAnchor ,right: backView.rightAnchor,
                        paddingBottom: 8, paddingRight: 8)
        blockBtn.setImage(UIImage(named: "blockUser"), for: .normal)
        blockBtn.setTitle("BLOCK", for: .normal)
                
    }
    
}
