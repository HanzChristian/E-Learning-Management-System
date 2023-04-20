//
//  SoalController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class SoalController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    let tesModel = TesModel()
    let classModel = ClassModel()
    var jumlahSoal = [JumlahSoal]()
    var soalCount = JumlahSoal(soalNum: 0)
    var listofSoal = [Soal]()
    var soalModel = SoalModel()
    let db = Firestore.firestore()
    
    var tesName: String?
    var className: String?
    var exist: String?
    
}
// MARK: - View Life Cycle
extension SoalController{
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(_:)), name: NSNotification.Name(rawValue: "refreshSoal"), object: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        fetchDataCondition()
        
        
        DispatchQueue.main.async{ [self] in
            fetchData()
        }
        
        
        let nibSoal = UINib(nibName: "SoalTVC", bundle: nil)
        tableView.register(nibSoal, forCellReuseIdentifier: "SoalTVC")
    }
}
// MARK: - IBActions

// MARK: - Private/Functions
extension SoalController{
    private func setNavItem(){
        print("ini listofSoal.count = \(listofSoal.count) , ini exist = \(exist)")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = tesName
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kembali", style: .plain, target: self, action: #selector(dismissSelf))
        
        if(listofSoal.count > 0 && exist == nil){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(SaveItem))
        }else if(exist != nil){
            navigationItem.rightBarButtonItem?.title = ""
            navigationItem.rightBarButtonItem?.isEnabled = false
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
            setNavItem()
            print("list of soal = \(listofSoal)")
        }
    }
    
    private func fetchDataCondition(){
        
        classModel.fetchSelectedClass { [self] classess in
            className = classess.className
        }
        
        //Check for tes name first - tes name will always be there
        tesModel.fetchSpesificTes { [self] tes, error in
            if let error = error{
                return
            }
            tesName = tes?.tesName
            
            //Check if fixed soal exist
            soalModel.fetchFixedSoal { soal, error in
                if let error = error{
                    //fixed soal not exist
                    setNavItem()
                    exist = nil
                    return
                }
                //fixed soal exist
                exist = soal?.soalAnswerA
                setNavItem()
            }
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
        
        alert.addAction(UIAlertAction(title: "Simpan", style: .default,handler:{ [self]_ in
            
            let batch = db.batch()
            let dispatchGroup = DispatchGroup()
            
            
            let tesRef = db.collection("tes").whereField("tesid", isEqualTo: SelectedTes.selectedTes.tesPath)
            
            dispatchGroup.enter()
            tesRef.getDocuments { [self] (querySnapshot,error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    dispatchGroup.leave()
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("Tes document does not exist")
                    dispatchGroup.leave()
                    return
                }
                
                // Update with new fixedQuestions
                document.reference.updateData(["fixedQuestion": listofSoal.map { $0.toDictionary() }]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document updated successfully")
                        self.dismiss(animated: true,completion: nil)
                    }
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            //Make tes Notification
            db.collection("muridClass").whereField("classid", isEqualTo: SelectedClass.selectedClass.classPath).getDocuments { [self] querySnapshot, err in
                if let err = err {
                    // Handle error
                } else {
                    let document = querySnapshot!.documents.first
                    if let classid = document?.data()["classid"] as? String {
                        print("classidnya = \(classid)")
                        sendNotification(topic: classid, title: "\(className!) telah diupdate!", body: "Tes bernama \(tesName!) telah ditambahkan! Jangan lupa dikerjakan!")
                    }
                }
                dispatchGroup.leave()
            }
            
            //wait for all the getDocuments() calls completed
            dispatchGroup.notify(queue: .main) {
                //commit batch
                batch.commit() { error in
                    if let error = error {
                        print("Error writing batched updates: \(error)")
                    }else {
                        print("Batched updates successful!")
                    }
                }
            }
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
    
    private func sendNotification(topic: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = [
            "to": "/topics/\(topic)",
            "notification" : [
                "title" : title,
                "body" : body
            ],
            "priority" : "high",
            "sound" : "default"
        ]
        print("paramString: \(paramString)")
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.httpBody = jsonData
        } catch let error {
            print("JSON serialization error: \(error.localizedDescription)")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAIMqQqnw:APA91bHQHmGcsni_s9fvsKdUuqpF2XIXid9vP1eHrhZuOy6B6p5qOtGNG-H_hsxVkIBSnXQp0moEQ37UjcMML66QplC8nW2_DOuuDlH5-F8JbzdpqBiZ9aDw0mJpVp-27g-zou-hTb3i", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                if let jsonData = data {
                    if let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                        print("ini json \(json)")
                    }
                }
            } catch let err {
                print("Error diakhir notif: \(err.localizedDescription)")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
            }
            if let data = data {
                let responseString = String(data: data, encoding: .utf8)
                print("responseString: \(responseString)")
            }
        }
        task.resume()
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
        
        soalModel.fetchFixedSoal { [self] soal, error in
            if let error = error{
                exist = nil
                if(exist == nil){
                    //add plus btn
                    let plusBtn: UIButton = UIButton(frame: CGRectMake(frame.size.width-70, 10, 30, 30))
                    plusBtn.setTitle("+", for: .normal)
                    plusBtn.setTitleColor(.black, for: .normal)
                    plusBtn.backgroundColor = .white
                    plusBtn.addTarget(self, action: #selector(SoalController.btnTapped(sender:)), for: .touchUpInside)
                    headerView.addSubview(plusBtn)
                }
                return
            }
        }
        
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
