//
//  AnswerDTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import UIKit

class AnswerDTVC: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var dTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dTF.delegate = self
        // Initialization code
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            dTF.becomeFirstResponder() // Show the keyboard when the cell is selected
        } else {
            dTF.resignFirstResponder() // Dismiss the keyboard when the cell is deselected
        }
    }
    
}
