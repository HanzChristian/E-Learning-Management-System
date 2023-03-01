//
//  ProfileController.swift
//  skripsi
//
//  Created by Hanz Christian on 01/03/23.
//

import UIKit

class ProfileController: UIViewController {
    
    // MARK: - Variables & Outlet
}
    // MARK: - View Life Cycle
extension ProfileController{
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
}
    // MARK: - IBActions
extension ProfileController{
    @IBAction func namechangePressed(_ sender: UIButton) {
    }
    
    @IBAction func emailchangePressed(_ sender: UIButton) {
    }
    
    @IBAction func passwordchangePressed(_ sender: UIButton) {
    }
    
    @IBAction func quitPressed(_ sender: UIButton) {
        showAlert()
    }
}
    // MARK: - Private/Functions
extension ProfileController{
    func showAlert(){
        let alert = UIAlertController(title: "Keluar dari Aplikasi?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .default,handler:{_ in
            print("keluar")
        }))
        
        alert.addAction(UIAlertAction(title: "Ya", style: .destructive,handler:{_ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnBoardingController") as! OnBoardingController
            vc.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc,animated:true)
        }))
        
        present(alert,animated:true)
    }
}
