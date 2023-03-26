//
//  TugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 07/03/23.
//

import UIKit
import FirebaseFirestore

class TugasController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    let cellTitle = ["Nama Tugas", "Deskripsi Tugas"]
    let db = Firestore.firestore()
    var height = 52.0
    var classid: String?
    var modulid: String?
    var modulModel = ModulModel()
    var classModel = ClassModel()
    var tugasNameTVC = TugasNameTVC()
    var tugasDescTVC = TugasDescriptionTVC()

}
    // MARK: - View Life Cycle
extension TugasController{
    
    override func viewWillAppear(_ animated: Bool) {
        
        classModel.fetchSelectedClass { [self] classess in
            classid = classess.classid
            print("ini classid = \(classid)")
            modulModel.fetchModul { [self] modules in
                modulid = modules.modulid
                print("ini modulid yang baru = \(modulid)")
            }
        }
    }
    
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
        let tugasid = "\(UUID().uuidString)"
        if let nameTugas = tugasNameTVC.tugasNameTV.text,!nameTugas.isEmpty, let descTugas = tugasDescTVC.tugasDescTVC.text,!descTugas.isEmpty{
            storeData(nameTugas: nameTugas, descTugas: descTugas, modulid: modulid!, tugasid: tugasid,classid: classid!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshModul"), object: nil)
            self.dismiss(animated: true,completion: nil)
        }else{
            print("ga masuk bro")
        }

    }
    
    func storeData(nameTugas: String, descTugas: String, modulid: String, tugasid: String,classid: String){
        db.collection("tugas").addDocument(data: [
            "nameTugas": nameTugas,
            "descTugas": descTugas,
            "modulid": modulid,
            "tugasid": tugasid,
            "classid": classid
        ])
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
            tugasNameTVC = cell
            return tugasNameTVC
        }
        else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "TugasDescriptionTVC",for: indexPath) as! TugasDescriptionTVC
            tugasDescTVC = cell
            return tugasDescTVC
        }
        return UITableViewCell()
    }
    
}
