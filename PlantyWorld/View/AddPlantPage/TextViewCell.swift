//
//  TextViewCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/27.
//

import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        title.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       right: contentView.rightAnchor,
                       paddingTop: 8, paddingLeft: 16, paddingRight: 8)
        title.textColor = .black
        title.font =  UIFont(name: "Chalkboard SE", size: 20)

        textView.anchor(top: title.bottomAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 12, paddingLeft: 8,
                         paddingBottom: 8, paddingRight: 8, height: 100)
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.font =  UIFont(name: "Chalkboard SE", size: 16)

    }
    
}
