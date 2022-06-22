//
//  CalendarVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/17.
//

import Foundation
import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    var calendar = UIDatePicker()
    var tableView = UITableView()
    var tryCalendar: FSCalendar!
    var plant: PlantsModel?

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        view.addSubview(tableView)
        setup()
        let tryCalendar = FSCalendar(frame: CGRect(x: 10, y: 100,
                                                   width: UIScreen.width - 20,
                                                   height: UIScreen.height/2 ))
        tryCalendar.dataSource = self
        tryCalendar.delegate = self
        view.addSubview(tryCalendar)
        self.tryCalendar = tryCalendar
        calendarUI()
        self.tableView.register(UINib(nibName: "NoteCell", bundle: nil),
                                forCellReuseIdentifier: "NoteCell")
       
    }
    
    func setup() {
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: UIScreen.height/2 + 110, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }
    
    func calendarUI() {
        self.tryCalendar.appearance.selectionColor = .systemYellow
        tryCalendar.appearance.todayColor = .systemMint
        tryCalendar.backgroundColor = .systemPink
        tryCalendar.appearance.weekdayTextColor = .systemYellow
        tryCalendar.appearance.headerTitleColor = .systemYellow
    }
    
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plant?.note.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell") as? NoteCell
        else { return UITableViewCell() }
        cell.noteLB.text = "Note"
        cell.noteContent.text = "入手日期：\(String(describing: plant?.date ?? ""))"
        
        return cell
    }
    
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {

}
