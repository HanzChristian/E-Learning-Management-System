//
//  MakeClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit

class MakeClassController: UIViewController {
    
    // MARK: - Variables & Outlet
    var classNameTVC: ClassNameTVC?
    var classDescTVC: ClassDescriptionTVC?
    var jumlahKelas: Kelas?
    
    var height = 52.0
    let cellTitle = ["Nama Kelas", "Deskripsi Kelas"]
    
    @IBOutlet weak var tableView: UITableView!
}
    // MARK: - View Life Cycle
extension MakeClassController{
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavItem()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibClassName = UINib(nibName: "ClassNameTVC", bundle: nil)
        tableView.register(nibClassName, forCellReuseIdentifier: "ClassNameTVC")
        let nibClassDesc = UINib(nibName: "ClassDescriptionTVC", bundle: nil)
        tableView.register(nibClassDesc, forCellReuseIdentifier: "ClassDescriptionTVC")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.validateInput), name: NSNotification.Name(rawValue: "validateInput"), object: nil)
        
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension MakeClassController{
    
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Bentuk Kelasku"
        
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
    
    @objc func validateInput(){
        let className = classNameTVC?.classnameTF.text
        let classDesc = classDescTVC?.classdescTF.text
        
        if((className == Optional("") || classDesc == Optional(""))){
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

// MARK: - Tableview Deletage & Datasource
extension MakeClassController:UITableViewDelegate,UITableViewDataSource{
    
    //Jumlah section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //Jumlah row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else if (section == 1){
            return 1
        }else{
            return 2
        }
    }
    
    //Define cell setiap row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ClassNameTVC", for: indexPath) as! ClassNameTVC
                return cell
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDescriptionTVC", for: indexPath) as! ClassDescriptionTVC
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 5, y: 20, width: tableView.bounds.size.width, height: 5))
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
}



