//
//  AnswerCTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import UIKit

class AnswerCTVC: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var cTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cTF.delegate = self
        // Initialization code
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            cTF.becomeFirstResponder() // Show the keyboard when the cell is selected
        } else {
            cTF.resignFirstResponder() // Dismiss the keyboard when the cell is deselected
        }
    }
    
}
