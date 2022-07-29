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
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    
    @IBOutlet weak var commandBtn: UIButton!
    var delegate: AddCommandBtnDelegate?
    
    @IBAction func tapToCommand(_ sender: UIButton) {
        delegate?.didTapped(sender: commandBtn)
    }
    let blureview = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setcommentBtn()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setup() {
        backgroundColor = .clear
        mainImage.addSubview(blureview)

        basicView.anchor(top: contentView.topAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 24,
                         paddingBottom: 8, paddingRight: 24, height: 285)
        basicView.backgroundColor = .trygreen
        basicView.layer.cornerRadius = 20
        
        mainImage.anchor(top: basicView.topAnchor, left: basicView.leftAnchor,
                         bottom: basicView.bottomAnchor, right: basicView.rightAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
        mainImage.layer.cornerRadius = 20
        mainImage.contentMode = .scaleAspectFill

        blureview.anchor(left: mainImage.leftAnchor, bottom: mainImage.bottomAnchor,
                          right: mainImage.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                          paddingRight: 0, height: 80)
        blureview.layer.cornerRadius = 20

        mainImage.addSubview(blureview)

        userImage.anchor(top: blureview.topAnchor, left: blureview.leftAnchor,
                         paddingTop: 8, paddingLeft: 12, width: 34, height: 34)
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 17
        
        titleLB.anchor(top: blureview.topAnchor, left: userImage.rightAnchor,
                       right: blureview.rightAnchor, paddingTop: 13,
                       paddingLeft: 8, paddingRight: 8)
        titleLB.font =  UIFont(name: "Chalkboard SE", size: 20)

        nameLB.anchor(top: userImage.bottomAnchor, left: blureview.leftAnchor,
                         bottom: blureview.bottomAnchor, right: blureview.rightAnchor,
                         paddingTop: 4, paddingLeft: 12,
                         paddingBottom: 8, paddingRight: 8)
        nameLB.font =  UIFont(name: "Chalkboard SE", size: 20)
        
        titleLB.textColor = .white
        nameLB.textColor = .white

    }
    
    func setcommentBtn() {
        
        commandBtn.anchor(bottom: blureview.bottomAnchor, right: blureview.rightAnchor,
                          paddingBottom: 8, paddingRight: 8)
        commandBtn.setImage(UIImage(named: "conversation 1"), for: .normal)
        commandBtn.layer.cornerRadius = 22
        commandBtn.setTitle("", for: .normal)
        commandBtn.tintColor = .white
        
    }
    
}
