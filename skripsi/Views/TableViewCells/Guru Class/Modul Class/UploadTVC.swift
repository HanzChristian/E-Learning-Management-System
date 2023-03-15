//
//  UploadTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 07/03/23.
//

import UIKit

class UploadTVC: UITableViewCell {
// MARK: - IBOutlets & Variables
    
    @IBOutlet weak var filenameLbl: UIButton!
    
    var importFile: (() -> Void)?
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
// MARK: - Functions
extension UploadTVC{
    @IBAction func uploadPressed(_ sender: UIButton) {
        importFile?()
    }
}
