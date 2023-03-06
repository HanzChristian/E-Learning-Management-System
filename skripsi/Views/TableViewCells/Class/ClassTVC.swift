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
    @IBOutlet weak var shadowView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowView.layer.shadowOffset = CGSizeMake(0, 2.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 5.0
        shadowView.layer.shadowRadius = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupClass(_ kelas: Kelas){
        classImg.image = kelas.classImg
        classtitleLbl.text = kelas.className
        classmodulLbl.text = kelas.classModule
        classenrollmentkeyLbl.text = kelas.classEnrollment
    }
    
}
