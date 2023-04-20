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
        db.collection("tes").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").whereField("tesid", isEqualTo: "\(SelectedTes.selectedTes.tesPath)").order(by: "count",descending: false).addSnapshotListener { querySnapshot, error in
            
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
//                    let count = question["count"] as? Int ?? 0
                    let eachSoal = Soal(soalQuestion: soalQuestion, soalAnswerA: soalAnswerA, soalAnswerB: soalAnswerB, soalAnswerC: soalAnswerC, soalAnswerD: soalAnswerD, soalCorrectAns: soalCorrectAns)
                    
                    completion(eachSoal)
                }
            }
        }
    }
    
    func fetchFixedSoal(completion: @escaping(Soal?, Error?) -> Void){
        db.collection("tes").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").whereField("tesid", isEqualTo: "\(SelectedTes.selectedTes.tesPath)").addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                // Return the error if there is an issue with the query
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                // Return an error if there are no documents found
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents found"]))
                return
            }
            
            for document in documents{
                let listofQuestion = document.data()["fixedQuestion"] as? [[String:Any]]
                
                for question in listofQuestion ?? []{
                    let soalAnswerA = question["soalAnswerA"] as? String ?? ""
                    let soalAnswerB = question["soalAnswerB"] as? String ?? ""
                    let soalAnswerC = question["soalAnswerC"] as? String ?? ""
                    let soalAnswerD = question["soalAnswerD"] as? String ?? ""
                    let soalCorrectAns = question["soalCorrectAns"] as? String ?? ""
                    let soalQuestion = question["soalQuestion"] as? String ?? ""
                    
                    let eachSoal = Soal(soalQuestion: soalQuestion, soalAnswerA: soalAnswerA, soalAnswerB: soalAnswerB, soalAnswerC: soalAnswerC, soalAnswerD: soalAnswerD, soalCorrectAns: soalCorrectAns)
                    
                    completion(eachSoal,nil)
                    return
                }
            }
            // Return error
            completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents parsed"]))
        }
    }
    
    func fetchAllFixedSoal(completion: @escaping([Soal]?, Error?) -> Void){
        db.collection("tes").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").whereField("tesid", isEqualTo: "\(SelectedTes.selectedTes.tesPath)").addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                // Return the error if there is an issue with the query
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                // Return an error if there are no documents found
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents found"]))
                return
            }
            
            var allSoal = [Soal]()
            
            for document in documents{
                let listofQuestion = document.data()["fixedQuestion"] as? [[String:Any]]
                
                for question in listofQuestion ?? []{
                    let soalAnswerA = question["soalAnswerA"] as? String ?? ""
                    let soalAnswerB = question["soalAnswerB"] as? String ?? ""
                    let soalAnswerC = question["soalAnswerC"] as? String ?? ""
                    let soalAnswerD = question["soalAnswerD"] as? String ?? ""
                    let soalCorrectAns = question["soalCorrectAns"] as? String ?? ""
                    let soalQuestion = question["soalQuestion"] as? String ?? ""
                    
                    let eachSoal = Soal(soalQuestion: soalQuestion, soalAnswerA: soalAnswerA, soalAnswerB: soalAnswerB, soalAnswerC: soalAnswerC, soalAnswerD: soalAnswerD, soalCorrectAns: soalCorrectAns)
                    
                    allSoal.append(eachSoal)
                }
                print("allsoal = \(allSoal)")
            }
            
            if allSoal.isEmpty{
                // Return error
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents parsed"]))
            }else{
                completion(allSoal,nil)
            }
        }
    }
    
    func fetchCheckSoal(completion: @escaping(Soal?, Error?) -> Void){
        db.collection("tes").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)").addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                // Return the error if there is an issue with the query
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                // Return an error if there are no documents found
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents found"]))
                return
            }
            
            for document in documents{
                let listofQuestion = document.data()["fixedQuestion"] as? [[String:Any]]
                
                for question in listofQuestion ?? []{
                    let soalAnswerA = question["soalAnswerA"] as? String ?? ""
                    let soalAnswerB = question["soalAnswerB"] as? String ?? ""
                    let soalAnswerC = question["soalAnswerC"] as? String ?? ""
                    let soalAnswerD = question["soalAnswerD"] as? String ?? ""
                    let soalCorrectAns = question["soalCorrectAns"] as? String ?? ""
                    let soalQuestion = question["soalQuestion"] as? String ?? ""
                    
                    let eachSoal = Soal(soalQuestion: soalQuestion, soalAnswerA: soalAnswerA, soalAnswerB: soalAnswerB, soalAnswerC: soalAnswerC, soalAnswerD: soalAnswerD, soalCorrectAns: soalCorrectAns)
                    
                    completion(eachSoal,nil)
                    return
                }
            }
            // Return error
            completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents parsed"]))
        }
    }
    
}
