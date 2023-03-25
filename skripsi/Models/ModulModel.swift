//
//  ModulModel.swift
//  skripsi
//
//  Created by Hanz Christian on 24/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

var classModel = ClassModel()
var classid: String?
var moduls = [Modul]()
let db = Firestore.firestore()

class ModulModel{
    
    func fetchModul(completion: @escaping(Modul) -> ()){
        
        db.collection("modul").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            //kurang file di firestorage, karna gatau retrieve untuk download gimana
            for document in documents{
                let data = document.data()
                let modulName = data["nameModul"] as? String ?? ""
                let modulDesc = data["descModul"] as? String ?? ""
                let modulFile = data["fileModul"] as? String ?? ""
                let eachModul = Modul(modulName: modulName, modulDesc: modulDesc, modulFile: modulFile)
                completion(eachModul)
            }
            
            
            
        }
        
    }
    
    
}
