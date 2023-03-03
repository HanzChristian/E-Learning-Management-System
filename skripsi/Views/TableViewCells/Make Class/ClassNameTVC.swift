//
//  ClassNameTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class ClassNameTVC: UITableViewCell {

// MARK: - Variables & Outlets
    
    @IBOutlet weak var classnameTF: UITextField!
// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        classnameTF.addTarget(self, action: #selector(txtFieldEdit(_:)), for: .editingChanged)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func txtFieldEdit(_ textField:UITextField){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "validateInput"), object: nil)
    }
    
}
