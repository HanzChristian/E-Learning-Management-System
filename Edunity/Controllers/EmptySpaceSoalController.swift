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
