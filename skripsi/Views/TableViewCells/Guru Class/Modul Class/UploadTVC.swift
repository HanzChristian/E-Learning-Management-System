//
//  UploadTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 07/03/23.
//

import UIKit

class UploadTVC: UITableViewCell {
// MARK: - IBOutlets & Variables

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
//        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
//              documentPicker.delegate = self
//              documentPicker.allowsMultipleSelection = false
//              present(documentPicker, animated: true, completion: nil)
    }
}
