//
//  EmptySpaceTesController.swift
//  skripsi
//
//  Created by Hanz Christian on 12/04/23.
//

import Foundation
import UIKit

class EmptySpaceTesController:UIViewController{
    // MARK: - Variables & Outlet
    
}
    // MARK: - View Life Cycle
extension EmptySpaceTesController{
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hiddenTes"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhiddenTes"), object: nil)
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension EmptySpaceTesController{
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }

    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}
