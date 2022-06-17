//
//  CalendarVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import Foundation
import UIKit

class CalendarVC: UIViewController {
    
    var calendar = UIDatePicker()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        view.addSubview(calendar)
        view.addSubview(tableView)
        setup()
        
    }
    
    func setup() {
        calendar.anchor(top: view.topAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingTop: 10,
                        paddingLeft: 10, paddingRight: 10, height: 400)
        calendar.datePickerMode = .date
        calendar.preferredDatePickerStyle = .inline
        tableView.anchor(top: calendar.bottomAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
