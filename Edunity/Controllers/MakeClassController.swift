//
//  MakeClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 03/03/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class MakeClassController: UIViewController {
    
    // MARK: - Variables & Outlet
    var classNameTVC: ClassNameTVC?
    var classDescTVC: ClassDescriptionTVC?
    var height = 52.0
    let cellTitle = ["Nama Kelas", "Deskripsi Kelas"]
    let db = Firestore.firestore()
    let userModel = UserModel()
    let classModel = ClassModel()
    var modulCount = 0
    
    //Upload image
    let storageRef = Storage.storage().reference()
    var imageData: Data?
    var path = ""
    var fileRef: StorageReference? = nil
    
//    var modulCount = 0
//    var classCount = 0
    
    @IBOutlet weak var tableView: UITableView!
}
    // MARK: - View Life Cycle
extension MakeClassController{
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //dismiss gesture
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        
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
        
        //Get selected random image
        let img1 = #imageLiteral(resourceName: "owls-03")
        let img2 = #imageLiteral(resourceName: "owls-04")
        let img3 = #imageLiteral(resourceName: "owls-02")
        let img4 = #imageLiteral(resourceName: "owls-01")
        let img5 = #imageLiteral(resourceName: "owls-05")
        
        let imgArray = [img1,img2,img3,img4,img5]
        let randomImage = imgArray.randomElement()
        
        // Make sure it's not nil
        guard randomImage != nil else{
            return
        }
        
        
        // Turn image -> data
        imageData = randomImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else{
            return
        }

        // Filepath and name
        path = "images/\(UUID().uuidString).jpg"
        fileRef = storageRef.child(path)
        
        let randomString = makeEnrollmentKey(length: 5)
        let uid = userModel.fetchUID()
        
        let classid = "\(UUID().uuidString)"
        
        //isi save data
        if let nameClass = classNameTVC?.classnameTF.text,!nameClass.isEmpty,let descClass = classDescTVC?.classdescTF.text,!descClass.isEmpty{
            storeData(nameClass: nameClass, descClass: descClass, uid: uid!, enrollmentKey: randomString,modulCount: modulCount,imgURL: path,classid: classid)
//            uploadImg()
            print("Saved")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshData"), object: nil)
            dismiss(animated: true,completion: nil)
        }else{
            print("gamasuk bro")
            print("ini class name : \(classNameTVC?.classnameTF.text)\n ini classdesc : \(classDescTVC?.classdescTF.text)\n ini randomString : \(randomString)\n ini uid: \(uid)")
        }

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
    
    func storeData(nameClass: String, descClass: String,uid: String,enrollmentKey: String,modulCount: Int,imgURL: String,classid: String){
        
        // Upload data
        fileRef!.putData(imageData!,metadata: nil) { [self] metadata, error in
            if error == nil && metadata != nil{
                // save ref to firestore
                db.collection("class").addDocument(data: [
                    "nameClass": nameClass,
                    "descClass": descClass,
                    "enrollmentKey": enrollmentKey,
                    "uid": uid,
                    "modulCount": modulCount,
                    "imgURL": imgURL,
                    "classid": classid
                ])
            }
        }
    }
    
    
    func makeEnrollmentKey(length: Int) -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
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
                classNameTVC = cell
                return classNameTVC!
            }
        }
        else if(indexPath.section == 1){
            if(indexPath.row == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ClassDescriptionTVC", for: indexPath) as! ClassDescriptionTVC
                classDescTVC = cell
                return classDescTVC!
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



