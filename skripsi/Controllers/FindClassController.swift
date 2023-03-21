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
    var listofClassMurid = [Class]()
    var classModel = ClassModel()
    var enrollmentKeyDB: String? = ""
}

// MARK: - View Life Cycle
extension FindClassController{
    
//    override func viewWillAppear(_ animated: Bool) {
//        classModel.fetchClassGuru(completion: { [self] classess in
//            listofClassMurid.append(classess)
//            tableView.reloadData()
//            enrollmentKeyDB = classess.classEnrollment
//            print("ini adalah enrollmentnya = \(enrollmentKeyDB)")
//        })
//    }
//    
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenView"), object: nil)
        setNavItem()
        print("data not fetch")
        classModel.fetchClassAll(completion: { [self] classess in
            listofClassMurid.append(classess)
            tableView.reloadData()
//            enrollmentKeyDB = classess.classEnrollment
//            print("ini adalah enrollmentnya = \(enrollmentKeyDB)")
        })
        print("data fetched")
        
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
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }

    func showAlert(){
        let alert = UIAlertController(title: "Masuk ke Kelas", message: "Masukkan Enrollment Key kelas!", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Enrollment Key"
            field.returnKeyType = .done
        }
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler: nil))
        alert.addAction(UIAlertAction(title: "Lanjut", style: .default,handler: {_ in
            guard let fields = alert.textFields,fields.count == 1 else{
                return
                //kondisi kalo bener, return ke homepage sebagai kelasnya
            }
            let enrollmentField = fields[0]
            guard let enrollmentKey = enrollmentField.text, !enrollmentKey.isEmpty else{
                print("EnrolmentKeynya salah/kosong!")
                return
            }
            print("Enrolment Key: \(enrollmentKey)")
            self.dismiss(animated: true,completion: nil)
        }))
        
        present(alert,animated:true)
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
        cell.classenrollmentkeyLbl.text = eachClass.classEnrollment
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        showAlert()
        let eachClass = listofClassMurid[indexPath.row]
    
        cell.classImg.image = eachClass.classImg
        cell.classtitleLbl.text = eachClass.className
        cell.classmodulLbl.text = "\(eachClass.classModule) modul"
        cell.classenrollmentkeyLbl.text = eachClass.classEnrollment
        
    }
    
}
