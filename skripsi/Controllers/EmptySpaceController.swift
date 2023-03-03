//
//  EmptySpaceController.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class EmptySpaceController: UIViewController {
    
    // MARK: - Variables & Outlet
    let role = UserDefaults.standard.integer(forKey: "role")
    @IBOutlet weak var findclassBtn: UIButton!
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if(role == 0){
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FindClassController") as! FindClassController
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MakeClassController") as! MakeClassController
            vc.modalPresentationStyle = .automatic
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
    }
}
    
    // MARK: - View Life Cycle
extension EmptySpaceController{
    override func viewDidLoad(){
        super.viewDidLoad()
        if(role == 1){ //pengajar
            findclassBtn.setTitle("BENTUK KELAS", for: .normal)
            findclassBtn.titleLabel?.minimumScaleFactor = 0.5
            findclassBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            findclassBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        }
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions

