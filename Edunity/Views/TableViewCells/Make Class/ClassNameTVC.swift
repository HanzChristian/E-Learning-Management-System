//
//  ClassNameTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class ClassNameTVC: UITableViewCell,UITextFieldDelegate {
    
    // MARK: - Variables & Outlets
    
    @IBOutlet weak var classnameTF: UITextField!
    
    @IBAction func returnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.classnameTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            classnameTF.becomeFirstResponder() // Show the keyboard when the cell is selected
        } else {
            classnameTF.resignFirstResponder() // Dismiss the keyboard when the cell is deselected
        }
    }
}
