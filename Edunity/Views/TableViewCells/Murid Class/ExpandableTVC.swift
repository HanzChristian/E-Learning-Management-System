//
//  ExpandableTVC.swift
//  skripsi
//
//  Created by Hanz Christian on 12/03/23.
//

import UIKit

// MARK: - Variables & IBOutlets
class ExpandableTVC: UITableViewCell {
    var makeSheet: (() -> Void)?
    var downloadPDF: (() -> Void)?
    @IBOutlet weak var modulNumLbl: UILabel!
    @IBOutlet weak var modulNameLbl: UILabel!
    @IBOutlet weak var modulDescLbl: UILabel!
    @IBOutlet weak var modulPdfBtn: UIButton!
    @IBOutlet weak var tugasBtn: UIButton!
    
    @IBAction func tugasPressed(_ sender: UIButton) {
        makeSheet?()
    }
    
    @IBAction func pdfPressed(_ sender: UIButton) {
        downloadPDF?()
    }
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
// MARK: - Functions
//    func setupExpandable(_ modul: Modul){
//        modulNumLbl.text = modul.modulNum
//        modulNameLbl.text = modul.modulName
//        modulDescLbl.text = modul.modulDesc
//    }
    func animate(){
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1,options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
}
