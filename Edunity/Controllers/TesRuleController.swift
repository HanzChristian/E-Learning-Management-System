//
//  TesRuleController.swift
//  skripsi
//
//  Created by Hanz Christian on 09/04/23.
//

import Foundation
import UIKit

class TesRuleController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var namaTesLbl: UILabel!
    @IBOutlet weak var descTesLbl: UILabel!
    var tesModel = TesModel()
    var tesName: String?
    var tesDesc: String?
    
    
}
extension TesRuleController{
    // MARK: - View Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tesModel.fetchTesInModul { [self] tes, error in
            tesName = tes?.tesName
            tesDesc = tes?.tesDesc
            
            namaTesLbl.text = tesName
            descTesLbl.text = tesDesc
        }
        
    }
}
    // MARK: - IBActions
extension TesRuleController{
    @IBAction func tesPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Kamu yakin ingin memulai tes?", message: "Jika sudah mulai maka timer akan berjalan dan anda tidak dapat keluar sampai menyelesaikan tes!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler:{_ in
            print("keluar")
        }))
        
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler:{ [self]_ in
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DoTesController") as! DoTesController
            let nav =  UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        let attributedString = NSAttributedString(string: "Jika sudah mulai maka timer akan berjalan dan anda tidak dapat keluar sampai menyelesaikan tes!", attributes: attributes)
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        present(alert,animated:true)
    }
    
    @IBAction func kembaliPressed(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    
}
    // MARK: - Private/Functions
