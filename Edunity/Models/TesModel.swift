//
//  TesModel.swift
//  skripsi
//
//  Created by Hanz Christian on 06/04/23.
//

import Foundation
import FirebaseFirestore

class TesModel{
    let db = Firestore.firestore()
    
    // Show in GuruClass
    func fetchAllTes(completion: @escaping(Tes) -> ()){
        db.collection("tes").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").order(by: "timestamp",descending: false).addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            for document in documents{
                let data = document.data()
                let tesName = data["nameTes"] as? String ?? ""
                let tesDesc = data["descTes"] as? String ?? ""
                let modulName = data["nameModul"] as? String ?? ""
                let modulid = data["modulid"] as? String ?? ""
                let tesid = data["tesid"] as? String ?? ""
                let classid = data["classid"] as? String ?? ""
                
                let eachTes = Tes(tesName: tesName, tesDesc: tesDesc, modulName: modulName, modulid: modulid, tesid: tesid, classid: classid)
                
                completion(eachTes)
            }
        }
    }
    
    func fetchSpesificTes(completion: @escaping (Tes?, Error?) -> Void) {
        db.collection("tes")
            .whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)")
            .whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)")
            .getDocuments { querySnapshot, error in
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

                // If there is at least one document, parse it and return it
                for document in documents {
                    let data = document.data()
                    let tesName = data["nameTes"] as? String ?? ""
                    let tesDesc = data["descTes"] as? String ?? ""
                    let modulName = data["nameModul"] as? String ?? ""
                    let modulid = data["modulid"] as? String ?? ""
                    let tesid = data["tesid"] as? String ?? ""
                    let classid = data["classid"] as? String ?? ""

                    let eachTes = Tes(tesName: tesName, tesDesc: tesDesc, modulName: modulName, modulid: modulid, tesid: tesid, classid: classid)

                    completion(eachTes, nil)
                    return
                }

                // Return error
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents parsed"]))
            }
    }

}
