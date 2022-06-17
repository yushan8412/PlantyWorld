//
//  TextFieldCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit

//enum SunLevel: Int {
//    case zero = 0
//    case one = 1
//    case two = 2
//    case three = 3
//    case four = 4
//    case five = 5
//}

class TextFieldCell: UITableViewCell {
    var waterLevel: WaterLevel = .one
    var sunLevel: SunLevel = .one

    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var dateTxf: UITextField!
    
    @IBOutlet weak var sunLB: UILabel!
    @IBOutlet weak var sun1: UIButton!
    @IBOutlet weak var sun2: UIButton!
    @IBOutlet weak var sun3: UIButton!
    @IBOutlet weak var sun4: UIButton!
    @IBOutlet weak var sun5: UIButton!
    @IBOutlet weak var sunStackView: UIStackView!
    
    @IBOutlet weak var waterLB: UILabel!
    @IBOutlet weak var waterStackView: UIStackView!
    @IBOutlet weak var water1: UIButton!
    @IBOutlet weak var water2: UIButton!
    @IBOutlet weak var water3: UIButton!
    @IBOutlet weak var water4: UIButton!
    @IBOutlet weak var water5: UIButton!
    
    @IBAction func sunLevel(_ sender: UIButton) {
        switch sender {
        case sun1:
            sunLevel = .one
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemGray
            sun3.tintColor = .systemGray
            sun4.tintColor = .systemGray
            sun5.tintColor = .systemGray
            
        case sun2:
            sunLevel = .two
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemGray
            sun4.tintColor = .systemGray
            sun5.tintColor = .systemGray
            
        case sun3:
            sunLevel = .three
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemGray
            sun5.tintColor = .systemGray
            
        case sun4:
            sunLevel = .four
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemYellow
            sun5.tintColor = .systemGray
            
        case sun5:
            sunLevel = .five
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemYellow
            sun5.tintColor = .systemYellow
                    
        default:
            sunLevel = .zero
        }
        
    }
    
    @IBAction func waterLV(_ sender: UIButton) {
        switch sender {
        case water1:
            waterLevel = .one
            water1.tintColor = .systemBlue
            water2.tintColor = .systemGray
            water3.tintColor = .systemGray
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
            
        case water2:
            waterLevel = .two
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemGray
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
                        
        case water3:
            waterLevel = .three
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
            
        case water4:
            waterLevel = .four
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemBlue
            water5.tintColor = .systemGray
            
        case water5:
            waterLevel = .five
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemBlue
            water5.tintColor = .systemBlue
                    
        default:
            waterLevel = .zero
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
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
                         right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 8,
                         paddingRight: 8)
        dateLB.anchor(top: textField.bottomAnchor, left: contentView.leftAnchor,
                      right: contentView.rightAnchor, paddingTop: 8,
                      paddingLeft: 8, paddingRight: 8)
        dateTxf.anchor(top: dateLB.bottomAnchor, left: contentView.leftAnchor,
                       right: contentView.rightAnchor, paddingTop: 8,
                       paddingLeft: 8, paddingRight: 8)
        sunLB.anchor(top: dateTxf.bottomAnchor, left: contentView.leftAnchor,
                     right: contentView.rightAnchor, paddingTop: 8,
                     paddingLeft: 8, paddingRight: 8)
        sunStackView.anchor(top: sunLB.bottomAnchor, left: contentView.leftAnchor,
                            right: contentView.rightAnchor, paddingTop: 8,
                            paddingLeft: 8, paddingRight: 8)
        sunStackView.distribution = .fillEqually
        
        waterLB.anchor(top: sunStackView.bottomAnchor, left: contentView.leftAnchor,
                       right: contentView.rightAnchor, paddingTop: 8,
                       paddingLeft: 8, paddingRight: 8)
        waterStackView.anchor(top: waterLB.bottomAnchor, left: contentView.leftAnchor,
                              bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                              paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        waterStackView.distribution = .fillEqually
        
    }
    
}
