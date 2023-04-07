//
//  SoalModel.swift
//  skripsi
//
//  Created by Hanz Christian on 07/04/23.
//

import Foundation
import FirebaseFirestore

class SoalModel{
    
    let db = Firestore.firestore()
    
    func fetchAllSoal(completion: @escaping(Soal) -> ()){
        db.collection("tes").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)").order(by: "timestamp",descending: false).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            for document in documents{
                let listofQuestion = document.data()["listofQuestion"] as? [[String:Any]]
                
                for question in listofQuestion ?? []{
                    let soalAnswerA = question["soalAnswerA"] as? String ?? ""
                    let soalAnswerB = question["soalAnswerB"] as? String ?? ""
                    let soalAnswerC = question["soalAnswerC"] as? String ?? ""
                    let soalAnswerD = question["soalAnswerD"] as? String ?? ""
                    let soalCorrectAns = question["soalCorrectAns"] as? String ?? ""
                    let soalQuestion = question["soalQuestion"] as? String ?? ""
                    
                    let eachSoal = Soal(soalQuestion: soalQuestion, soalAnswerA: soalAnswerA, soalAnswerB: soalAnswerB, soalAnswerC: soalAnswerC, soalAnswerD: soalAnswerD, soalCorrectAns: soalCorrectAns)
                    
                    completion(eachSoal)
                }
            }
        }
    }
    
}
