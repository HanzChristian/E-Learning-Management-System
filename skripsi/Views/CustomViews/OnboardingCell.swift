//
//  OnboardingCell.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit

// MARK: - Variables/Outlets
//Variables
class OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
}

// MARK: - Functions
extension OnboardingCell{
    func setup(_ pages: OnboardingPages){
        imgView.image = pages.image
        titleLbl.text = pages.title
        descLbl.text = pages.description
    }
}
