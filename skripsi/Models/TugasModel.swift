//
//  TugasModel.swift
//  skripsi
//
//  Created by Hanz Christian on 25/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class TugasModel{
    let db = Firestore.firestore()
    
    func fetchAllTugas(completion: @escaping(Tugas) -> ()){
        db.collection("tugas").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").addSnapshotListener{
            querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            for document in documents{
                let data = document.data()
                let tugasName = data["nameTugas"] as? String ?? ""
                let tugasDesc = data["descTugas"] as? String ?? ""
                let modulid = data["modulid"] as? String ?? ""
                let tugasid = data["tugasid"] as? String ?? ""
                let classid = data["classid"] as? String ?? ""
                
                let eachModul = Tugas(tugasName: tugasName, tugasDesc: tugasDesc, tugasid: tugasid, modulid: modulid, classid: classid)
                completion(eachModul)
            }
        }
    }
}

