//
//  TugasTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 06/03/23.
//

import UIKit

class TugasTVC: UITableViewCell {
// MARK: - Variables & IBOutlets
    
    @IBOutlet weak var modultugasLbl: UILabel!
    
    @IBOutlet weak var materitugasLbl: UILabel!
    
// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
