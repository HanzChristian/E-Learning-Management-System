//
//  TesMuridModel.swift
//  skripsi
//
//  Created by Hanz Christian on 10/04/23.
//

import Foundation
import FirebaseFirestore

class TesMuridModel{
    let db = Firestore.firestore()
    let userModel = UserModel()
    
    
    func fetchTesCondition(completion: @escaping (TesMurid?, Error?) -> Void) {
        
        let id = userModel.fetchUID()
        
        db.collection("muridTes")
            .whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)")
            .whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)").whereField("userid", isEqualTo: id!)
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
                    let muridName = data["name"] as? String ?? ""
                    let tesScore = data["score"] as? Int ?? 0
                    
                    let eachTesMurid = TesMurid(muridName: muridName, tesScore: tesScore)
                    
                    completion(eachTesMurid, nil)
                    return
                }

                // Return error
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents parsed"]))
            }
    }
    
    func fetchHasilTes(completion: @escaping (TesMurid?, Error?) -> Void) {
        db.collection("muridTes")
            .whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)")
            .whereField("tesid", isEqualTo: "\(SelectedTes.selectedTes.tesPath)")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    // Return the error if there is an issue with the query
                    completion(nil, error)
                    print("masuk error sene gyan")
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
                    let muridName = data["name"] as? String ?? ""
                    let tesScore = data["score"] as? Int ?? 0
                    
                    let eachTesMurid = TesMurid(muridName: muridName, tesScore: tesScore)
                    print("masuk sene gyan")
                    
                    completion(eachTesMurid, nil)
                    return
                }

                // Return error
                completion(nil, NSError(domain: "MyApp", code: 0, userInfo: [NSLocalizedDescriptionKey: "No documents parsed"]))
            }
    }
}
