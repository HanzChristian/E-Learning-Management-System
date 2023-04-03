//
//  UserDefaults+Extension.swift
//  skripsi
//
//  Created by Hanz Christian on 28/02/23.
//

import Foundation
import UIKit

extension UserDefaults {
    private enum UserDefaultsKeys: String{
        case hasOnboarded
    }
    
    var hasOnboarded: Bool{
        get{
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        set{
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
    
    // nanti panggilnya tinggal UserDefaults.standard.hasOnboarded = true
    // ke func pas register
}
