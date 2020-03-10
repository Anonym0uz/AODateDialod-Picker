# AODateDialog-Picker

Custom representation of date & time picker. Main differences from UIDatePicker:
  - 2 presentation styles.
  - Based on constraints.
  - 3 date styles.
  - Easy set minimum, maximum & default date in one line.
  - Custom date format.
  - Dismiss delegate.
  - Lightweight & easy to use.
  
##### Support iOS **10-13**
  
  # Screenshots
-
-
-

## Installation
For now, cocoapods version is not available. :(
Simply drag AODialogView.swift into your project.

## Usage

Usage example:
```swift
AODialogView.shared.show(delegate: self,
                         doneTitle: "Complete",
                         cancelTitle: "X",
                         style: .dateAndTime,
                         enableBackgroundDismiss: true,
                         defaultDate: self.defaultDate,
                         minimumDate: self.dateFormatter.date(from: "01.01.2020, 00:00"),
                         maximumDate: self.dateFormatter.date(from: "01.01.2021, 00:00"),
                         dateFormat: "MM/dd/yyyy, HH:mm",
                         alertStyle: .alert)
```

Analyze some varibles:

Varibles  | Class | Description
------------- | ------------- | ------------
delegate  | AOPickerDelegate | Use for check when clicked to buttons in picker.
doneTitle  | String  | Set done button button. Default = "Done" (Optional)
cancelTitle | String | Set cancel button title. Default = "Cancel" (Optional)
style | enum AODialogStyle | Set picker style - .date - show only date picker, .dateTime - show date & time picker, .time - show only time picker. Default = .dateTime (Optional)
enableBackgroundDismiss | Bool | Enable tap to background for dismiss view. Default = true (Optional)
defaultDate | Date | Set default date for picker. Default = Date(), is current date (Optional)
minimumDate | Date | Set minimum date for picker. Default = nil (Optional)
maximumDate | Date | Set maximum date for picker. Default = nil (Optional)
dateFormat | String | Set format date for picker. Default = "dd.MM.yyyy, HH:mm" (Optional)
alertStyle | AODialogAlertStyle | Choose presentation style for picker. Default = .alert (Optional)

Now, check delegate:
```swift
class ... : AODialogViewDelegate {
    func dialogDidDisappear() {
        // Dialog disappear delegate (if background tap is true)
    }
    
    func doneClicked(selectedDate: Date) {
        // Done button handler with return selected date.
        yourLocalDefaultDateVarible = selectedDate
    }
    
    func cancelClicked() {
        // Cancel button handler
    }
}
```

### To-Do
- [ ] Change constraints for screen rotation.
- [ ] Add 12-hours picker format.
- [ ] Refactor some code.
- [ ] Add example project.

License
----
MIT
