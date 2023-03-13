//
//  HomePageController.swift
//  skripsi
//
//  Created by Hanz Christian on 28/02/23.
//

import UIKit

class HomePageController: UIViewController {
    
    // MARK: - Variables & Outlet
    let role = UserDefaults.standard.integer(forKey: "role")
    let dateFormatter = DateFormatter()
    let dates = Date()

    var jumlahKelas:[Kelas] = []
    var counts = 1
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findclassBtn: UIButton!
}

// MARK: - View Life Cycle

extension HomePageController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenView"), object: nil)
        
        jumlahKelas = [
            Kelas(className: "Aljabar Linear", classModule: "2 Modul", classEnrollment: "En:ollment Key : 7F5DW", classImg: #imageLiteral(resourceName: "classimage-3")),
            Kelas(className: "Matematika Teknik", classModule: "5 Modul", classEnrollment: "Enrollment Key : 21DWA", classImg: #imageLiteral(resourceName: "classimage-1")),
            Kelas(className: "Fisika Listrik", classModule: "4 Modul", classEnrollment: "Enrollment Key : 35WZX", classImg: #imageLiteral(resourceName: "classimage-2"))
        ]
        
        if(role == 1){ //pengajar
            setBtn()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibClass = UINib(nibName: "ClassTVC", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "ClassTVC")
        
        if(counts == 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhidden"), object: nil)
        }
        else if(counts == 1){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidden"), object: nil)
        }
        setTime()
    }
}

// MARK: - Private/Functions
extension HomePageController{
    @IBAction func btnPressed(_ sender: UIButton) {
        if (role == 0){
            performSegue(withIdentifier: "findclassSegue", sender: nil)
        }else{
            setBtn()
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
            timeLbl.text = "Selamat Pagi"
        }
        else if(newDate >= startNoonDate && newDate <= endNoonDate){
            timeLbl.text = "Selamat Siang"
        }
        else if(newDate >= startEveningDate && newDate <= endEveningDate){
            timeLbl.text = "Selamat Sore"
        }else{
            timeLbl.text = "Selamat Malam"
        }
    }

}
// MARK: - TableView Delegate & Resource
extension HomePageController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return counts
        return jumlahKelas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        
//        cell.classImg =
//        cell.classtitleLbl =
//        cell.classmodulLbl =
//        cell.classenrollmentkeyLbl =
        
        
        cell.setupClass(jumlahKelas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(role == 1){
            self.performSegue(withIdentifier: "guruclassSegue", sender: self)
        }
        else{
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MuridClassController") as! MuridClassController
            vc.modalPresentationStyle = .fullScreen
            let nav =  UINavigationController(rootViewController: vc)
            self.present(nav, animated: true)
        }
    }
    
}
