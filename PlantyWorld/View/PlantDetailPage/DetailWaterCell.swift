//
//  DetailWaterCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit
protocol WaterLevelDelegate: AnyObject {
    func passWaterLevel(_ waterLevel: Int)
}

class DetailWaterCell: UITableViewCell {
    
    @IBOutlet weak var waterLB: UILabel!
    @IBOutlet weak var water1: UIButton!
    @IBOutlet weak var water2: UIButton!
    @IBOutlet weak var water3: UIButton!
    @IBOutlet weak var water4: UIButton!
    @IBOutlet weak var water5: UIButton!
    @IBOutlet weak var waterView: UIStackView!
    var waterLevel: Int = 1
    
    weak var delegate: WaterLevelDelegate?
    
    @IBAction func waterLevel(_ sender: UIButton) {
        
        switch sender {
        case water1:
            waterLevel = 1
            water1.tintColor = .waterBlue
            water2.tintColor = .systemGray2
            water3.tintColor = .systemGray2
            water4.tintColor = .systemGray2
            water5.tintColor = .systemGray2
            
        case water2:
            waterLevel = 2
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .systemGray2
            water4.tintColor = .systemGray2
            water5.tintColor = .systemGray2
                        
        case water3:
            waterLevel = 3
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .waterBlue
            water4.tintColor = .systemGray2
            water5.tintColor = .systemGray2
            
        case water4:
            waterLevel = 4
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .waterBlue
            water4.tintColor = .waterBlue
            water5.tintColor = .systemGray2
            
        case water5:
            waterLevel = 5
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .waterBlue
            water4.tintColor = .waterBlue
            water5.tintColor = .waterBlue
                    
        default:
            waterLevel = 0
        }
        delegate?.passWaterLevel(waterLevel)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupStackView()
        backgroundColor = .clear
        waterLB.textColor = .black
        waterLB.font =  UIFont(name: "Chalkboard SE", size: 20)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        waterLB.anchor(top: contentView.topAnchor, left: contentView.leftAnchor,
                     right: contentView.rightAnchor, paddingTop: 8,
                     paddingLeft: 16, paddingRight: 8)
        waterLB.text = "Water🌧"
    }
    
    func setupStackView() {
        waterView.anchor(top: waterLB.bottomAnchor, left: contentView.leftAnchor,
                         bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                         paddingTop: 8, paddingLeft: 24, paddingBottom: 4, paddingRight: 54)
        waterView.distribution = .fillEqually
    }
    
    func waterColor(waterLevel: Int) {
        switch waterLevel {

        case 1:
            water1.tintColor = .waterBlue
            water2.tintColor = .systemGray2
            water3.tintColor = .systemGray2
            water4.tintColor = .systemGray2
            water5.tintColor = .systemGray2
            
        case 2:
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .systemGray2
            water4.tintColor = .systemGray2
            water5.tintColor = .systemGray2
                        
        case 3:
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .waterBlue
            water4.tintColor = .systemGray2
            water5.tintColor = .systemGray2
            
        case 4:
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .waterBlue
            water4.tintColor = .waterBlue
            water5.tintColor = .systemGray2
            
        case 5:
            water1.tintColor = .waterBlue
            water2.tintColor = .waterBlue
            water3.tintColor = .waterBlue
            water4.tintColor = .waterBlue
            water5.tintColor = .waterBlue
                    
        default:
            self.waterLevel = 0
        }
    }
}
