//
//  DetailWaterCell.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import UIKit
protocol WaterLevelDelegate: AnyObject {
    func passWaterLV(_ waterLevel: Int)
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
    var delegate: WaterLevelDelegate?
    
    @IBAction func waterLevel(_ sender: UIButton) {
        
        switch sender {
        case water1:
            waterLevel = 1
            water1.tintColor = .systemBlue
            water2.tintColor = .systemGray
            water3.tintColor = .systemGray
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
            
        case water2:
            waterLevel = 2
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemGray
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
                        
        case water3:
            waterLevel = 3
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
            
        case water4:
            waterLevel = 4
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemBlue
            water5.tintColor = .systemGray
            
        case water5:
            waterLevel = 5
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemBlue
            water5.tintColor = .systemBlue
                    
        default:
            waterLevel = 0
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
    
    func waterColor(waterLevel: Int) {
        switch waterLevel {

        case 1:
            water1.tintColor = .systemBlue
            water2.tintColor = .systemGray
            water3.tintColor = .systemGray
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
            
        case 2:
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemGray
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
                        
        case 3:
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemGray
            water5.tintColor = .systemGray
            
        case 4:
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemBlue
            water5.tintColor = .systemGray
            
        case 5:
            water1.tintColor = .systemBlue
            water2.tintColor = .systemBlue
            water3.tintColor = .systemBlue
            water4.tintColor = .systemBlue
            water5.tintColor = .systemBlue
                    
        default:
            self.waterLevel = 0
        }
    }
}
