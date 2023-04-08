//
//  MakeSoalController.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class MakeSoalController:UIViewController{
    // MARK: - Variables & Outlet
    
    @IBOutlet weak var tableView: UITableView!
    var jumlahSoal = [JumlahSoal]()
    let cellTitle = ["Pertanyaan","Jawaban A","Jawaban B","Jawaban C","Jawaban D","Jawaban Benar"]
    
    let db = Firestore.firestore()
    let tesModel = TesModel()
    
    var questionTVC: QuestionTVC?
    var answerATVC: AnswerATVC?
    var answerBTVC: AnswerBTVC?
    var answerCTVC: AnswerCTVC?
    var answerDTVC: AnswerDTVC?
    var correctAnswerTVC: CorrectAnswerTVC?
    
}
// MARK: - View Life Cycle
extension MakeSoalController{
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setNavItem()
        
        let nibQuestion = UINib(nibName: "QuestionTVC", bundle: nil)
        tableView.register(nibQuestion, forCellReuseIdentifier: "QuestionTVC")
        let nibAnswerA = UINib(nibName: "AnswerATVC", bundle: nil)
        tableView.register(nibAnswerA, forCellReuseIdentifier: "AnswerATVC")
        let nibAnswerB = UINib(nibName: "AnswerBTVC", bundle: nil)
        tableView.register(nibAnswerB, forCellReuseIdentifier: "AnswerBTVC")
        let nibAnswerC = UINib(nibName: "AnswerCTVC", bundle: nil)
        tableView.register(nibAnswerC, forCellReuseIdentifier: "AnswerCTVC")
        let nibAnswerD = UINib(nibName: "AnswerDTVC", bundle: nil)
        tableView.register(nibAnswerD, forCellReuseIdentifier: "AnswerDTVC")
        let nibCorrectAns = UINib(nibName: "CorrectAnswerTVC", bundle: nil)
        tableView.register(nibCorrectAns, forCellReuseIdentifier: "CorrectAnswerTVC")
        
    }
}
// MARK: - Functions
extension MakeSoalController{
    private func setNavItem(){
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Soal"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batal", style: .plain, target: self, action: #selector(dismissSelf))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(saveItem))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0.251, green: 0.055, blue: 0.196, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 28)]
    }
    
    @objc private func dismissSelf(){
        self.dismiss(animated: true,completion:nil)
    }
    
    @objc private func saveItem(){
        if let question = questionTVC?.questionTF.text,!question.isEmpty,let answerA = answerATVC?.aTF.text,!answerA.isEmpty,let answerB = answerBTVC?.bTF.text,!answerB.isEmpty,let answerC = answerCTVC?.cTF.text,!answerC.isEmpty,let answerD = answerDTVC?.dTF.text,!answerD.isEmpty,let correctAns = correctAnswerTVC?.correctLbl.text,!correctAns.isEmpty{
            
            let soal = Soal(soalQuestion: question, soalAnswerA: answerA, soalAnswerB: answerB, soalAnswerC: answerC, soalAnswerD: answerD, soalCorrectAns: correctAns)
            
            let tesRef = db.collection("tes").whereField("tesid", isEqualTo: SelectedTes.selectedTes.tesPath)
            
            tesRef.getDocuments { (querySnapshot,error) in
                if let error = error {
                    print("Error getting document: \(error)")
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("Tes document does not exist")
                    return
                }
                
                if var listofQuestion = document.data()["listofQuestion"] as? [[String:Any]] {
                    //append the soal into listofquestion
                    let newSoal = [
                        "soalQuestion": soal.soalQuestion,
                        "soalAnswerA": soal.soalAnswerA,
                        "soalAnswerB": soal.soalAnswerB,
                        "soalAnswerC": soal.soalAnswerC,
                        "soalAnswerD": soal.soalAnswerD,
                        "soalCorrectAns": soal.soalCorrectAns
                    ]
                    listofQuestion.append(newSoal)
                    
                    //update the document
                    document.reference.updateData(["listofQuestion": listofQuestion]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document updated successfully")
                        }
                    }
                } else {
                    // Make a new listofquestion in database
                    let newSoal = [
                        "soalQuestion": soal.soalQuestion,
                        "soalAnswerA": soal.soalAnswerA,
                        "soalAnswerB": soal.soalAnswerB,
                        "soalAnswerC": soal.soalAnswerC,
                        "soalAnswerD": soal.soalAnswerD,
                        "soalCorrectAns": soal.soalCorrectAns
                    ]
                    let listofquestion = [newSoal]
                    
                    // Update with new listofquestion field
                    document.reference.updateData(["listofQuestion": listofquestion]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document updated successfully")
                        }
                    }
                }
            }
            
            print("saved")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshSoal"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshModul"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshData"), object: nil)
            
            dismissSelf()
        } else {
            print("ga masuk bro")
        }
        
    }
}
// MARK: - TableView Delegate & Datasource
extension MakeSoalController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTVC", for: indexPath) as! QuestionTVC
            
            questionTVC = cell
            
            return questionTVC!
            
        }else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerATVC", for: indexPath) as! AnswerATVC
            
            answerATVC = cell
            
            return answerATVC!
            
        }else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerBTVC", for: indexPath) as! AnswerBTVC
            
            answerBTVC = cell
            
            return answerBTVC!
            
        }else if(indexPath.section == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCTVC", for: indexPath) as! AnswerCTVC
            
            answerCTVC = cell
            
            return answerCTVC!
            
        }else if(indexPath.section == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerDTVC", for: indexPath) as! AnswerDTVC
            
            answerDTVC = cell
            
            return answerDTVC!
            
        }else if(indexPath.section == 5){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CorrectAnswerTVC", for: indexPath) as! CorrectAnswerTVC
            
            correctAnswerTVC = cell
            
            return correctAnswerTVC!
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 63
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 5, y: 0, width: tableView.bounds.size.width, height: 5))
        sectionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = cellTitle[section]
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CorrectAnswerTVC{
            if !cell.isFirstResponder{
                _ = cell.becomeFirstResponder()
            }
        }
    }
}
