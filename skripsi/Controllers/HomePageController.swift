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
    var jumlahKelas:[Kelas]?
    var counts = 1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findclassBtn: UIButton!
}

// MARK: - View Life Cycle

extension HomePageController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if(role == 1){
            setBtn()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        if(role == 1){
            setBtn()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
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
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension HomePageController{
    @IBAction func btnPressed(_ sender: UIButton) {
        if (role == 0){
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
        findclassBtn.titleLabel?.text = "Bentuk Kelas"
        findclassBtn.titleLabel?.minimumScaleFactor = 0.5
        findclassBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        findclassBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
    }
}
// MARK: - TableView Delegate & Resource
extension HomePageController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return jumlahKelas!.count
        return counts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTVC", for: indexPath) as! ClassTVC
        
//        cell.classImg =
//        cell.classtitleLbl =
//        cell.classmodulLbl =
//        cell.classenrollmentkeyLbl =
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "muridclassSegue", sender: self)
    }
    
    
}
