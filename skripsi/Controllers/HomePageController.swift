//
//  HomePageController.swift
//  skripsi
//
//  Created by Hanz Christian on 28/02/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomePageController: UIViewController {
    
    // MARK: - Variables & Outlet

    let role = UserDefaults.standard.string(forKey: "role")
    let dateFormatter = DateFormatter()
    let dates = Date()
    
    let userModel = UserModel()
    let classModel = ClassModel()
    var listofClass = [Class]()
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findclassBtn: UIButton!
}

// MARK: - View Life Cycle

extension HomePageController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Core.shared.notNewUser()
        
        self.userModel.fetchUser{user in
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenView"), object: nil)
     
        if(role == "pengajar"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
                classModel.fetchClassGuru(completion: { [self] classess in
                    print("ngefetch")
                    listofClass.append(classess)
                    tableView.reloadData()
                    if(listofClass.count == 0){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
                    }
                    else if(listofClass.count == 1){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
                    }
                })
            }
        }else if(role == "pelajar"){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
                classModel.fetchClassMurid(completion: { [self] classess in
                    listofClass.append(classess)
                    tableView.reloadData()
                    print("jumlah kelas = \(listofClass.count)")
                    if(listofClass.count == 0){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
                    }
                    else if(listofClass.count == 1){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
                    }
                })
            }
        }
    
        
        if(role == "pengajar"){ //pengajar
            setBtn()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //make pull refresh view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        self.tableView.refreshControl = refreshControl
        
        let nibClass = UINib(nibName: "ClassTVC", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "ClassTVC")
    
        setTime()
    }
}

// MARK: - Private/Functions
extension HomePageController{
    @IBAction func btnPressed(_ sender: UIButton) {
        if (role == "pelajar"){
            performSegue(withIdentifier: "findclassSegue", sender: nil)
        }else{
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MakeClassController") as! MakeClassController
            vc.modalPresentationStyle = .automatic
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
    }
    
    func setBtn(){
        if let attrFont = UIFont(name: "Helvetica", size: 12) {
                  let title = "Bentuk Kelas"
                  let attrTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: attrFont])
                  findclassBtn.setAttributedTitle(attrTitle, for: UIControl.State.normal)
              }
    }
    
    @objc func refresh(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            listofClass.removeAll()
            
            if(role == "pengajar"){
                classModel.fetchClassGuru(completion: { [self] classess in
                    print("ngefetch")
                    listofClass.append(classess)
                    tableView.reloadData()
                    if(listofClass.count == 0){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
                    }
                    else if(listofClass.count == 1){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
                    }
                })
            }else if(role == "pelajar"){
                classModel.fetchClassMurid(completion: { [self] classess in
                    listofClass.append(classess)
                    tableView.reloadData()
                    print("jumlah kelas = \(listofClass.count)")
                    if(listofClass.count == 0){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
                    }
                    else if(listofClass.count == 1){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
                    }
                })
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func setTime(){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dates)
        let minutes = calendar.component(.minute, from: dates)
        
        let string = ("20 Jun 2022 \(hour):\(minutes):00 +0700")
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        
        let newDate = dateFormatter.date(from: string)!
        
        //pagi
        let startMorning = ("20 Jun 2022 01:00:00 +0700")
        let endMorning = ("20 Jun 2022 11:59:00 +0700")
        
        //siang
        let startNoon = ("20 Jun 2022 12:00:00 +0700")
        let endNoon = ("20 Jun 2022 13:59:00 +0700")
        
        //sore
        let startEvening = ("20 Jun 2022 14:00:00 +0700")
        let endEvening = ("20 Jun 2022 17:59:00 +0700")
    
        
        let startMorningDate = dateFormatter.date(from: startMorning)!
        let endMorningDate = dateFormatter.date(from: endMorning)!
        let startNoonDate = dateFormatter.date(from: startNoon)!
        let endNoonDate = dateFormatter.date(from: endNoon)!
        let startEveningDate = dateFormatter.date(from: startEvening)!
        let endEveningDate = dateFormatter.date(from: endEvening)!
        
        if(newDate >= startMorningDate && newDate <= endMorningDate){
            timeLbl.text = "Selamat Pagi!"
        }
        else if(newDate >= startNoonDate && newDate <= endNoonDate){
            timeLbl.text = "Selamat Siang!"
        }
        else if(newDate >= startEveningDate && newDate <= endEveningDate){
            timeLbl.text = "Selamat Sore!"
        }else{
            timeLbl.text = "Selamat Malam!"
        }
    }
    

}
// MARK: - TableView Delegate & Resource
extension HomePageController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofClass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        
            let eachClass = listofClass[indexPath.row]
        
            cell.classImg.image = eachClass.classImg
            cell.classtitleLbl.text = eachClass.className
            cell.classmodulLbl.text = "\(eachClass.classModule) modul"
            cell.classenrollmentkeyLbl.text = "Enrollment Key : \(eachClass.classEnrollment)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eachClass = listofClass[indexPath.row]
        
        if(role == "pengajar"){
            SelectedClass.selectedClass.classPath = eachClass.classid
            SelectedIdx.selectedIdx.indexPath = indexPath
            
            self.performSegue(withIdentifier: "guruclassSegue", sender: self)
        }
        else{
            SelectedIdx.selectedIdx.indexPath = indexPath
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MuridClassController") as! MuridClassController
            vc.modalPresentationStyle = .fullScreen
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
    }
    
    
}
