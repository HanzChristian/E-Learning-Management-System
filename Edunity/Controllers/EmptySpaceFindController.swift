//
//  EmptySpaceFindController.swift
//  skripsi
//
//  Created by Hanz Christian on 24/03/23.
//

import Foundation
import UIKit

class EmptySpaceFindController:UIViewController{
    // MARK: - Variables & Outlet
    
}
    // MARK: - View Life Cycle
extension EmptySpaceFindController{
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hiddenFind"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhiddenFind"), object: nil)
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension EmptySpaceFindController{
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }

    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}
