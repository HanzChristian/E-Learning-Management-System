//
//  FindClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 01/03/23.
//

import UIKit

class FindClassController: UIViewController {
    // MARK: - Variables & Outlet
}

    // MARK: - View Life Cycle
extension FindClassController{
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavItem()
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension FindClassController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Cari Kelasku"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc private func saveItem(){
        //isi save data
        print("Saved")
    }
}
