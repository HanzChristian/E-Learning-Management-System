//
//  SoalController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import UIKit

class SoalController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    let tesModel = TesModel()
    var tesName: String?

    
}
    // MARK: - View Life Cycle
extension SoalController{
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tesModel.fetchSpesificTes { [self] tes, error in
            if let error = error{
                return
            }
            
            tesName = tes?.tesName
            setNavItem()
        }
        
        
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension SoalController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = tesName
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tambahkan", style: .plain, target: self, action: #selector(toInputSoal))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc private func toInputSoal(){
        print("segue")
    }
}

    // MARK: - TableView Delegate & Datasource
extension SoalController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
