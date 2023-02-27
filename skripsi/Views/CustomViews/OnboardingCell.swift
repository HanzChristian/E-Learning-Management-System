//
//  OnboardingCell.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
        func setup(_ pages: OnboardingPages){
        imgView.image = pages.image
        titleLbl.text = pages.title
        descLbl.text = pages.description
    }
    
}
