//
//  InputTugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 12/03/23.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class InputTugasController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    var displayURL: String?
    let cellTitle = ["Deskripsi Tugas", "Pengumpulan Tugas"]
}
    // MARK: - View Life Cycle
extension InputTugasController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavItem()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nibDeskripsi = UINib(nibName: "DeskripsiTugasTVC", bundle: nil)
        tableView.register(nibDeskripsi, forCellReuseIdentifier: "DeskripsiTugasTVC")
        let nibPengumpulanTugas = UINib(nibName: "PengumpulanTugasTVC", bundle: nil)
        tableView.register(nibPengumpulanTugas, forCellReuseIdentifier: "PengumpulanTugasTVC")

    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension InputTugasController{
    private func setNavItem(){
        let label = UILabel()
        label.text = "Tugas Bab 1"
        label.font = .systemFont(ofSize: 18,weight: .semibold)
        label.largeContentImageInsets
        
        //        label.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: label)
        self.navigationItem.leftBarButtonItem = leftItem
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.gray,renderingMode: .alwaysOriginal).withConfiguration(largeConfig), style: .plain, target: self, action: #selector(dismissSelf))
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }
}
// MARK: - TableView Delegate & Datasource
extension InputTugasController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }else if(section == 1){
            return 1
        }
        else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeskripsiTugasTVC", for: indexPath) as! DeskripsiTugasTVC
            return cell
        }else if(indexPath.section == 1){
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
