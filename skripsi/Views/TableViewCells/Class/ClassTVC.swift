//
//  ClassTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 05/03/23.
//

import UIKit

class ClassTVC: UITableViewCell {

// MARK: - Variables & IBOutlets

    @IBOutlet weak var classImg: UIImageView!
    @IBOutlet weak var classtitleLbl: UILabel!
    @IBOutlet weak var classmodulLbl: UILabel!
    @IBOutlet weak var classenrollmentkeyLbl: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
