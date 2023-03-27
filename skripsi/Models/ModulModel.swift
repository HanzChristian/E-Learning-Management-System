//
//  ModulModel.swift
//  skripsi
//
//  Created by Hanz Christian on 24/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage



class ModulModel{
    var classModel = ClassModel()
    var classid: String?
    let db = Firestore.firestore()
    var userModel = UserModel()
    
    
    //For fetching modul
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
                let modulid = data["modulid"] as? String ?? ""
                let classid = data["classid"] as? String ?? ""
                print("ini modulidnya di fetchmodul = \(modulid)")
                let eachModul = Modul(modulName: modulName, modulDesc: modulDesc, modulFile: modulFile,modulid: modulid)
                completion(eachModul)
            }
        }
    }
    
    //for fetching tugas in Guru, where it is based on Class id
    func fetchTugasGuru(completion: @escaping(Tugas) -> ()){
        
        db.collection("modul").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            //kurang file di firestorage, karna gatau retrieve untuk download gimana
            for document in documents{
                let data = document.data()
                let tugasName = data["nameTugas"] as? String ?? ""
                let tugasDesc = data["descTugas"] as? String ?? ""
                let tugasid = data["tugasid"] as? String ?? ""
            
                let eachTugas = Tugas(tugasName: tugasName, tugasDesc: tugasDesc, tugasid: tugasid)
                completion(eachTugas)
            }
        }
    }
    
    //for fetching in Murid, where it is based on Modul id
    func fetchTugasMurid(completion: @escaping(Tugas) -> ()){
        
        db.collection("modul").whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            //kurang file di firestorage, karna gatau retrieve untuk download gimana
            for document in documents{
                let data = document.data()
                let tugasName = data["nameTugas"] as? String ?? ""
                let tugasDesc = data["descTugas"] as? String ?? ""
                let tugasid = data["tugasid"] as? String ?? ""
            
                let eachTugas = Tugas(tugasName: tugasName, tugasDesc: tugasDesc, tugasid: tugasid)
                completion(eachTugas)
            }
        }
    }
    
    //check if spesific murid already submit tugas file
    func fetchTugasCondition(completion: @escaping(TugasMurid) -> ()){
        let id = userModel.fetchUID()
        db.collection("muridTugas").whereField("userid", isEqualTo: "\(id!)").whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            for document in documents{
                let data = document.data()
                let muridName = data["userName"] as? String ?? ""
                let tugasName = data["displayedFile"] as? String ?? ""
                let tugasDate = data["dateSubmitted"] as? String ?? ""
                let tugasFile = data["fileTugas"] as? String ?? ""
            
                let eachTugas = TugasMurid(muridName: muridName, tugasName: tugasName, tugasDate: tugasDate, tugasFile: tugasFile)
                completion(eachTugas)
            }
            
        }
    }
    
    //fetch all tugas based on modul in Guru
    func fetchAllTugas(completion: @escaping(TugasMurid) -> ()){
        db.collection("muridTugas").whereField("modulid", isEqualTo: "\(SelectedModul.selectedModul.modulPath)").addSnapshotListener { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            for document in documents{
                let data = document.data()
                let muridName = data["userName"] as? String ?? ""
                let tugasName = data["displayedFile"] as? String ?? ""
                let tugasDate = data["dateSubmitted"] as? String ?? ""
                let tugasFile = data["fileTugas"] as? String ?? ""
            
                let eachTugas = TugasMurid(muridName: muridName, tugasName: tugasName, tugasDate: tugasDate, tugasFile: tugasFile)
                completion(eachTugas)
            }
            
        }
    }
    
    
    
}
