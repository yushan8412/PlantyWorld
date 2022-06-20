//
//  TextFieldCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {
    var waterLevel: WaterLevel = .one
    var sunLevel: SunLevel = .one

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        setup()
    }
    
    override func prepareForReuse() {
        textField.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        titleLB.anchor(top: contentView.topAnchor,
                       left: contentView.leftAnchor,
                       right: contentView.rightAnchor,
                       paddingTop: 8, paddingLeft: 8, paddingRight: 8)
        textField.anchor(top: titleLB.bottomAnchor,
                         left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor,
                         right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 8,
                         paddingBottom: 8, paddingRight: 8)
       
    }
    
}
