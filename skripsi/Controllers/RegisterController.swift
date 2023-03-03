//
//  RegisterController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit

class RegisterController: UIViewController {
    
// MARK: - Variables & Outlet
    
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
//    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.editin))
    
}
// MARK: - View Life Cycle
extension RegisterController{
    override func viewDidLoad(){
        super.viewDidLoad()
        namaTextField.attributedPlaceholder = NSAttributedString(
            string: "Nama",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
    }
}

// MARK: - IBActions
extension RegisterController{
    @IBAction func segmentChange(_ sender: UISegmentedControl){
        // 0 = pelajar , 1 = pengajar
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(0, forKey: "role")
        }
        else{
            UserDefaults.standard.set(1, forKey: "role")
        }
    }
    @IBAction func registerPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "homepageSegue", sender: self)
    }
}



// MARK: - Private/Functions


