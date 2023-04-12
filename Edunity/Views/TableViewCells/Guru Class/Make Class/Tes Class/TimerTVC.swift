//
//  TimerTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 12/04/23.
//

import UIKit

class TimerTVC: UITableViewCell {
    
    // MARK: - IBOutlets & Variables
    @IBOutlet weak var timerLbl: UILabel!
    
    let hours = Array(0...23)
    let minutes = Array(0...59)
    let seconds = Array(0...59)
    
    var selectedTimeInterval: Double {
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        let selectedSecond = seconds[pickerView.selectedRow(inComponent: 2)]
        return Double(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
    }
    
    let pickerView = UIPickerView()
}
// MARK: - View LifeCycle
extension TimerTVC{
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override var canResignFirstResponder: Bool{
        return true
    }
    
    override var inputView: UIView? {
        return pickerView
    }
    
    override var inputAccessoryView: UIView? {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.items = [space, doneBtn]
        return toolBar
    }
    
    @objc func dismissPicker() {
        self.endEditing(true)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        pickerView.endEditing(true)
    }
    
}
// MARK: - Private Functions
extension TimerTVC{
    @objc private func doneTapped(){
        timerLbl.resignFirstResponder()
        dismissPicker()
    }
    
    private func convertToString(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval/3600)
        let minutes = Int(timeInterval/60) % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}
// MARK: - PickerView Delegate & Datasource
extension TimerTVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return hours.count
        }else if(component == 1){
            return minutes.count
        }else if(component == 2){
            return seconds.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            let hour = hours[row]
            return "\(hour) jam"
        }
        else if(component == 1){
            let minute = minutes[row]
            return "\(minute) menit"
        }else if(component == 2){
            let second = seconds[row]
            return "\(second) detik"
        }else{
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        let selectedSecond = seconds[pickerView.selectedRow(inComponent: 2)]
        let selectedTimeInterval = TimeInterval(selectedHour * 3600 + selectedMinute * 60 + selectedSecond)
        
        let displayedTime = convertToString(selectedTimeInterval)
        
        timerLbl?.text = displayedTime //display time
    }
    
}
