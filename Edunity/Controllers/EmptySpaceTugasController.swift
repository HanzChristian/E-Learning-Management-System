//
//  EmptySpaceTugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 12/04/23.
//

import UIKit

class EmptySpaceTugasController:UIViewController{
    // MARK: - Variables & Outlet
    
}
    // MARK: - View Life Cycle
extension EmptySpaceTugasController{
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hiddenTugas"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhiddenTugas"), object: nil)
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension EmptySpaceTugasController{
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }

    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}
