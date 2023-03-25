//
//  ModulController.swift
//  skripsi
//
//  Created by Hanz Christian on 07/03/23.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import FirebaseFirestore
import FirebaseStorage

class ModulController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    let cellTitle = ["Nama Modul", "Deskripsi Modul","Upload File"]
    var height = 52.0
    let storageRef = Storage.storage().reference()
    var path = ""
    var fileRef: StorageReference? = nil
    let db = Firestore.firestore()
    var counter = 0
    
    var displayURL: String?
    var fullURL: String?
    var extractURL: URL?
    var classid : String?
    var numModul: Int?
    
    var modulNameTVC: ModulNameTVC?
    var modulDescriptionTVC: ModulDescriptionTVC?
    var classModel = ClassModel()
    
}
// MARK: - View Life Cycle
extension ModulController{
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        classModel.fetchSelectedClass { [self] classess in
            classid = classess.classid
            print("ini classid = \(classid)")
        }
        
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
        
        let modulid = "\(UUID().uuidString)"
        
        if let nameModul = modulNameTVC?.nameTF.text,!nameModul.isEmpty,let descModul = modulDescriptionTVC?.descTV.text,!descModul.isEmpty{
            storeData(nameModul: nameModul, descModul: descModul, fileModul: fullURL!, classid: classid!,modulid: modulid)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshModul"), object: nil)
            dismiss(animated: true,completion: nil)
        }else{
            print("ga masuk bro")
            print("ini nama modul = \(modulNameTVC?.nameTF.text), ini desc modul = \(modulDescriptionTVC?.descTV.text), ini filemodul = \(fullURL), ini classid = \(classid)")
        }
      
    }
    
    func storeData(nameModul: String, descModul: String,fileModul: String,classid: String,modulid: String){
        storageRef.child("pdf/\(displayURL!)").putFile(from: extractURL!,metadata: nil){ [self]
            (_,err) in
            
            if err != nil{
                print("error disini gan \(err?.localizedDescription)")
                return
            }
            
            db.collection("modul").addDocument(data: [
                "nameModul": nameModul,
                "descModul": descModul,
                "fileModul": fileModul,
                "classid": classid,
                "modulid": modulid
            ])
            
            //Add Modul count to display in app
            db.collection("class")
                .whereField("classid", isEqualTo: classid)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("error class")
                        // Some error occured
                    }else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "modulCount": FieldValue.increment(Int64(1))
                        ])
                    }
                }
            
            db.collection("muridClass")
                .whereField("classid", isEqualTo: classid)
                .getDocuments { (querySnapshot,err) in
                if let err = err{
                    print("error murid class")
                }else{
                    let document = querySnapshot!.documents.first
                    if(document != nil){
                        document!.reference.updateData([
                            "modulCount": FieldValue.increment(Int64(1))
                        ])
                    }
                }
            }
        }
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
            modulNameTVC = cell
            return modulNameTVC!
        }
        else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ModulDescriptionTVC", for: indexPath) as! ModulDescriptionTVC
            modulDescriptionTVC = cell
            return modulDescriptionTVC!
        }
        else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "UploadTVC", for: indexPath) as! UploadTVC
           
            cell.importFile = { [weak self] in
                let supportedTypes: [UTType] = [UTType.pdf,UTType.text,UTType.data,UTType.aliasFile]
                let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
                pickerViewController.delegate = self
                pickerViewController.allowsMultipleSelection = false
                pickerViewController.shouldShowFileExtensions = true
                self!.present(pickerViewController, animated: true, completion: nil)
            }
            if(displayURL == nil){
                cell.filenameLbl.setTitle("Masukkan File", for: .normal)
            }else{
                cell.filenameLbl.setTitle("\(displayURL!)", for: .normal)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
}
// MARK: - UIDocumentPickerViewController Deleagte and such
extension ModulController:UIDocumentPickerDelegate{
    

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        
        // extractURL to firebase Storage as URL,
        // fullURL to save in firestore,
        // displayURL to display in application
        extractURL = myURL
        fullURL = myURL.absoluteString
        displayURL = myURL.lastPathComponent
        
        self.tableView.reloadData()
    }
    

    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
    }
}

