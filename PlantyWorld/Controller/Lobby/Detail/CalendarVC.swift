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
    
    var tableView = UITableView()
    var calendar: FSCalendar!
    var plant: PlantsModel?
    var addField = UITextField()
    var tryCalendar = FSCalendar()
    
    var addEventBtn = UIButton()
    var sticker = UILabel()
    var eventList: [CalendarModel] = [] {
        didSet {
            DispatchQueue.main.async {
                print(self.eventList)
            }
        }
    }
    var dayEvent: [CalendarModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var pickedDate = String()


    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .lightPeach
        setup()
        tryCalendar.dataSource = self
        tryCalendar.delegate = self
        view.addSubview(tryCalendar)
        self.calendar = tryCalendar
        calendarUI()
        
        self.tableView.register(UINib(nibName: "NoteCell", bundle: nil),
                                forCellReuseIdentifier: "NoteCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        let todays = formatter.string(from: Date())
        
        fetchData(date: todays)
        self.tableView.reloadData()
    }
    
    func setup() {
        view.addSubview(tableView)
        view.addSubview(addEventBtn)
        view.addSubview(addField)
        view.addSubview(sticker)
        view.addSubview(tryCalendar)

        tableView.anchor(top: tryCalendar.bottomAnchor, left: view.leftAnchor,
                         bottom: addField.topAnchor, right: view.rightAnchor,
                         paddingTop: 8, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0)
        tableView.backgroundColor = .lightPeach
        sticker.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 24, paddingBottom: 24)
        sticker.text = "🌸"
        sticker.font = UIFont.systemFont(ofSize: 30)
        sticker.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)
        addField.anchor(left: sticker.rightAnchor, bottom: view.bottomAnchor,
                        right: addEventBtn.leftAnchor, paddingLeft: 8, paddingBottom: 24, paddingRight: 8)
        addField.attributedPlaceholder =
        NSAttributedString(string: "Add Event",
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        addField.borderStyle = .roundedRect
        addField.backgroundColor = .white
        addField.textColor = .black
        
        addEventBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 24, paddingRight: 24)
        addEventBtn.setTitle(" Add ", for: .normal)
        addEventBtn.backgroundColor = .pgreen
        addEventBtn.layer.cornerRadius = 10
        addEventBtn.setContentHuggingPriority(UILayoutPriority(254), for: .horizontal)
        addEventBtn.addTarget(self, action: #selector(addData), for: .touchUpInside)
        
    }
    
    func calendarUI() {
        tryCalendar.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
                           width: UIScreen.width - 20, height: UIScreen.height/2)
        tryCalendar.centerX(inView: view)
        self.calendar.appearance.selectionColor = .dPeach
        calendar.appearance.todayColor = .pgreen
        calendar.backgroundColor = .lightYellow
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerTitleColor = .black
        calendar.layer.cornerRadius = 20
        
    }
    
    func fetchData(date: String) {
        FirebaseManager.shared.fetchOneDayEvent(plantID: plant?.id ?? "",
                                                date: date) { events in self.dayEvent = events ?? []
        }
        
    }
    
    @objc func addData() {
        FirebaseManager.shared.addEvent(content: addField.text ?? "", plantID: plant?.id ?? "",
                                        date: pickedDate) { [self] result in
            switch result {
            case .success:
                FirebaseManager.shared.fetchOneDayEvent(plantID: plant?.id ?? "", date: pickedDate) { events in
                    self.dayEvent = events ?? []
                }
                self.tableView.reloadData()
            case .failure:
                print(" failure ")
            }

        }

        self.addField.text = ""
        
        FirebaseManager.shared.fetchEvent(plantID: plant?.id ?? "",
                                          completion: { eventList in self.eventList = eventList ?? []
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }
    
    func getOneDayDate(date: String) {
        self.dayEvent.removeAll()
 
        for event in eventList {
            if event.eventDate == date {
                dayEvent.append(event)
                self.tableView.reloadData()
            }
        }
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "NoteCell") as? NoteCell
        else { return UITableViewCell() }
        cell.backgroundColor = .lightPeach
        cell.noteLB.text = "Event \(indexPath.row + 1)"
        cell.noteContent.text = dayEvent[indexPath.row].content
        cell.bgView.backgroundColor = .trygreen
        cell.bgView.layer.cornerRadius = 20
        
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
        self.pickedDate = dates
        fetchData(date: dates)
        print(dates)
        
        self.tableView.reloadData()

    }

}
