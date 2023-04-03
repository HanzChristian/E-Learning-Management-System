//
//  ClassDescriptionTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class ClassDescriptionTVC: UITableViewCell {
// MARK: - Variables & Outlets
    
    @IBOutlet weak var classdescTF: UITextView!
    
// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @objc func txtFieldEdit(_ textField:UITextView){
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "validateInput"), object: nil)
//    }
    
}
