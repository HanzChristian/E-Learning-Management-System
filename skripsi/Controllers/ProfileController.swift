//
//  ProfileController.swift
//  skripsi
//
//  Created by Hanz Christian on 01/03/23.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var shortnameLbl: UILabel!
    var userName: String?
    var shortenName: String?
    var userModel = UserModel()
}
    // MARK: - View Life Cycle
extension ProfileController{
    override func viewDidLoad(){
        super.viewDidLoad()
        self.userModel.fetchUser{ [self] user in
            userName = user.name
            print("ini username pas fetch = \(userName)")
        }
    
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
}
