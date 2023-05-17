//
//  AnswerATVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import UIKit

class AnswerATVC: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var aTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.aTF.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        return true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            aTF.becomeFirstResponder() // Show the keyboard when the cell is selected
        } else {
            aTF.resignFirstResponder() // Dismiss the keyboard when the cell is deselected
        }
    }
    
}
