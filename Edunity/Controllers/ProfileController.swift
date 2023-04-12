//
//  ProfileController.swift
//  skripsi
//
//  Created by Hanz Christian on 01/03/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileController: UIViewController {
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var shortnameLbl: UILabel!
    
    @IBOutlet weak var changeLbl: UILabel!
    
    var userName: String?
    var shortenName: String?
    var userModel = UserModel()
    let db = Firestore.firestore()
}
    // MARK: - View Life Cycle
extension ProfileController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        changeLbl.alpha = 0
        
        self.userModel.fetchUser{ [self] user in
            userName = user.name
            
            toShortenName()
            nameLbl.text = userName
            shortnameLbl.text = shortenName
        }
        
    }
}
    // MARK: - IBActions
extension ProfileController{
    @IBAction func namechangePressed(_ sender: UIButton) {
        showAlertName()
    }
    
    @IBAction func emailchangePressed(_ sender: UIButton) {
        showAlertEmail()
    }
    
    @IBAction func passwordchangePressed(_ sender: UIButton) {
        showAlertPassword()
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
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OnBoardingController") as! OnBoardingController
                vc.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc,animated:true)
                UserDefaults.standard.removeObject(forKey: "isNewUser")
            }
            catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }))
        
        present(alert,animated:true)
    }
    
    func toShortenName(){
        //Make an array of uppercase string
        let uppercaseChars = userName!.filter { $0.isUppercase }
        
        //Make the array into string
        shortenName = String(uppercaseChars)
        
    }
    
    func showAlertName(){
        let alert = UIAlertController(title: "Ubah Nama", message: "Masukkan Nama yang baru!", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Nama Baru"
            field.returnKeyType = .done
        }
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler: { [self]_ in
            
            guard let fields = alert.textFields,fields.count == 1 else{
                return
            }
            let nameField = fields[0]
            let name = nameField.text
            
            if(name != nil){
                self.db.collection("users")
                    .whereField("name", isEqualTo: userName)
                    .addSnapshotListener { (querySnapshot, err) in
                        if let err = err {
                            showRedLbl(text: "Nama gagal diubah!")
                            // Some error occured
                        }else {
                            if let document = querySnapshot!.documents.first {
                                document.reference.updateData([
                                    "name": name
                                ])
                                showBlueLbl(text: "Nama telah berhasil diubah!")
                                self.nameLbl.text = name
                                self.shortnameLbl.text = String(name!.filter { "A"..."Z" ~= $0 }.prefix(2))
                                
                            } else {
                                showBlueLbl(text: "Nama telah berhasil diubah!")
                                self.nameLbl.text = name
                                self.shortnameLbl.text = String(name!.filter { "A"..."Z" ~= $0 }.prefix(2))
                            }
                        }
                    }
                
                self.dismiss(animated: true,completion: nil)
            }
            else{
                print("masuk bawah")
                showRedLbl(text: "Nama kosong/sama seperti sebelumnya!")
                self.dismiss(animated: true,completion: nil)
            }
        }))
        present(alert,animated:true)
    }
    
    func showAlertEmail(){
        let alert = UIAlertController(title: "Ubah Email", message: "Masukkan Email yang baru!", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Email Baru"
            field.returnKeyType = .done
        }
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler: { [self]_ in
            
            guard let fields = alert.textFields,fields.count == 1 else{
                return
            }
            let emailField = fields[0]
            let email = emailField.text

            let currentUser = Auth.auth().currentUser
            
            if(email != nil){
                currentUser?.updateEmail(to: email!){ error in
                    if let error = error{
                        print("error update email \(error)")
                        showRedLbl(text: "Email gagal diubah, coba login ulang!")
                    }else{
                        showBlueLbl(text: "Email telah berhasil diubah!")
                    }
                }
                self.dismiss(animated: true,completion: nil)
            }
            else{
                showRedLbl(text: "Email kosong!")
                print("Email kosong!")
            }
            
           
        }))
        present(alert,animated:true)
    }
    
    func showAlertPassword(){
        let alert = UIAlertController(title: "Ubah Password", message: "Masukkan Password yang baru!", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Password Baru"
            field.returnKeyType = .done
            field.isSecureTextEntry = true
        }

        
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler: { [self]_ in
            
            guard let fields = alert.textFields,fields.count == 1 else{
                return
            }
            let passwordField = fields[0]
            
            let password = passwordField.text
            
            
            let currentUser = Auth.auth().currentUser
        
            if(password != nil || RegisterController.isNameValid(password!) != false){
                currentUser?.updatePassword(to: password!){ error in
                    if let error = error{
                        print("error update password \(error)")
                        showRedLbl(text: "Password kosong/minimal masukkan 6 karakter!")
                    }else{
                        print("masuk ke animasi uiview")
                        showBlueLbl(text: "Password telah berhasil diubah!")
                        self.dismiss(animated: true,completion: nil)
                    }
                
                }
            }
        }))
            
        present(alert,animated:true)
    }
    
    func showBlueLbl(text: String){
        UIView.animate(withDuration: 2.0, animations: { [self] in
            changeLbl.text = text
            changeLbl.alpha = 1.0
        }) { (finished) in
            // Fade out animation
            UIView.animate(withDuration: 5.0, animations: { [self] in
                changeLbl.alpha = 0.0
            }) { [self] (finished) in
                // Animation complete
            }
        }
    }
    
    func showRedLbl(text: String){
        UIView.animate(withDuration: 2.0, animations: { [self] in
            changeLbl.text = text
            changeLbl.textColor = .red
            changeLbl.alpha = 1.0
        }) { (finished) in
            // Fade out animation
            UIView.animate(withDuration: 5.0, animations: { [self] in
                changeLbl.alpha = 0.0
            }) { [self] (finished) in
                // Animation complete
            }
        }
    }
    
}
