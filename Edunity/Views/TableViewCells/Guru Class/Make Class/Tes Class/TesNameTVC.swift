//
//  NamaTesTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import UIKit

class TesNameTVC: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var tesNameTV: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tesNameTV.delegate = self
        // Initialization code
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            tesNameTV.becomeFirstResponder() // Show the keyboard when the cell is selected
        } else {
            tesNameTV.resignFirstResponder() // Dismiss the keyboard when the cell is deselected
        }
    }
    
}
