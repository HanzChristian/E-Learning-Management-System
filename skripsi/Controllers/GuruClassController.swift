//
//  GuruClassController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/03/23.
//

import UIKit

class GuruClassController: UIViewController {
    // MARK: - Variables & Outlet
    @IBOutlet weak var tableView: UITableView!
    let cellTitle = ["Modul", "Kumpulan Tugas"]
}
extension GuruClassController{
    // MARK: - View Life Cycle
    
    override func viewDidLoad(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        super.viewDidLoad()
        setNavItem()
        let nibModul = UINib(nibName: "ModulTVC", bundle: nil)
        tableView.register(nibModul, forCellReuseIdentifier: "ModulTVC")
        let nibTugas = UINib(nibName: "TugasTVC", bundle: nil)
        tableView.register(nibTugas, forCellReuseIdentifier: "TugasTVC")
    }
}
    // MARK: - IBActions
    
    // MARK: - Private/Functions
extension GuruClassController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Aljabar Linear"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tambahkan Modul", style: .plain, target: self, action: #selector(choose))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    @objc private func dismissSelf(){
        dismiss(animated: true,completion: nil)
    }
    
    @objc private func choose(){
        let actionSheet = UIAlertController(title: "Apakah kamu ingin menambahkan Modul?", message: nil, preferredStyle: .actionSheet)
        let actModul = UIAlertAction(title: "Ya", style: .default) { _ in
            //present
        }
        let actBatal = UIAlertAction(title: "Batal", style: .cancel)
        actionSheet.addAction(actModul)
        actionSheet.addAction(actBatal)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func btnTapped(sender: UIButton){
       print("segue")
    }
}

// MARK: - TableView Delegate & Datasource
extension GuruClassController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let frame: CGRect = tableView.frame
        
        //bikin + button
        let plusBtn: UIButton = UIButton(frame: CGRectMake(frame.size.width-70, 10, 30, 30))
        plusBtn.setTitle("+", for: .normal)
        plusBtn.setTitleColor(.black, for: .normal)
        plusBtn.backgroundColor = .white
        plusBtn.addTarget(self, action: #selector(GuruClassController.btnTapped(sender:)), for: .touchUpInside)
        
        
        //bikin label section
        let sectionLabel = UILabel(frame: CGRect(x: 4, y: 20, width: tableView.bounds.size.width, height: 5))
        sectionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = cellTitle[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        headerView.addSubview(plusBtn)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "ModulTVC", for: indexPath) as! ModulTVC
                return cell
        }
        else if(indexPath.section == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "TugasTVC", for: indexPath) as! TugasTVC
                return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            print("delete item")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            print("clickable")
        }
    }
    
    


}

