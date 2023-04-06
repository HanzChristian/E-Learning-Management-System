//
//  EmptySpaceSoalController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import UIKit

class EmptySpaceSoalController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBAction func btnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MakeSoalController") as! MakeSoalController
        vc.modalPresentationStyle = .fullScreen
        let nav =  UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
}
    // MARK: - View Life Cycle
extension EmptySpaceSoalController{
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hiddenSoal"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhiddenSoal"), object: nil)
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension EmptySpaceSoalController{
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }

    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}
