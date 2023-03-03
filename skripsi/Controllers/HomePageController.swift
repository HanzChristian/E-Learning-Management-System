//
//  HomePageController.swift
//  skripsi
//
//  Created by Hanz Christian on 28/02/23.
//

import UIKit

class HomePageController: UIViewController {
    
    // MARK: - Variables & Outlet
    let role = UserDefaults.standard.integer(forKey: "role")
    
    @IBOutlet weak var findclassBtn: UIButton!
    
}

// MARK: - View Life Cycle

extension HomePageController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if(role == 1){ //pengajar
            findclassBtn.setTitle("Bentuk Kelas", for: .normal)
            findclassBtn.titleLabel?.minimumScaleFactor = 0.5
            findclassBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            findclassBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        }
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension HomePageController{
    @IBAction func btnPressed(_ sender: UIButton) {
        if (role == 0){
            performSegue(withIdentifier: "findclassSegue", sender: nil)
        }else{
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MakeClassController") as! MakeClassController
            vc.modalPresentationStyle = .automatic
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
        
    }
}
