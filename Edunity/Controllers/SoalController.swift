//
//  SoalController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import UIKit

class SoalController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    let tesModel = TesModel()
    var jumlahSoal = [JumlahSoal]()
    var soalCount = JumlahSoal(soalNum: 0)
    var listofSoal = [Soal]()
    
    var soalModel = SoalModel()
    
    var tesName: String?
    
}
// MARK: - View Life Cycle
extension SoalController{
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(_:)), name: NSNotification.Name(rawValue: "refreshSoal"), object: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        DispatchQueue.main.async{ [self] in
            fetchData()
        }
        
        tesModel.fetchSpesificTes { [self] tes, error in
            if let error = error{
                return
            }
            tesName = tes?.tesName
            setNavItem()
        }
        
        let nibSoal = UINib(nibName: "SoalTVC", bundle: nil)
        tableView.register(nibSoal, forCellReuseIdentifier: "SoalTVC")
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension SoalController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = tesName
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(dismissSelf))
        
        if(listofSoal.count > 0){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(SaveItem))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tambahkan", style: .plain, target: self, action: #selector(toInputSoal))
        }
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion: nil)
    }
    
    @objc private func toInputSoal(){
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MakeSoalController") as! MakeSoalController
        vc.modalPresentationStyle = .fullScreen
        let nav =  UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
    }
    
    @objc func refresh(_ sender: Any){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            listofSoal.removeAll()
            fetchData()
        }
    }
    
    private func fetchData(){
        soalModel.fetchAllSoal { [self] soal in
            listofSoal.append(soal)
            soalCount.soalNum += 1
            jumlahSoal.append(soalCount)
            tableView.reloadData()
            showEmpty()
        }
    }
    
    private func showEmpty(){
        if(listofSoal.count > 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hiddenSoal"), object: nil)
        }
        else if(listofSoal.count == 0){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unhiddenSoal"), object: nil)
        }
    }
    
    @objc private func SaveItem(){
        let alert = UIAlertController(title: "Kamu yakin ingin menyimpan?", message: "Jika sudah menyimpan, soal yang dimasukkan tidak dapat diubah kembali!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel,handler:{_ in
            print("keluar")
        }))
        
        alert.addAction(UIAlertAction(title: "Simpan", style: .default,handler:{_ in
            
        }))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        let attributedString = NSAttributedString(string: "Jika sudah menyimpan, soal yang dimasukkan tidak dapat diubah kembali!", attributes: attributes)
        alert.setValue(attributedString, forKey: "attributedMessage")
        
        present(alert,animated:true)
    }
    
    @objc func btnTapped(sender: UIButton){
        toInputSoal()
    }
    
    
}

// MARK: - TableView Delegate & Datasource
extension SoalController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(listofSoal.count == 0){
            return 0
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let frame: CGRect = tableView.frame
        
        //add plus btn
        let plusBtn: UIButton = UIButton(frame: CGRectMake(frame.size.width-70, 10, 30, 30))
        plusBtn.setTitle("+", for: .normal)
        plusBtn.setTitleColor(.black, for: .normal)
        plusBtn.backgroundColor = .white
        plusBtn.addTarget(self, action: #selector(SoalController.btnTapped(sender:)), for: .touchUpInside)
        headerView.addSubview(plusBtn)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listofSoal.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SoalTVC", for: indexPath) as! SoalTVC
            
            let eachSoal = listofSoal[indexPath.row]
            let soal = jumlahSoal[indexPath.row]
            
            cell.pertanyaanLbl.text = eachSoal.soalQuestion
            cell.soalLbl.text = "Soal \(soal.soalNum)"
            cell.optionLbl.text = "Option:\nA. \(eachSoal.soalAnswerA)\nB. \(eachSoal.soalAnswerB)\nC. \(eachSoal.soalAnswerC)\nD. \(eachSoal.soalAnswerD)\n"
            cell.jawabanLbl.text = "Jawaban : \(eachSoal.soalCorrectAns)"
            
            return cell
        }
        return UITableViewCell()
    }
    
    
}
