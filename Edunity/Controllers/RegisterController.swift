//
//  RegisterController.swift
//  skripsi
//
//  Created by Hanz Christian on 27/02/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseMessaging

class RegisterController: UIViewController {
    
// MARK: - Variables & Outlet
    
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var revealPassword: UIButton!
    
    var toogle = false
    
}
// MARK: - View Life Cycle
extension RegisterController:UITextFieldDelegate{
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //dismiss gesture
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        
        self.namaTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        errorLbl.alpha = 0
        UserDefaults.standard.set("pelajar", forKey: "role")
        namaTextField.attributedPlaceholder = NSAttributedString(
            string: "Nama Lengkap",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 0.6)])
        revealPassword.addTarget(self, action: #selector(revealTapped), for: .touchUpInside)
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
                            let alert = UIAlertController(title: "Akun berhasil terdaftar!", message: "", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler:{_ in
                                self.performSegue(withIdentifier: "toLogin", sender: self)
                            }))
                            
                            self.present(alert,animated: true)
                        }
                    }
                }
            }
            
            
        }
    }
}



// MARK: - Private/Functions
extension RegisterController{
    
    @objc private func revealTapped() {
            passwordTextField.isSecureTextEntry.toggle()

        if(toogle == false){
            toogle = true
            revealPassword.setImage(UIImage(systemName: "eye"), for: .normal)
        }else{
            toogle = false
            revealPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
      }
    //Validate the data is correct or not, if correct = nil, otherwise = error message
    func validateFields() -> String?{
        if namaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Masukkan Semua field yang ada!"
        }
        
        //check password & username
        let finalPassword =  passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalName = namaTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if RegisterController.isPasswordValid(finalPassword) == false{
            //password not secured
            return "Pastikan passwordmu memiliki setidaknya 1 huruf dan memmiliki panjang minimal 6 karakter!"
        }
        
        if RegisterController.isNameValid(finalName) == false{
            return "Pastikan namamu memiliki setidaknya 1 karakter besar!"
        }
        
        return nil
    }
    
    // Regex to check if the password has atleast 6 chars
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-zA-Z]).{6,}$")
        return passwordTest.evaluate(with: password)
    }
    
    // Regex to check if Username has atleast 1 Upper Case
    static func isNameValid(_ name : String) -> Bool{
        let nameTest = "(?s)[^A-Z]*[A-Z].*"
        return NSPredicate(format: "SELF MATCHES %@", nameTest).evaluate(with: name)
    }
    
    func showError(_ message:String){
        errorLbl.text = message
        errorLbl.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
