//
//  FindClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 01/03/23.
//

import UIKit
import FirebaseFirestore

class FindClassController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    var listofClassMurid = [Class]()
    var classModel = ClassModel()
    var enrollmentKeyDB: String? = ""
    let db = Firestore.firestore()
    let userModel = UserModel()
    var previousSelectedIndexPath: IndexPath?
    
}

// MARK: - View Life Cycle
extension FindClassController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenView"), object: nil)
        setNavItem()
        print("data not fetch")
        classModel.fetchClassAll(completion: { [self] classess in
            listofClassMurid.append(classess)
            tableView.reloadData()
            
            if(listofClassMurid.count == 0){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenFind"), object: nil)
            }else{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenFind"), object: nil)
            }
        })
        print("data fetched")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //make pull refresh view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        self.tableView.refreshControl = refreshControl
        
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
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }
    
    func storeData(nameClass: String, descClass: String,uidMurid: String,enrollmentKey: String,modulCount: Int,imgURL: String,classid: String){
        // Upload data
        db.collection("muridClass").addDocument(data: [
            "nameClass": nameClass,
            "descClass": descClass,
            "enrollmentKey": enrollmentKey,
            "uidMurid": uidMurid,
            "modulCount": modulCount,
            "imgURL": imgURL,
            "classid": classid
        ])
    }
    


}
// MARK: - TableView Delegate & Datasource
extension FindClassController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("list of class murid = \(listofClassMurid.count)")
        return listofClassMurid.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        
        let eachClass = listofClassMurid[indexPath.row]
    
        cell.classImg.image = eachClass.classImg
        cell.classtitleLbl.text = eachClass.className
        cell.classmodulLbl.text = "\(eachClass.classModule) modul"
        cell.classenrollmentkeyLbl.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let eachClass = listofClassMurid[indexPath.row]
        
        if indexPath == previousSelectedIndexPath{
               // Error handling with the same indexPath
            //Make alert to get Enrollment Key
            let alert = UIAlertController(title: "Masuk ke Kelas", message: "Masukkan Enrollment Key kelas!", preferredStyle: .alert)
            
            alert.addTextField{ field in
                field.placeholder = "Enrollment Key"
                field.returnKeyType = .done
            }
            alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler: nil))
            alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler: { [self]_ in
                guard let fields = alert.textFields,fields.count == 1 else{
                    return
                }
                let enrollmentField = fields[0]
                let enrollmentKey = enrollmentField.text
                
                if enrollmentKey == eachClass.classEnrollment{
                    print("Enrollmentkey yang dimasukkan cocok!")
                    print("Enrolment Key: \(enrollmentKey)")
                    print("Class Key: \(eachClass.classEnrollment)")
                    
                    let nameClass = eachClass.className
                    let descClass = eachClass.classDesc
                    let enrollmentKey = eachClass.classEnrollment
                    let modulCount = eachClass.classModule
                    let imgURL = eachClass.classImgString
                    let classid = eachClass.classid
                    
                    let uid = userModel.fetchUID()
                 

                    storeData(nameClass: nameClass, descClass: descClass, uidMurid:uid!, enrollmentKey: enrollmentKey,modulCount: modulCount,imgURL: imgURL,classid: classid)
                    
                    
                    self.dismiss(animated: true,completion: nil)
                }else{
                    print("tidak cocok")
                    print("Enrolment Key: \(enrollmentKey)")
                    print("Class Key: \(eachClass.classEnrollment)")
                }
                
            }))
            
            present(alert,animated:true)
            
               return
           }
        
        previousSelectedIndexPath = indexPath
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
    
        cell.classImg.image = eachClass.classImg
        cell.classtitleLbl.text = eachClass.className
        cell.classmodulLbl.text = "\(eachClass.classModule) modul"
        cell.classenrollmentkeyLbl.text = eachClass.classEnrollment
        cell.classenrollmentkeyLbl.isHidden = true
        
        
        print("ini indexpath = \(indexPath)")
        print("ini indexpath sebelum = \(previousSelectedIndexPath)")

        
        //Make alert to get Enrollment Key
        let alert = UIAlertController(title: "Masuk ke Kelas", message: "Masukkan Enrollment Key kelas!", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Enrollment Key"
            field.returnKeyType = .done
        }
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler: { [self]_ in
            guard let fields = alert.textFields,fields.count == 1 else{
                return
            }
            let enrollmentField = fields[0]
            let enrollmentKey = enrollmentField.text
            
            if enrollmentKey == eachClass.classEnrollment{
                print("Enrollmentkey yang dimasukkan cocok!")
                print("Enrolment Key: \(enrollmentKey)")
                print("Class Key: \(eachClass.classEnrollment)")
                
                let nameClass = eachClass.className
                let descClass = eachClass.classDesc
                let enrollmentKey = eachClass.classEnrollment
                let modulCount = eachClass.classModule
                let imgURL = eachClass.classImgString
                let classid = eachClass.classid
                
                let uid = userModel.fetchUID()

                storeData(nameClass: nameClass, descClass: descClass, uidMurid:uid!, enrollmentKey: enrollmentKey,modulCount: modulCount,imgURL: imgURL,classid: classid)
                
                self.dismiss(animated: true,completion: nil)
            }else{
                print("tidak cocok")
                print("Enrolment Key: \(enrollmentKey)")
                print("Class Key: \(eachClass.classEnrollment)")
            }
            
        }))
        
        present(alert,animated:true)
        
        
    }
    
    @objc func refresh(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            listofClassMurid.removeAll()
            classModel.fetchClassAll(completion: { [self] classess in
                listofClassMurid.append(classess)
                tableView.reloadData()
                if(listofClassMurid.count == 0){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenFind"), object: nil)
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenFind"), object: nil)
                }
            })
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
}
