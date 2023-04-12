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
    var tesMuridModel = TesMuridModel()
    var tesName: String?
    var listofTes = [TesMurid]()
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
        
        fetchData()
    
        
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
    
    private func fetchData(){
        tesMuridModel.fetchHasilTes { [self] tes, error in
            if let error = error{
                return
            }
            listofTes.append(tes!)
            tableView.reloadData()
        }
    }
}

// MARK: - TableView Delegate & Datasource
extension KumpulanTesController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofTes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachTes = listofTes[indexPath.row]
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KumpulanTesTVC
            cell.namaLbl.text = eachTes.muridName
            cell.nilaiLbl.text = "\(eachTes.tesScore)"
            
            return cell
        }
    
        return UITableViewCell()
    }
}
