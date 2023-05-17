//
//  DescTesTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import UIKit

class TesDescriptionTVC: UITableViewCell,UITextViewDelegate {

    @IBOutlet weak var tesDescTF: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tesDescTF.delegate = self
        // Initialization code
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
