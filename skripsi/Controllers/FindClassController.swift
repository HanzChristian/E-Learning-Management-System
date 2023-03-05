//
//  FindClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 01/03/23.
//

import UIKit

class FindClassController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
}

// MARK: - View Life Cycle
extension FindClassController{
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavItem()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibClass = UINib(nibName: "ClassTVC", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "ClassTVC")
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
// MARK: - TableView Delegate & Datasource
extension FindClassController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        
        //        cell.classImg =
        //        cell.classtitleLbl =
        //        cell.classmodulLbl =
        //        cell.classenrollmentkeyLbl =
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor.systemBlue.cgColor
    }
}
