//
//  RegisterController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterController: UIViewController {
    
// MARK: - Variables & Outlet
    
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    

//    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.editin))
    
}
// MARK: - View Life Cycle
extension RegisterController{
    override func viewDidLoad(){
        super.viewDidLoad()
        errorLbl.alpha = 0
        UserDefaults.standard.set("pelajar", forKey: "role")
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
            UserDefaults.standard.set("pelajar", forKey: "role")
        }
        else{
            UserDefaults.standard.set("pengajar", forKey: "role")
        }
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil{
            //if error
            showError(error!)
        }else{
            
            let name = namaTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let roles = UserDefaults.standard.string(forKey: "role")
            
            //make User
            Auth.auth().createUser(withEmail: email, password: pass){ (results,err) in
                //check error
                if err != nil{
                    self.showError("Error dalam membuat user!")
                }
                else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: [
                        "name":"\(name)",
                        "role":"\(roles!)",
                        "uid":results!.user.uid]){ (error) in
                        
                        if error != nil{
                            self.showError("Nama ataupun role tidak terdaftarkan!\n")
                            self.showError(error!.localizedDescription)
                        }
                        else{
                            self.performSegue(withIdentifier: "homepageSegue", sender: self)
                        }
                    }
                    
                    
                }
                
            }
            
        }
    }
}



// MARK: - Private/Functions
extension RegisterController{
    
    //Validate the data is correct or not, if correct = nil, otherwise = error message
    func validateFields() -> String?{
        if namaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Masukkan Semua field yang ada!"
        }
        
        //check password
        let finalPassword =  passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if RegisterController.isPasswordValid(finalPassword) == false{
            //password not secured
            return "Pastikan passwordmu memiliki setidaknya 6 karakter!"
        }
        
        return nil
    }
    
    // Regex to check if the password has atleast 6 chars
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.[a-z]).{6,}$")
        return passwordTest.evaluate(with: password)
    }
    
    func showError(_ message:String){
        errorLbl.text = message
        errorLbl.alpha = 1
    }
}
