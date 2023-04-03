//
//  PengumpulanTugasTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 14/03/23.
//

import UIKit

class PengumpulanTugasTVC: UITableViewCell {

    var importFile: (() -> Void)?
    
    @IBOutlet weak var kumpultugasLbl: UIButton!
    @IBAction func kumpultugasPressed(_ sender: UIButton) {
        importFile?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
