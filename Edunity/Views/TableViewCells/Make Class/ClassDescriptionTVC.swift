//
//  ClassDescriptionTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class ClassDescriptionTVC: UITableViewCell,UITextViewDelegate {
// MARK: - Variables & Outlets
    
    @IBOutlet weak var classdescTF: UITextView!
    
// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.classdescTF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
