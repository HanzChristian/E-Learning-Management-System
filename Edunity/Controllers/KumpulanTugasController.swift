//
//  KumpulanTugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 09/03/23.
//

import UIKit
import FirebaseStorage

class KumpulanTugasController: UIViewController,UIDocumentPickerDelegate {
    
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tanggalLbl: UILabel!
    @IBOutlet weak var namaLbl: UILabel!
    @IBOutlet weak var fileLbl: UILabel!
    
    var modulModel = ModulModel()
    var listofTugas = [TugasMurid]()
    var tugasName: String?
    
    
}
// MARK: - View Life Cycle
extension KumpulanTugasController{
    override func viewDidLoad(){
        super.viewDidLoad()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenTugas"), object: nil)
        tanggalLbl.isHidden = true
        namaLbl.isHidden = true
        fileLbl.isHidden = true

        
        DispatchQueue.main.async{ [self] in
            modulModel.fetchAllTugas { [self] tugas in
                listofTugas.append(tugas)
                tableView.reloadData()
                if(listofTugas.count == 0){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenTugas"), object: nil)
                    tanggalLbl.isHidden = true
                    namaLbl.isHidden = true
                    fileLbl.isHidden = true
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenTugas"), object: nil)
                    tanggalLbl.isHidden = false
                    namaLbl.isHidden = false
                    fileLbl.isHidden = false
                }
            }
            modulModel.fetchTugasMurid{ [self] tugas in
                tugasName = tugas.tugasName
                setNavItem()
            }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension KumpulanTugasController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Kumpulan \(tugasName!)" //nanti ganti
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
}
// MARK: - TableView Delegate & Datasource
extension KumpulanTugasController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofTugas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eachTugas = listofTugas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! KumpulanTugasTVC
        
        let attrFont = UIFont.boldSystemFont(ofSize: 14)
        let titleFile = "\(eachTugas.tugasName)"
        let attrTitle = NSAttributedString(string: titleFile, attributes: [NSAttributedString.Key.font: attrFont])
        
        cell.tanggalLbl.text = eachTugas.tugasDate
        cell.namaLbl.text = eachTugas.muridName
        cell.fileBtn.setAttributedTitle(attrTitle, for: UIControl.State.normal)
        
        
        cell.downloadPDF = { [weak self] in
            //Download to local file
            
            //Create reference to the file that wants to be download
            let storageRef = Storage.storage().reference(withPath: eachTugas.tugasFile)
            
            //Make the filename in local
            let fileName = storageRef.name
            
            print("filenamenya : \(fileName)")
            
            //Create local filesystem URL
            let localURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
            
            let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
             labelView.text = "Download progress: "
             labelView.textColor = .black
            
            let progressView = UIProgressView(progressViewStyle: .default)
                progressView.progress = 0.0
                progressView.frame = CGRect(x: 0, y: 20, width: 200, height: 30)
            
           
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            containerView.addSubview(labelView)
            containerView.addSubview(progressView)
            
            let progressBarButtonItem = UIBarButtonItem(customView: containerView)

            self?.navigationItem.rightBarButtonItem = progressBarButtonItem
            
            //Download the file
            let download = storageRef.write(toFile: localURL)
            
            // Observe the download progress
             download.observe(.progress) { snapshot in
                 let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                 progressView.progress = Float(percentComplete / 100.0)
             }
            
            //Observing the download & open files App
            download.observe(.success){ snapshot in
                print("File downloaded")
                
                // Make the files App open and choose to save
                let documentPicker = UIDocumentPickerViewController(forExporting: [localURL])
                documentPicker.shouldShowFileExtensions = true
                documentPicker.delegate = self
                self!.present(documentPicker,animated: true,completion: nil)
            }
            
            download.observe(.failure){ error in
                print("Error downloading file!")
            }
            
        }
        return cell
    }
    
    
}

