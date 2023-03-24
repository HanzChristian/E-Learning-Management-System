//
//  MuridClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 05/03/23.
//

import UIKit

class MuridClassController: UIViewController{
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    let data = [
        Modul(modulNum: "Modul 1", modulName: "Sistem Persamaan Linear", modulDesc: "Pada bab ini, diharapkan mahasiswa dapat memahami konsep ruang vektor dan sub ruang vektor, memahami sifat-sifatnya, dan mampu menentukan apakah suatu himpunan merupakan ruang vektor umum atau bukan. Lebih lanjut, mahasiswa diharapkan memahami konsep bebas linear, basis, dan dimensi ruang vektor.",modulFile: "awdawdwa"),
        Modul(modulNum: "Modul 2", modulName: "Vektor dan Ruang", modulDesc: "Pada bab ini, diharapkan mahasiswa dapat memahami konsep ruang vektor dan sub ruang vektor, memahami sifat-sifatnya, dan mampu menentukan apakah suatu himpunan merupakan ruang vektor umum atau bukan. Lebih lanjut, mahasiswa diharapkan memahami konsep bebas linear, basis, dan dimensi ruang vektor.",modulFile: "awdawdwadwadwad"),
        Modul(modulNum: "Modul 3", modulName: "Analisa Vektor", modulDesc: "Pada bab ini, diharapkan mahasiswa dapat memahami konsep ruang vektor dan sub ruang vektor, memahami sifat-sifatnya, dan mampu menentukan apakah suatu himpunan merupakan ruang vektor umum atau bukan. Lebih lanjut, mahasiswa diharapkan memahami konsep bebas linear, basis, dan dimensi ruang vektor.",modulFile: "awdadwadawdaw")
    ]
    var selectedIdx: IndexPath = IndexPath(row: 4, section: 0)
    var previousIdx: IndexPath?
}
// MARK: - View Life Cycle
extension MuridClassController{
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setNavItem()
        let nibMurid = UINib(nibName: "ExpandableTVC", bundle: nil)
        tableView.register(nibMurid, forCellReuseIdentifier: "ExpandableTVC")
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension MuridClassController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Aljabar Linear"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    @objc private func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }
    
}
// MARK: - TableView Delegate & Datasource
extension MuridClassController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTVC", for: indexPath) as! ExpandableTVC
        
        //        cell.classImg =
        //        cell.classtitleLbl =
        //        cell.classmodulLbl =
        //        cell.classenrollmentkeyLbl =
        
        cell.setupExpandable(data[indexPath.row])
        cell.selectionStyle = .none
        cell.makeSheet = { [weak self] in
            let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InputTugasController") as! InputTugasController
            vc.modalPresentationStyle = .fullScreen
            let nav =  UINavigationController(rootViewController: vc)
            
            if let sheet = nav.presentationController as? UISheetPresentationController{
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 15
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
            self!.present(nav,animated: true)
        }
        
        //        cell.animate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIdx == indexPath){
            return 280
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIdx = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
}

