//
//  QuestionTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import UIKit

class QuestionTVC: UITableViewCell {

    
    @IBOutlet weak var questionTF: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
