//
//  CustomTextField.swift
//  skripsi
//
//  Created by Hanz Christian on 28/02/23.
//

import Foundation
import UIKit

class CustomTextField: UITextField{

    // MARK: - View Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUnderlinedTextField()
    }
    
    // MARK: - Private/Functions
    func setupUnderlinedTextField(){
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width - 20, height: 1)
        bottomLayer.backgroundColor = UIColor.systemGray.cgColor
        bottomLayer.opacity = 0.5
        self.layer.addSublayer(bottomLayer)
    }
}
