//
//  EmptySpaceController.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class EmptySpaceController: UIViewController {
    
    // MARK: - Variables & Outlet
    let role = UserDefaults.standard.string(forKey: "role")
    @IBOutlet weak var findclassBtn: UIButton!
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if(role == "pelajar"){
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
        if(role == "pengajar"){ //pengajar
            if let attrFont = UIFont(name: "Helvetica-Bold", size: 18) {
                      let title = "BENTUK KELAS"
                      let attrTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: attrFont])
                      findclassBtn.setAttributedTitle(attrTitle, for: UIControl.State.normal)
                  }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableHidden), name: NSNotification.Name(rawValue: "hidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.unableHidden), name: NSNotification.Name(rawValue: "unhidden"), object: nil)
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension EmptySpaceController{
    @objc func enableHidden(){
        view.frame = self.view.bounds
        view.isHidden = true
    }

    @objc func unableHidden(){
        view.frame = self.view.bounds
        view.isHidden = false
    }
}

