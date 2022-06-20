//
//  DetailWaterCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit
protocol WaterLevelDelegate: AnyObject {
    func passWaterLV(_ waterLevel: WaterLevel)
}

enum WaterLevel: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}

class DetailWaterCell: UITableViewCell {
    
    @IBOutlet weak var waterLB: UILabel!
    @IBOutlet weak var water1: UIButton!
    @IBOutlet weak var water2: UIButton!
    @IBOutlet weak var water3: UIButton!
    @IBOutlet weak var water4: UIButton!
    @IBOutlet weak var water5: UIButton!
    @IBOutlet weak var waterView: UIStackView!
    var waterLevel: WaterLevel = .five
    var delegate: WaterLevelDelegate?
    
    @IBAction func waterLevel(_ sender: UIButton) {
        
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
        delegate?.passWaterLV(waterLevel)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupStackView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        waterLB.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                     right: contentView.rightAnchor, paddingTop: 8,
                     paddingLeft: 8, paddingRight: 8)
    }
    
    func setupStackView() {
        waterView.anchor(top: waterLB.bottomAnchor, left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 24, paddingBottom: 8, paddingRight: 54)
        waterView.distribution = .fillEqually
    }
    
}
