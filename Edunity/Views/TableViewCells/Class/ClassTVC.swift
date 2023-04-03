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
    @IBOutlet weak var potonganView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hiddenView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhiddenView"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func enableHidden(){
        potonganView.frame = self.potonganView.bounds
        potonganView.isHidden = false
    }
    @objc func unableHidden(){
        potonganView.frame = self.potonganView.bounds
        potonganView.isHidden = false
    }
    
//    func setupClass(_ kelas: Class){
//        classImg.image = kelas.classImg
//        classtitleLbl.text = kelas.className
//        classmodulLbl.text = kelas.classModule
//        classenrollmentkeyLbl.text = kelas.classEnrollment
//    }
//    
}
