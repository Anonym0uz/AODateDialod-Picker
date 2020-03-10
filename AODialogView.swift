//
//  AODialogView.swift
//  DialogAlert
//
//  Created by Alexander Orlov on 30/01/2020.
//  Copyright © 2020 Alexander Orlov. All rights reserved.
//

import UIKit

private extension Selector {
//    static let deviceOrientationDidChange = #selector(AODialogView.deviceOrientationDidChange)
}

private extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}

enum AODialogStyle {
    case date
    case dateTime
    case time
}

enum AODialogAlertStyle {
    case alert
    case actionSheet
}

protocol AODialogViewDelegate {
    /// Dismiss by background tap
    func dialogDidDisappear()
    /// Done click handler
    func doneClicked(selectedDate: Date)
    /// Cancel click handler
    func cancelClicked()
}

class AODialogView: UIView {
    
    var style: AODialogStyle!
    var alertStyle: AODialogAlertStyle!
    
    var delegate: AODialogViewDelegate?
    
    var datePicker: UIDatePicker!
    
    var dialogView: UIView!
    
    var contentView: UIView!
    
    var defaultDate: Date!
    var defaultDateFormat: String = "dd.MM.yyyy, HH:mm"
    
    var minDate: Date!
    var maxDate: Date!
    
    var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let borderBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray2
        return view
    }()
    
    let buttonBorder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray2
        return view
    }()
    
    let doneButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(UIColor.systemRed, for: .normal)
        btn.setTitleColor(UIColor.systemGray, for: .highlighted)
        btn.backgroundColor = .secondarySystemBackground
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    let cancelButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.setTitleColor(UIColor.systemGray, for: .highlighted)
        btn.backgroundColor = .secondarySystemBackground
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    var backgroundTapToDismiss: Bool = false
    
    private var buttonsHeight: CGFloat {
        return 50
    }
    
    static let shared = AODialogView(style: .date, frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(style: AODialogStyle, frame: CGRect) {
        let size = UIScreen.main.bounds.size
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(delegate: AODialogViewDelegate, doneTitle: String = "Done", cancelTitle: String = "Cancel", style: AODialogStyle = .dateTime, enableBackgroundDismiss: Bool = true, defaultDate: Date = Date(), minimumDate: Date? = nil, maximumDate: Date? = nil, dateFormat: String = "dd.MM.yyyy, HH:mm", alertStyle: AODialogAlertStyle = .alert) {
        self.delegate = delegate
        self.alertStyle = alertStyle
        self.style = style
        self.backgroundTapToDismiss = enableBackgroundDismiss
        self.doneButton.setTitle(doneTitle, for: .normal)
        self.cancelButton.setTitle(cancelTitle, for: .normal)
        self.defaultDate = defaultDate
        self.defaultDateFormat = dateFormat
        self.minDate = minimumDate
        self.maxDate = maximumDate
        setupBackground()
    }
    
    fileprivate func setupBackground() {
        
        if backgroundTapToDismiss {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeByBackgroundTap)))
        }
        
        /* Add dialog to main window */
        guard let appDelegate = UIApplication.shared.delegate else { fatalError() }
        guard let window = appDelegate.window else { fatalError() }
        
        setupDialogView()
        
        window?.addSubview(self)
        window?.bringSubviewToFront(self)
        window?.endEditing(true)
    }
    
    fileprivate func setupDialogView() {
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        dialogView = UIView()
        dialogView.backgroundColor = .secondarySystemBackground
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 7
        dialogView.alpha = 0
        dialogView.layer.opacity = 0.5
        dialogView.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        cancelButton.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        doneButton.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        dialogView.addSubview(dateLabel)
        dialogView.addSubview(borderBottomView)
        dialogView.addSubview(buttonBorder)
        
        contentView.addSubview(doneButton)
        contentView.addSubview(cancelButton)
        
        doneButton.addTarget(self, action: #selector(doneHandler), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(closeHandler), for: .touchUpInside)
        
        contentView.addSubview(dialogView)
        
//        NotificationCenter.default.addObserver(
//            self,
//            selector: .deviceOrientationDidChange,
//            name: UIDevice.orientationDidChangeNotification, object: nil
//        )
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.dialogView.alpha = 1
            self.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            self.cancelButton.alpha = 1
            self.doneButton.alpha = 1
            self.doneButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
            self.cancelButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
            self.alpha = 1
        }) { (success) in

        }
        setupDatePicker()
    }
    
    fileprivate func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.setDate(defaultDate, animated: true)
        datePicker.locale = Locale(identifier: "ru")
        datePicker.addTarget(self, action: #selector(dateHasChanged(picker:)), for: .valueChanged)
        
        let dateF = DateFormatter()
        switch style {
        case .date:
            datePicker.datePickerMode = .date
            dateF.dateFormat = defaultDateFormat
            dateLabel.text = dateF.string(from: defaultDate)
        case .dateTime:
            datePicker.datePickerMode = .dateAndTime
            dateF.dateFormat = defaultDateFormat
            dateLabel.text = dateF.string(from: defaultDate)
        case .time:
            datePicker.datePickerMode = .time
            dateF.dateFormat = defaultDateFormat
            dateLabel.text = dateF.string(from: defaultDate)
        case .none:
            print("")
        }
        dialogView.addSubview(datePicker)
        
        setupDialogContraints()
    }
    
    fileprivate func setupDialogContraints() {
//        contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        contentView.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: -20).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        if alertStyle == .alert {
            contentView.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: buttonsHeight + 40).isActive = true
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
            
            dialogView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
            dialogView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        } else {
            setupActionSheet()
        }
        dialogView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        dialogView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        dialogView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        dateLabel.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 0).isActive = true
        dateLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        datePicker.centerXAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 0).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 0).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: 0).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: 0).isActive = true
        datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0).isActive = true
        
//        borderBottomView.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 0).isActive = true
//        borderBottomView.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: 0).isActive = true
//        borderBottomView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 0).isActive = true
//        borderBottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        setupButtonConstraints()
    }
    
    fileprivate func setupButtonConstraints() {
        
        if alertStyle == .alert {
            cancelButton.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 0).isActive = true
            cancelButton.topAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: 20).isActive = true
            cancelButton.trailingAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: -5).isActive = true
            cancelButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
            
            doneButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: 0).isActive = true
            doneButton.topAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: 20).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
            doneButton.leadingAnchor.constraint(equalTo: dialogView.centerXAnchor, constant: 5).isActive = true
            
//            buttonBorder.topAnchor.constraint(equalTo: borderBottomView.bottomAnchor, constant: 0).isActive = true
//            buttonBorder.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 0).isActive = true
//            buttonBorder.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: 0).isActive = true
//            buttonBorder.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: 0).isActive = true
        }
    }
    
    fileprivate func setupActionSheet() {
        contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        
        doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        
        dialogView.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -10).isActive = true
        dialogView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc fileprivate func dateHasChanged(picker: UIDatePicker) {
        let dateF = DateFormatter()
        switch style {
        case .date:
            datePicker.datePickerMode = .date
            dateF.dateFormat = defaultDateFormat
            dateLabel.text = dateF.string(from: picker.date)
        case .dateTime:
            datePicker.datePickerMode = .dateAndTime
            dateF.dateFormat = defaultDateFormat
            dateLabel.text = dateF.string(from: picker.date)
        case .time:
            datePicker.datePickerMode = .time
            dateF.dateFormat = defaultDateFormat
            dateLabel.text = dateF.string(from: picker.date)
        case .none:
            print("")
        }
    }
    
    @objc fileprivate func doneHandler() {
        self.delegate?.doneClicked(selectedDate: datePicker.date)
        dismissView()
    }
    
    @objc fileprivate func closeHandler() {
        self.delegate?.cancelClicked()
        dismissView()
    }
    
    @objc fileprivate func closeByBackgroundTap() {
        self.delegate?.dialogDidDisappear()
        dismissView()
    }
    
    fileprivate func dismissView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.dialogView.alpha = 0
            self.dialogView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3)
            
            self.cancelButton.alpha = 0
            self.doneButton.alpha = 0
            self.doneButton.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            self.cancelButton.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            
            self.alpha = 0
        }) { (success) in
            if success {
                self.dialogView.removeFromSuperview()
                self.cancelButton.removeFromSuperview()
                self.doneButton.removeFromSuperview()
                self.contentView.removeFromSuperview()
                self.removeFromSuperview()
                
                self.dialogView = nil
                self.contentView = nil
            }
        }
    }
}

extension AODialogView {
    /// Handle device orientation changes
    @objc func deviceOrientationDidChange(_ notification: Notification) {
        self.frame = UIScreen.main.bounds
        dialogView.clearConstraints()
        
        setupDialogContraints()
    }
}
