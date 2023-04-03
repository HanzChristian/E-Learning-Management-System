//
//  KumpulanTugasTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 09/03/23.
//

import UIKit

class KumpulanTugasTVC: UITableViewCell {

// MARK: - Variables & IBOutlets
    
    @IBOutlet weak var tanggalLbl: UILabel!
    
    @IBOutlet weak var namaLbl: UILabel!
    
    @IBOutlet weak var fileBtn: UIButton!
    var downloadPDF: (() -> Void)?
    
// MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
// MARK: - Functions & IBActions
    @IBAction func filebtnPressed(_ sender: UIButton) {
        downloadPDF?()
    }
    
}
