//
//  DetailSunCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit

protocol SunLevelDelegate: AnyObject {
    func passSunLevel(_ sunLevel: Int)
}

class DetailSunCell: UITableViewCell {
    
    var sunLevel: Int = 1
    @IBOutlet weak var sunLB: UILabel!
    @IBOutlet weak var sun1: UIButton!
    @IBOutlet weak var sun2: UIButton!
    @IBOutlet weak var sun3: UIButton!
    @IBOutlet weak var sun4: UIButton!
    @IBOutlet weak var sun5: UIButton!
    @IBOutlet weak var sunView: UIStackView!
    
    var delegate: SunLevelDelegate?
    
    @IBAction func tapBtnToSunLevel(_ sender: UIButton) {
        switch sender {
        case sun1:
            sunLevel = 1
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemGray2
            sun3.tintColor = .systemGray2
            sun4.tintColor = .systemGray2
            sun5.tintColor = .systemGray2
        case sun2:
            sunLevel = 2
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemGray2
            sun4.tintColor = .systemGray2
            sun5.tintColor = .systemGray2
        case sun3:
            sunLevel = 3
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemGray2
            sun5.tintColor = .systemGray2
//            print(sunLevel.rawValue)
        case sun4:
            sunLevel = 4
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemYellow
            sun5.tintColor = .systemGray2
        case sun5:
            sunLevel = 5
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemYellow
            sun5.tintColor = .systemYellow
        default:
            sunLevel = 0
        }
        delegate?.passSunLevel(sunLevel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        setup()
        sunLB.textColor = .black
        sunLB.font =  UIFont(name: "Chalkboard SE", size: 20)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func sunColor(sunLevel: Int) {
        switch sunLevel {
        case 1:
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemGray
            sun3.tintColor = .systemGray
            sun4.tintColor = .systemGray
            sun5.tintColor = .systemGray
        case 2:
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemGray
            sun4.tintColor = .systemGray
            sun5.tintColor = .systemGray
        case 3:
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemGray
            sun5.tintColor = .systemGray
        case 4:
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemYellow
            sun5.tintColor = .systemGray
        case 5:
            sun1.tintColor = .systemYellow
            sun2.tintColor = .systemYellow
            sun3.tintColor = .systemYellow
            sun4.tintColor = .systemYellow
            sun5.tintColor = .systemYellow
        default:
            self.sunLevel = 0
        }
        
    }
        
    func setup() {
        sunLB.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                     right: contentView.rightAnchor, paddingTop: 8,
                     paddingLeft: 16, paddingRight: 8)
        sunLB.text = "Sun????"
        sunView.anchor(top: sunLB.bottomAnchor, left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 24, paddingBottom: 4, paddingRight: 54)
        sunView.distribution = .fillEqually
        sunView.alignment = .center
    }
    
}
