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
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.timeZone = TimeZone.current
        //            datePicker.addTarget(self, action: #selector(didChangedDate(_:)), for: .valueChanged)
//        datePicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        datePicker.backgroundColor = .lightGray
        datePicker.tintColor = .black
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        return datePicker
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        self.datePicker.isEnabled = false
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
        self.time = datePicker.date.addingTimeInterval(28800)
        print(time)
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
            datePicker.isEnabled = true
        } else {
            datePicker.isEnabled = false
        }
    }

}
