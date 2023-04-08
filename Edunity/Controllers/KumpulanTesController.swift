//
//  KumpulanTesController.swift
//  skripsi
//
//  Created by Hanz Christian on 08/04/23.
//

import Foundation
import UIKit

class KumpulanTesController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    var tesModel = TesModel()
    var tesName: String?
}
extension KumpulanTesController{
    // MARK: - View Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tesModel.fetchSpesificTes { [self] tes, error in
            tesName = tes?.tesName
            setNavItem()
        }
        
    }
}

// MARK: - Private/Functions
extension KumpulanTesController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Kumpulan nilai \(tesName!)"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
}

// MARK: - TableView Delegate & Datasource
extension KumpulanTesController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KumpulanTesTVC
            return cell
        }
    
        return UITableViewCell()
    }
}
