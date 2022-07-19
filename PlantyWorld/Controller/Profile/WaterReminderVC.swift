//
//  WaterReminderVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/15.
//

import Foundation
import UIKit
import SwiftUI

class WaterReminderVC: UIViewController {
    var bgView = UIView()
    var swich = UISwitch()
    var titleLb = UILabel()
    var time = Date()
    var saveBtn = UIButton()
    var closeBtn = UIButton(type: .close)
    var switchStatus = true
    let uuidString = UUID().uuidString              // 建立UNNotificationRequest所需要的ID
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        datePicker.backgroundColor = .lightGray
        datePicker.tintColor = .black
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    override func viewDidLoad() {
        isNotificationOn()
        view.backgroundColor = .clear
    }
     
    override func viewWillAppear(_ animated: Bool) {
        setupBG()
        setDatePiceker()
        setCloseBtn()
        setSaveBtn()
        setFunc()
        self.presentedViewController?.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupBG() {
        view.addSubview(bgView)
        view.addSubview(swich)
        view.addSubview(titleLb)
        view.addSubview(datePicker)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn
        )
        bgView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                      right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                      paddingRight: 0, height: 350)
        bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bgView.layer.cornerRadius = 30
        
        bgView.backgroundColor = .white
        titleLb.anchor(top: bgView.topAnchor, paddingTop: 24)
        titleLb.centerX(inView: view)
        titleLb.text = "Watering Reminder"
        titleLb.font = UIFont(name: "Chalkboard SE", size: 24)
        
        swich.anchor(top: bgView.topAnchor, left: bgView.leftAnchor, paddingTop: 24, paddingLeft: 16)
        swich.onTintColor = .trygreen
        
        closeBtn.anchor(top: bgView.topAnchor, right: bgView.rightAnchor,
                        paddingTop: 24, paddingRight: 16)
    }
    private func setFunc() {
        swich.addTarget(self, action: #selector(stateSwitch), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(tapToSave), for: .touchUpInside)
    }
    
    private func setCloseBtn() {
        closeBtn.setTitle("", for: .normal)
        closeBtn.tintColor = .black
        closeBtn.addTarget(self, action: #selector(tappedToDismiss), for: .touchUpInside)
    }
    
    @objc func tapToSave() {
        self.time = datePicker.date
        self.setNotification(time: self.time)
        self.switchStatus = true
        
        print(time)
        print("!!!!\(Calendar.current.dateComponents([.hour, .minute], from: Date()))")
    }
    
    @objc func tappedToDismiss() {
        navigationController?.popViewController(animated: true)
        let presentVC = self.presentingViewController
        presentVC?.tabBarController?.tabBar.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    private func setDatePiceker() {
        datePicker.anchor(top: titleLb.bottomAnchor, left: bgView.leftAnchor,
                          right: bgView.rightAnchor, paddingTop: 8,
                          paddingLeft: 0, paddingRight: 0)
    }
    
    private func setSaveBtn() {
        saveBtn.anchor(top: datePicker.bottomAnchor, paddingTop: 8)
        saveBtn.centerX(inView: view)
        saveBtn.setTitle(" Save ", for: .normal)
        saveBtn.layer.cornerRadius = 10
        saveBtn.backgroundColor = .trygreen
    }
    
    @objc func stateSwitch(_ sender: UISwitch) {
        if sender.isOn {
            switchStatus = true
            datePicker.isEnabled = true
//            setNotification()
        } else {
            switchStatus = false
            datePicker.isEnabled = false
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuidString])
            
        }
    }
    
    func isNotificationOn() {
        if switchStatus == true {
            self.swich.isOn = true
            self.datePicker.isEnabled = true
        } else {
            self.swich.isOn = false
            self.datePicker.isEnabled = false
        }
    }
    
    func setNotification(time: Date) {
        let content = UNMutableNotificationContent()
        // 建立內容透過指派content來取得UNMutableNotificationContent功能
        content.title = "Planty World"                 // 推播標題
        content.subtitle = "Watering Reminder"            // 推播副標題
        content.body = "Don't forget to water your plants today🌱"        // 推播內文
        content.sound = UNNotificationSound.defaultCritical     // 推播的聲音
        content.badge = 0
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let component = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
        
//        let component = Calendar.current.dateComponents([.hour, .minute], from: time)
        // notification 的時間
//        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        // 設定透過時間來完成推播，另有日期地點跟遠端推播
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
                    if error != nil {
                        print("add notification failed, \(error)")
//                        self.presentAlert(title: "Error", message: "Notification Error: \(error). Please try again later.")
                    }
                }
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        // 向UNUserNotificationCenter新增註冊這一則推播
        
    }

}
