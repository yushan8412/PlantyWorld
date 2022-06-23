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
    
//    var calendar = UIDatePicker()
    var tableView = UITableView()
    var calendar: FSCalendar!
    var plant: PlantsModel?
    var addField = UITextField()
    var addBtn = UIButton()
    var sticker = UILabel()
    var eventsList: [CalendarModel] = [] {
        didSet {
            DispatchQueue.main.async {
                print(self.eventsList)
            }
        }
    }

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        setup()
        let tryCalendar = FSCalendar(frame: CGRect(x: 10, y: 100,
                                                   width: UIScreen.width - 20,
                                                   height: UIScreen.height/2 ))
        tryCalendar.dataSource = self
        tryCalendar.delegate = self
        view.addSubview(tryCalendar)
        self.calendar = tryCalendar
        calendarUI()
        
        self.tableView.register(UINib(nibName: "NoteCell", bundle: nil),
                                forCellReuseIdentifier: "NoteCell")
        
        FirebaseManager.shared.fetchEvent(plantID: plant?.id ?? "",
                                          completion: { eventsList in self.eventsList = eventsList ?? [] })
       
    }
    
    func setup() {
        view.addSubview(tableView)
        view.addSubview(addBtn)
        view.addSubview(addField)
        view.addSubview(sticker)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor,
                         bottom: addField.topAnchor, right: view.rightAnchor,
                         paddingTop: UIScreen.height/2 + 110, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0)
        sticker.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 24, paddingBottom: 24)
        sticker.text = "🌸"
        sticker.font = UIFont.systemFont(ofSize: 30)
        sticker.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)
        addField.anchor(left: sticker.rightAnchor, bottom: view.bottomAnchor,
                        right: addBtn.leftAnchor, paddingLeft: 8, paddingBottom: 24, paddingRight: 8)
        addField.placeholder = "Leave some note "
        addBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 24)
        addBtn.setTitle("add", for: .normal)
        addBtn.backgroundColor = .blue
        addBtn.setContentHuggingPriority(UILayoutPriority(254), for: .horizontal)
        addField.borderStyle = .roundedRect
        
    }
    
    func calendarUI() {
        self.calendar.appearance.selectionColor = .systemYellow
        calendar.appearance.todayColor = .systemMint
        calendar.backgroundColor = .systemPink
        calendar.appearance.weekdayTextColor = .systemYellow
        calendar.appearance.headerTitleColor = .systemYellow
    }
    
    func addData() {
        
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let offsetDate = date.addingTimeInterval(28800)
        print(offsetDate)
    }

}
