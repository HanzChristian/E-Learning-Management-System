//
//  UIView+Extension.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRadius: CGFloat{
        get{
            return cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}
