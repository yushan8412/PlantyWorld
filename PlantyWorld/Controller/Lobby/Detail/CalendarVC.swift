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
    var eventList: [CalendarModel] = [] {
        didSet {
            DispatchQueue.main.async {
                print(self.eventList)
            }
        }
    }
    var dayEvent: [CalendarModel] = []

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .lightPeach
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let todays = formatter.string(from: Date())
        
        getOneDayDate(date: todays)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let todays = formatter.string(from: Date())
        
        getOneDayDate(date: todays)
        self.tableView.reloadData()
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
        tableView.backgroundColor = .lightPeach
        sticker.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 24, paddingBottom: 24)
        sticker.text = "🌸"
        sticker.font = UIFont.systemFont(ofSize: 30)
        sticker.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)
        addField.anchor(left: sticker.rightAnchor, bottom: view.bottomAnchor,
                        right: addBtn.leftAnchor, paddingLeft: 8, paddingBottom: 24, paddingRight: 8)
        addField.placeholder = "Leave some note "
        addField.borderStyle = .roundedRect
        
        addBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 24)
        addBtn.setTitle("add", for: .normal)
        addBtn.backgroundColor = .blue
        addBtn.setContentHuggingPriority(UILayoutPriority(254), for: .horizontal)
        addBtn.addTarget(self, action: #selector(addData), for: .touchUpInside)
        
    }
    
    func calendarUI() {
        self.calendar.appearance.selectionColor = .dPeach
        calendar.appearance.todayColor = .pgreen
        calendar.backgroundColor = .lightYellow
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        
    }
    
    func fetchData() {
        FirebaseManager.shared.fetchEvent(plantID: plant?.id ?? "", completion: { eventList in self.eventList = eventList ?? []
            self.tableView.reloadData() // 這邊要在抓完資料的時候 reload data
        })
    }
    
    @objc func addData() {
        FirebaseManager.shared.addEvent(content: addField.text ?? "", plantID: plant?.id ?? "")
        self.addField.text = ""
        self.tableView.reloadData()
    }
    
    func getOneDayDate(date: String) {
        self.dayEvent.removeAll()
 
        for event in eventList {
            if event.eventDate == date {
                dayEvent.append(event)
            }
            self.tableView.reloadData()
        }
        print(dayEvent)
    }
    
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(dayEvent.count)
//        return eventList.count
        return dayEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell") as? NoteCell
        else { return UITableViewCell() }
        cell.noteLB.text = "Event \(indexPath.row + 1)"
//        cell.noteContent.text = eventList[indexPath.row].content
        cell.noteContent.text = dayEvent[indexPath.row].content
        
        return cell
    }
    
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let offsetDate = date.addingTimeInterval(28800)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let dates = formatter.string(from: offsetDate)
        
        getOneDayDate(date: dates)
        print(dates)
        self.tableView.reloadData()

    }

}
