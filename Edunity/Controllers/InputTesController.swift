//
//  InputTesController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class InputTesController:UIViewController{
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellTitle = ["Nama Tes","Deskripsi Tes"]
    let db = Firestore.firestore()
    let modulModel = ModulModel()
    
    var tesNameTVC: TesNameTVC?
    var tesDescTVC: TesDescriptionTVC?
    var largeTitle: String?
    
}
extension InputTesController{
    // MARK: - View Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibTesName = UINib(nibName: "TesNameTVC", bundle: nil)
        tableView.register(nibTesName, forCellReuseIdentifier: "TesNameTVC")
        let nibTesDesc = UINib(nibName: "TesDescriptionTVC", bundle: nil)
        tableView.register(nibTesDesc, forCellReuseIdentifier: "TesDescriptionTVC")
        
        modulModel.fetchModulTes { [self] modules in
            largeTitle = modules.modulName
            setNavItem()
        }
        
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension InputTesController{
    private func setNavItem(){
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Input Tes \(largeTitle!)"
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func saveItem(){
        let tesid = UUID().uuidString
        
        if let nameTes = tesNameTVC?.tesNameTV.text,!nameTes.isEmpty,let descTes = tesDescTVC?.tesDescTF.text,!descTes.isEmpty{
            storeData(nameTes: nameTes, descTes: descTes, modulid: SelectedModul.selectedModul.modulPath,classid: SelectedClass.selectedClass.classPath,tesid: tesid,nameModul: largeTitle!)
            print("Saved")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshModul"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshData"), object: nil)
            
            dismissSelf()
        }else{
            print("ga masuk bro")
        }
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
    
    private func storeData(nameTes: String,descTes: String, modulid: String, classid: String, tesid: String,nameModul: String){
        // Upload data
        db.collection("tes").addDocument(data: [
            "nameTes": nameTes,
            "descTes": descTes,
            "nameModul": nameModul,
            "modulid": modulid,
            "classid": classid,
            "tesid": tesid,
            "timestamp": FieldValue.serverTimestamp()
        ])
        
    }
    
}
// MARK: - TableView Delegate & Datasource
extension InputTesController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TesNameTVC", for: indexPath) as! TesNameTVC
            
            tesNameTVC = cell
            return tesNameTVC!
            
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TesDescriptionTVC", for: indexPath) as! TesDescriptionTVC
            
            tesDescTVC = cell
            return tesDescTVC!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 1){
            return 63
        }
        else{
            return 44
        }
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
    
}
