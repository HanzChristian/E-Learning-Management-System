//
//  EmptySpaceGuruController.swift
//  skripsi
//
//  Created by Hanz Christian on 24/03/23.
//

import Foundation
import UIKit

class EmptySpaceGuruController:UIViewController{
    // MARK: - Variables & Outlet
    
}
// MARK: - View Life Cycle
extension EmptySpaceGuruController{
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hiddenGuru"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhiddenGuru"), object: nil)
    }
}
// MARK: - IBActions
extension EmptySpaceGuruController{
    @IBAction func btnPressed(_ sender: UIButton) {
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ModulController") as! ModulController
            vc.modalPresentationStyle = .pageSheet
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
    }
}
// MARK: - Private/Functions
extension EmptySpaceGuruController{
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }

    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}
