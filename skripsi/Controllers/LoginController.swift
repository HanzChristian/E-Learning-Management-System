//
//  LoginController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginController: UIViewController {
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var errorLbl: UILabel!
    var userModel = UserModel()
}
// MARK: - View Life Cycle
extension LoginController{
    override func viewDidLoad(){
        super.viewDidLoad()
        //dismiss gesture
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        
        errorLbl.alpha = 0
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
        
        // Validate Text Fields
        let error = validateFields()
        
        if error != nil{
            //if error
            showError(error!)
        }else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Sign In
            Auth.auth().signIn(withEmail: email, password: pass){
                (results,error) in
                
                if error != nil{
                    self.showError("Email/Password yang dimasukkan belum benar!")
                }else{
                    self.userModel.fetchUser{user in
                        var userRole = user.role
                        UserDefaults.standard.set(userRole, forKey: "role")
                        print("fetchuser 1")
                        self.performSegue(withIdentifier: "homepageSegue", sender: self)
                    }
                }
            }
        }
    }
    
}

// MARK: - Private/Functions
extension LoginController{
    
    //Validate the data is correct or not, if correct = nil, otherwise = error message
    func validateFields() -> String?{
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Masukkan Semua field yang ada!"
        }
        return nil
    }
    
    func showError(_ message:String){
        errorLbl.text = message
        errorLbl.alpha = 1
    }
}


