//
//  TugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 07/03/23.
//

import UIKit

class TugasController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    let cellTitle = ["Nama Tugas", "Deskripsi Tugas"]
    var height = 52.0
}
    // MARK: - View Life Cycle
extension TugasController{
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavItem()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let nibTugasName = UINib(nibName: "TugasNameTVC", bundle: nil)
        tableView.register(nibTugasName, forCellReuseIdentifier: "TugasNameTVC")
        let nibTugasDescription = UINib(nibName: "TugasDescriptionTVC", bundle: nil)
        tableView.register(nibTugasDescription, forCellReuseIdentifier: "TugasDescriptionTVC")
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension TugasController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Tugas"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
    @objc private func saveItem(){
        self.dismiss(animated: true,completion: nil)
    }
    
}
// MARK: - TableView Delegate & Datasource
extension TugasController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else if (section == 1){
            return 1
        }else{
            return 2
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.bounds.size.width, height: 5))
        sectionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = cellTitle[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TugasNameTVC",for: indexPath) as! TugasNameTVC
            
            return cell
        }
        else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TugasDescriptionTVC",for: indexPath) as! TugasDescriptionTVC
            
            return cell
        }
        return UITableViewCell()
    }
    
}
