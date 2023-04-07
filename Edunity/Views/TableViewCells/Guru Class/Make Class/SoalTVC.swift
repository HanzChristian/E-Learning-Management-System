//
//  SoalTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 07/04/23.
//

import UIKit

class SoalTVC: UITableViewCell {

    @IBOutlet weak var soalLbl: UILabel!
    @IBOutlet weak var pertanyaanLbl: UILabel!
    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var jawabanLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
