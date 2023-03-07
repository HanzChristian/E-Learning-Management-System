//
//  ModulController.swift
//  skripsi
//
//  Created by Hanz Christian on 07/03/23.
//

import UIKit

class ModulController: UIViewController {
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    let cellTitle = ["Nama Modul", "Deskripsi Modul","Upload File"]
    var height = 52.0
}
    // MARK: - View Life Cycle
extension ModulController{
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setNavItem()
        
        let nibModulName = UINib(nibName: "ModulNameTVC", bundle: nil)
        tableView.register(nibModulName, forCellReuseIdentifier: "ModulNameTVC")
        let nibModulDescription = UINib(nibName: "ModulDescriptionTVC", bundle: nil)
        tableView.register(nibModulDescription, forCellReuseIdentifier: "ModulDescriptionTVC")
        let nibUploadFile = UINib(nibName: "UploadTVC", bundle: nil)
        tableView.register(nibUploadFile, forCellReuseIdentifier: "UploadTVC")
        
        
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension ModulController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Modul"
        
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
        dismiss(animated: true,completion: nil)
    }
    
}
    // MARK: - TableView Datasource & Delegate
extension ModulController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else if (section == 1){
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 4, y: -5, width: tableView.bounds.size.width, height: 5))
        sectionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = cellTitle[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                height = 80
            }
        }
        else{
            height = 52
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModulNameTVC", for: indexPath) as! ModulNameTVC
            return cell
        }
        else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModulDescriptionTVC", for: indexPath) as! ModulDescriptionTVC
            return cell
        }
        else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadTVC", for: indexPath) as! UploadTVC
            return cell
        }
        return UITableViewCell()
    }
    
    
    
}

