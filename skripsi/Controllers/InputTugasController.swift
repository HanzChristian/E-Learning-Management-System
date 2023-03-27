//
//  InputTugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 12/03/23.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import FirebaseFirestore
import FirebaseStorage

class InputTugasController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    var modulModel = ModulModel()
    var userModel = UserModel()
    var descTugasTVC = DeskripsiTugasTVC()
    let dates = Date()
    let dateFormatter = DateFormatter()
    
    let cellTitle = ["Deskripsi Tugas","Status Pengumpulan","Pengumpulan Tugas"]
    let storageRef = Storage.storage().reference()
    var db = Firestore.firestore()
    
    var namaUser: String?
    var idModul = "\(SelectedModul.selectedModul.modulPath)"
    var nameTugas: String?
    var descTugas: String?
    var displayURL: String?
    var fullURL: String?
    var currentTime: String?
    var extractURL: URL?
    var tugasDisplay: String?
    
}
// MARK: - View Life Cycle
extension InputTugasController{
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
        DispatchQueue.main.async{ [self] in
            modulModel.fetchTugasMurid { [self] tugas in
                nameTugas = tugas.tugasName
                descTugas = tugas.tugasDesc
                setNavItem()
            }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibDeskripsi = UINib(nibName: "DeskripsiTugasTVC", bundle: nil)
        tableView.register(nibDeskripsi, forCellReuseIdentifier: "DeskripsiTugasTVC")
        let nibStatus = UINib(nibName: "StatusTVC", bundle: nil)
        tableView.register(nibStatus, forCellReuseIdentifier: "StatusTVC")
        let nibPengumpulanTugas = UINib(nibName: "PengumpulanTugasTVC", bundle: nil)
        tableView.register(nibPengumpulanTugas, forCellReuseIdentifier: "PengumpulanTugasTVC")
        
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension InputTugasController{
    private func setNavItem(){
        
        let label = UILabel()
        label.text = nameTugas
        label.font = .systemFont(ofSize: 18,weight: .semibold)
        label.largeContentImageInsets
        
        
        let leftItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftItem
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
    }
    
    func setCurrentDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm"
        let currentDateTime = Date()
        let formattedDateTime = dateFormatter.string(from: currentDateTime)
        currentTime = formattedDateTime
    }
    
    @objc private func saveItem(){
        setCurrentDate()
        self.userModel.fetchUser{ [self] user in
            let userName = user.name
            let uid = user.id
            print("ini username pas fetch = \(userName)")
            
            storeData(username: userName,userid: uid,modulid: idModul,fileTugas:fullURL!,displayedFile: displayURL!, dateSubmitted:currentTime!)
            print("Saved")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshData"), object: nil)
            dismiss(animated: true,completion: nil)
        }
      
    }
    
    func storeData(username: String,userid: String, modulid: String, fileTugas: String,displayedFile: String,dateSubmitted: String){
        storageRef.child("pdfTugas/\(displayURL!)").putFile(from: extractURL!,metadata: nil){ [self]
            (_,err) in
            
            if err != nil{
                print("error disini gan \(err?.localizedDescription)")
                return
            }
            
            db.collection("muridTugas").addDocument(data: [
                "userName": username,
                "userid": userid,
                "modulid": modulid,
                "fileTugas": fileTugas,
                "displayedFile": displayedFile,
                "dateSubmitted": dateSubmitted
            ])
        }
    }
    
}
// MARK: - TableView Delegate & Datasource
extension InputTugasController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeskripsiTugasTVC", for: indexPath) as! DeskripsiTugasTVC
            
            modulModel.fetchTugasMurid { [self] tugas in
                descTugas = tugas.tugasDesc
                cell.descTugasLbl.text = descTugas
            }
            
            return cell
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusTVC", for: indexPath) as! StatusTVC
            
            cell.statusLbl.text = "Belum dikumpulkan!"
            
            modulModel.fetchTugasCondition { [self] tugasCons in
                tugasDisplay = tugasCons.tugasName
                if(tugasDisplay != nil){
                    cell.statusLbl.text = "Sudah dikumpulkan!"
                    cell.statusLbl.textColor = .systemBlue
                }else{
                }
            }
            
        }else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PengumpulanTugasTVC", for: indexPath) as! PengumpulanTugasTVC
            cell.importFile = { [weak self] in
                let supportedTypes: [UTType] = [UTType.pdf,UTType.text,UTType.data,UTType.aliasFile]
                let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
                pickerViewController.delegate = self
                pickerViewController.allowsMultipleSelection = false
                pickerViewController.shouldShowFileExtensions = true
                self!.present(pickerViewController, animated: true, completion: nil)
            }
            
            if(displayURL == nil){
                cell.kumpultugasLbl.setTitle("Masukkan File", for: .normal)
            }else{
                cell.kumpultugasLbl.setTitle("\(displayURL!)", for: .normal)
            }
            
            modulModel.fetchTugasCondition { [self] tugasCons in
                tugasDisplay = tugasCons.tugasName
                if(tugasDisplay != nil){
                    if(displayURL != nil){
                        cell.kumpultugasLbl.setTitle("\(displayURL)", for: .normal)
                    }else{
                        cell.kumpultugasLbl.setTitle("Edit File", for: .normal)
                    }
                }else{
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 63
        }
        else{
            return 35
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
// MARK: - UIDocumentPickerViewController Deleagte and such
extension InputTugasController:UIDocumentPickerDelegate{
    
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        
        
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
