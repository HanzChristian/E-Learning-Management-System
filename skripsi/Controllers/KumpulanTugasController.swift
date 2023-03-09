//
//  KumpulanTugasController.swift
//  skripsi
//
//  Created by Hanz Christian on 09/03/23.
//

import UIKit

class KumpulanTugasController: UIViewController {
    
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    let data:[Tugas] = [
        Tugas(tugasDate: "2 Feb 2022, 08:00", tugasName: "Hanz Christian", tugasFile: "punyahanz.pdf"),
        Tugas(tugasDate: "2 Feb 2022, 07:30", tugasName: "Haris Maulana", tugasFile: "punyaharis.pdf"),
        Tugas(tugasDate: "1 Feb 2022, 05:22", tugasName: "Michael", tugasFile: "punyamichael.pdf")
    ]
}
// MARK: - View Life Cycle
extension KumpulanTugasController{
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavItem()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension KumpulanTugasController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Kumpulan Tugas Modul 1" //nanti ganti
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc private func saveItem(){
        self.dismiss(animated: true,completion: nil)
    }
}
// MARK: - TableView Delegate & Datasource
extension KumpulanTugasController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tugas = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! KumpulanTugasTVC
        cell.tanggalLbl.text = tugas.tugasDate
        cell.namaLbl.text = tugas.tugasName
        cell.fileBtn.setTitle(tugas.tugasFile, for: .normal)
        
        return cell
    }
    
    
}

