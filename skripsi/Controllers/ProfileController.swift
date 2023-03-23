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
    
    override func viewWillAppear(_ animated: Bool) {
        self.userModel.fetchUser{ [self] user in
            userName = user.name
            print("ini username pas fetch = \(userName)")
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        changeLbl.alpha = 0
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            toShortenName()
            nameLbl.text = userName
            shortnameLbl.text = shortenName
            
            print("ini username = \(userName)")
            print("ini shortname = \(shortenName)")
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
            
            print("INI NAMA SEBELUM = \(userName) dan ini nama diubah = \(name)")
            if(name != nil){
                print("masuk atas")
                self.db.collection("users")
                    .whereField("name", isEqualTo: userName)
                    .addSnapshotListener { (querySnapshot, err) in
                        if let err = err {
                            UIView.animate(withDuration: 3.0, animations: { [self] in
                                changeLbl.text = "Nama gagal berubah!"
                                changeLbl.textColor = .red
                                changeLbl.alpha = 1.0
                            }) { (finished) in
                                // Fade out animation
                                UIView.animate(withDuration: 3.0, animations: { [self] in
                                    changeLbl.alpha = 0.0
                                }) { [self] (finished) in
                                    // Animation complete
                                }
                            }
                            // Some error occured
                        } else if querySnapshot!.documents.count != 1 {
                        } else {
                            let document = querySnapshot!.documents.first
                            document!.reference.updateData([
                                "name": name
                            ])
                            //Make label changes
                            UIView.animate(withDuration: 3.0, animations: { [self] in
                                changeLbl.text = "Nama telah berhasil diubah!"
                                changeLbl.alpha = 1.0
                            }) { (finished) in
                                // Fade out animation
                                UIView.animate(withDuration: 3.0, animations: { [self] in
                                    changeLbl.alpha = 0.0
                                }) { [self] (finished) in
                                    // Animation complete
                                }
                            }
                        }
                    }
                
                self.dismiss(animated: true,completion: nil)
            }
            else{
                print("masuk bawah")
                UIView.animate(withDuration: 3.0, animations: { [self] in
                    changeLbl.text = "Nama kosong/sama seperti sebelumnya!"
                    changeLbl.textColor = .red
                    changeLbl.alpha = 1.0
                }) { (finished) in
                    // Fade out animation
                    UIView.animate(withDuration: 3.0, animations: { [self] in
                        changeLbl.alpha = 0.0
                    }) { [self] (finished) in
                        // Animation complete
                    }
                }
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
                        UIView.animate(withDuration: 3.0, animations: { [self] in
                            changeLbl.text = "Email gagal berubah!"
                            changeLbl.textColor = .red
                            changeLbl.alpha = 1.0
                        }) { (finished) in
                            // Fade out animation
                            UIView.animate(withDuration: 3.0, animations: { [self] in
                                changeLbl.alpha = 0.0
                            }) { [self] (finished) in
                                // Animation complete
                            }
                        }
                    }else{
                        UIView.animate(withDuration: 3.0, animations: { [self] in
                            changeLbl.text = "Email telah berhasil diubah!"
                            changeLbl.alpha = 1.0
                        }) { (finished) in
                            // Fade out animation
                            UIView.animate(withDuration: 3.0, animations: { [self] in
                                changeLbl.alpha = 0.0
                            }) { [self] (finished) in
                                // Animation complete
                            }
                        }
                    }
                }
                
                self.dismiss(animated: true,completion: nil)
            }
            else{
                UIView.animate(withDuration: 3.0, animations: { [self] in
                    changeLbl.text = "Email kosong!"
                    changeLbl.textColor = .red
                    changeLbl.alpha = 1.0
                }) { (finished) in
                    // Fade out animation
                    UIView.animate(withDuration: 3.0, animations: { [self] in
                        changeLbl.alpha = 0.0
                    }) { [self] (finished) in
                        // Animation complete
                    }
                }
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
            
            if(password != nil){
                currentUser?.updatePassword(to: password!){ error in
                    if let error = error{
                        print("error update password \(error)")
                        UIView.animate(withDuration: 3.0, animations: { [self] in
                            changeLbl.text = "Password gagal masuk!"
                            changeLbl.textColor = .red
                            changeLbl.alpha = 1.0
                        }) { (finished) in
                            // Fade out animation
                            UIView.animate(withDuration: 3.0, animations: { [self] in
                                changeLbl.alpha = 0.0
                            }) { [self] (finished) in
                                // Animation complete
                            }
                        }
                    }else{
                        print("masuk ke animasi uiview")
                        UIView.animate(withDuration: 3.0, animations: { [self] in
                            changeLbl.text = "Password telah berhasil diubah!"
                            changeLbl.alpha = 1.0
                        }) { (finished) in
                            // Fade out animation
                            UIView.animate(withDuration: 3.0, animations: { [self] in
                                changeLbl.alpha = 0.0
                            }) { [self] (finished) in
                                // Animation complete
                            }
                        }
                    }
                
                }
                self.dismiss(animated: true,completion: nil)
            }
            else{
                UIView.animate(withDuration: 3.0, animations: { [self] in
                    changeLbl.text = "Password kosong!"
                    changeLbl.textColor = .red
                    changeLbl.alpha = 1.0
                }) { (finished) in
                    // Fade out animation
                    UIView.animate(withDuration: 3.0, animations: { [self] in
                        changeLbl.alpha = 0.0
                    }) { [self] (finished) in
                        // Animation complete
                    }
                }
                print("Password kosong!")
            }
            
           
        }))
            
        present(alert,animated:true)
    }
}
