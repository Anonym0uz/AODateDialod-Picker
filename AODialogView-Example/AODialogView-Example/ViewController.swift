//
//  ViewController.swift
//  DialogAlert
//
//  Created by Alexander Orlov on 30/01/2020.
//  Copyright © 2020 Alexander Orlov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var showButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemYellow
        btn.layer.cornerRadius = 40/2
        btn.clipsToBounds = true
        return btn
    }()
    
    var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.text = "Date selected"
        return lbl
    }()
    
    var dialogView: AODialogView!
    
    var defaultDate: Date = Date()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM.dd.yyyy, HH:mm"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .systemBackground
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        showButton.addTarget(self, action: #selector(showDialog), for: .touchUpInside)
        view.addSubview(showButton)
        view.addSubview(dateLabel)
        
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        if #available(iOS 11.0, *) {
            showButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            showButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        }
        showButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        showButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    @objc fileprivate func showDialog() {
        
        let alert = UIAlertController(title: "AODialogView example", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Date (Alert)", style: .default, handler: { (a) in
            AODialogView.shared.show(delegate: self,
                                     doneTitle: "Donz",
                                     cancelTitle: "Cancez",
                                     style: .date,
                                     enableBackgroundDismiss: true,
                                     defaultDate: self.defaultDate,
                                     minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                                     maximumDate: self.dateFormatter.date(from: "01.01.2021, 00:00"),
                                     dateFormat: "MM/dd/yyyy")
        }))
        alert.addAction(UIAlertAction(title: "Date & Time (Alert)", style: .default, handler: { (a) in
            AODialogView.shared.show(delegate: self,
                                     doneTitle: "Donz",
                                     cancelTitle: "Cancez",
                                     style: .dateTime,
                                     enableBackgroundDismiss: true,
                                     defaultDate: self.defaultDate,
                                     minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                                     maximumDate: self.dateFormatter.date(from: "01.01.2021, 00:00"),
                                     dateFormat: "dd.MM.yyyy HH:mm")
        }))
        alert.addAction(UIAlertAction(title: "Time (Alert w/h left hand)", style: .default, handler: { (a) in
            AODialogView.shared.show(delegate: self,
                                     doneTitle: "Donez",
                                     cancelTitle: "Cancelez",
                                     style: .time,
                                     leftHandConfirm: true,
                                     enableBackgroundDismiss: true,
                                     defaultDate: self.defaultDate,
                                     minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                                     maximumDate: nil,
                                     dateFormat: "HH:mm")
        }))
        
        alert.addAction(UIAlertAction(title: "Date (Action Sheet)", style: .default, handler: { (a) in
            AODialogView.shared.show(delegate: self,
                                     doneTitle: "Donz",
                                     cancelTitle: "Cancez",
                                     style: .date,
                                     enableBackgroundDismiss: true,
                                     defaultDate: self.defaultDate,
                                     minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                                     maximumDate: self.dateFormatter.date(from: "01.01.2021, 00:00"),
                                     dateFormat: "MM/dd/yyyy",
                                     alertStyle: .actionSheet)
        }))
        alert.addAction(UIAlertAction(title: "Date & Time (Action Sheet)", style: .default, handler: { (a) in
            AODialogView.shared.show(delegate: self,
                                     doneTitle: "Donz",
                                     cancelTitle: "Cancez",
                                     style: .dateTime,
                                     enableBackgroundDismiss: true,
                                     defaultDate: self.defaultDate,
                                     minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                                     maximumDate: self.dateFormatter.date(from: "01.01.2021, 00:00"),
                                     dateFormat: "dd.MM.yyyy HH:mm",
                                     alertStyle: .actionSheet)
        }))
        alert.addAction(UIAlertAction(title: "Time (Action Sheet)", style: .default, handler: { (a) in
            AODialogView.shared.show(delegate: self,
                                     doneTitle: "Donez",
                                     cancelTitle: "Cancelez",
                                     style: .time,
                                     enableBackgroundDismiss: true,
                                     defaultDate: self.defaultDate,
                                     minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                                     maximumDate: nil,
                                     dateFormat: "HH:mm",
                                     alertStyle: .actionSheet)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        
    }
}

extension ViewController: AODialogViewDelegate {
    func dialogDidDisappear() {
        self.dialogView = nil
    }
    
    func doneClicked(selectedDate: Date) {
        self.dialogView = nil
        self.defaultDate = selectedDate
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        dateLabel.text = dateFormatter.string(from: selectedDate)
    }
    
    func cancelClicked() {
        self.dialogView = nil
    }
}
