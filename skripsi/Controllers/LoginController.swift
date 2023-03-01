//
//  LoginController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
}
// MARK: - View Life Cycle
extension LoginController{
    override func viewDidLoad(){
        super.viewDidLoad()
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
    }
}
// MARK: - IBActions
extension LoginController{
    @IBAction func loginPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "homepageSegue", sender: self)
    }
    
}

// MARK: - Private/Functions


