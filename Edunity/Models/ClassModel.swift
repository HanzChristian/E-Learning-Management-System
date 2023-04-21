//
//  classModel.swift
//  skripsi
//
//  Created by Hanz Christian on 16/03/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ClassModel{
    let userModel = UserModel()
    private var db = Firestore.firestore()
    
    
    func fetchClassGuru(completion: @escaping (Class) -> ()) {
        let id = userModel.fetchUID()
        
        db.collection("class").whereField("uid", isEqualTo: "\(id!)").getDocuments { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("No document")
                return
            }
            if (documents.count == 0){
                print("Document kosong!")
                return
            }
            
            // Download all the class images in parallel
            let imageDownloadGroup = DispatchGroup()
            var imageDownloads = [String: UIImage]()
            for document in documents {
                let data = document.data()
                let imgURL = data["imgURL"] as? String ?? ""
                
                imageDownloadGroup.enter()
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(imgURL)
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    defer {
                        imageDownloadGroup.leave()
                    }
                    guard let imageData = data, error == nil, let image = UIImage(data: imageData) else {
                        print("Error downloading image for class \(document.documentID): \(error?.localizedDescription ?? "")")
                        return
                    }
                    imageDownloads[imgURL] = image
                }
            }
            
            // Wait images to be downloaded, then fetch
            imageDownloadGroup.notify(queue: DispatchQueue.main) {
                var classes = [Class]()
                for document in documents {
                    let data = document.data()
                    let className = data["nameClass"] as? String ?? ""
                    let classDesc = data["descClass"] as? String ?? ""
                    let classModule = data["modulCount"] as? Int ?? 0
                    let classEnrollment = data["enrollmentKey"] as? String ?? ""
                    let imgURL = data["imgURL"] as? String ?? ""
                    let classid = data["classid"] as? String ?? ""
                    
                    // Get the downloaded image for this class
                    guard let classImg = imageDownloads[imgURL] else {
                        print("Error: no downloaded image for class \(document.documentID)")
                        continue
                    }
                    
                    let eachClass = Class(className: className, classDesc: classDesc, classModule: classModule, classEnrollment: classEnrollment, classImg: classImg, classImgString: imgURL, classid: classid)
                    
                    completion(eachClass)
                }
                
                
            }
        }
    }
    
    
    func fetchClassMurid(completion: @escaping (Class) -> ()) {
        let id = userModel.fetchUID()
        
        db.collection("muridClass").whereField("uidMurid", isEqualTo: "\(id!)").getDocuments{ querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                print("No document")
                return
            }
            
            // Download all the class images in parallel
            let imageDownloadGroup = DispatchGroup()
            var imageDownloads = [String: UIImage]()
            for document in documents {
                let data = document.data()
                let imgURL = data["imgURL"] as? String ?? ""
                
                imageDownloadGroup.enter()
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(imgURL)
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    defer {
                        imageDownloadGroup.leave()
                    }
                    guard let imageData = data, error == nil, let image = UIImage(data: imageData) else {
                        print("Error downloading image for class \(document.documentID): \(error?.localizedDescription ?? "")")
                        return
                    }
                    imageDownloads[imgURL] = image
                }
            }
            
            imageDownloadGroup.notify(queue: DispatchQueue.main) {
                var classes = [Class]()
                for document in documents {
                    let data = document.data()
                    let className = data["nameClass"] as? String ?? ""
                    let classDesc = data["descClass"] as? String ?? ""
                    let classModule = data["modulCount"] as? Int ?? 0
                    let classEnrollment = data["enrollmentKey"] as? String ?? ""
                    let imgURL = data["imgURL"] as? String ?? ""
                    let classid = data["classid"] as? String ?? ""
                    
                    guard let classImg = imageDownloads[imgURL] else {
                        print("Error: no downloaded image for class \(document.documentID)")
                        continue
                    }
                    
                    let eachClass = Class(className: className, classDesc: classDesc, classModule: classModule, classEnrollment: classEnrollment, classImg: classImg, classImgString: imgURL, classid: classid)
                    
                    completion(eachClass)
                }
            }
        }
    }
    
    func fetchClassAll(completion: @escaping (Class) -> ()) {
        
        //check if muridClass is exist
        db.collection("muridClass").getDocuments { querySnapshot, error in
            guard let document = querySnapshot?.documents else {
                print("No document nieee")
                return
            }
            
            var sameMuridClass = Set<String>()
            
            //loop for all classid and uidMurid in muridClass
            for document in document {
                let data = document.data()
                let classid = data["classid"] as? String ?? ""
                let uidMurid = data["uidMurid"] as? String ?? ""
                sameMuridClass.insert("\(classid)-\(uidMurid)")
            }
            
            self.db.collection("class").getDocuments { querySnapshot, error in
                guard let document = querySnapshot?.documents else {
                    print("No document nieee")
                    return
                }
                
                // Download all the images in parallel
                let imageDownloadGroup = DispatchGroup()
                var imageDownloads = [String: UIImage]()
                for document in document {
                    let data = document.data()
                    let imgURL = data["imgURL"] as? String ?? ""
                    
                    imageDownloadGroup.enter()
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(imgURL)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        defer {
                            imageDownloadGroup.leave()
                        }
                        guard let imageData = data, error == nil, let image = UIImage(data: imageData) else {
                            print("Error downloading image for class \(document.documentID): \(error?.localizedDescription ?? "")")
                            return
                        }
                        imageDownloads[imgURL] = image
                    }
                }
                
                // Wait for all the image downloads to complete before processing the query results
                imageDownloadGroup.notify(queue: DispatchQueue.main) {
        
                    for document in document {
                        let data = document.data()
                        let className = data["nameClass"] as? String ?? ""
                        let classDesc = data["descClass"] as? String ?? ""
                        let classModule = data["modulCount"] as? Int ?? 0
                        let classEnrollment = data["enrollmentKey"] as? String ?? ""
                        let imgURL = data["imgURL"] as? String ?? ""
                        let classid = data["classid"] as? String ?? ""
                        
                        // Get the downloaded image for this class
                        guard let classImg = imageDownloads[imgURL] else {
                            print("Error: no downloaded image for class \(document.documentID)")
                            continue
                        }
                        
                        //get murid uid
                        let uidMurid = Auth.auth().currentUser?.uid ?? ""
                        
                        //check if same classid & muridid then skip
                        if sameMuridClass.contains("\(classid)-\(uidMurid)") {
                            continue
                        }
                        
                        let eachClass = Class(className: className, classDesc: classDesc, classModule: classModule, classEnrollment: classEnrollment, classImg: classImg, classImgString: imgURL, classid: classid)
                    
                        completion(eachClass)
                    }
                    print("berhasil")
                }
            }
        }
    }


    
    func fetchSelectedClass(completion: @escaping(Class) -> ()){
        
        db.collection("class").whereField("classid", isEqualTo: "\(SelectedClass.selectedClass.classPath)").addSnapshotListener{ [self] querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            for document in documents{
                print("documents \(document.data())")
                let data = document.data()
                let className = data["nameClass"] as? String ?? ""
                let classDesc = data["descClass"] as? String ?? ""
                let classModule = data["modulCount"] as? Int ?? 0
                let classEnrollment = data["enrollmentKey"] as? String ?? ""
                let imgURL = data["imgURL"] as? String ?? ""
                let classid = data["classid"] as? String ?? ""
                var retrievedImage: UIImage?
                
                print("ini imgrul = \(imgURL)")
                
                //take UIImage from imgURL
                let storageRef = Storage.storage().reference()
                let fileRef = storageRef.child(imgURL)
                
                print("ini fileref : \(fileRef)")
                
                fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    // Check error
                    if error == nil && data != nil{
                        // make UIImage
                        retrievedImage = UIImage(data: data!)
                        let eachClass = Class(className: className, classDesc: classDesc, classModule: classModule, classEnrollment: classEnrollment, classImg: retrievedImage!,classImgString: imgURL,classid: classid)
                        
                        //                        classes.append(eachClass)
                        completion(eachClass)
                    }
                    else{
                        print("Data image tidak ada/error\n error = \(error) & data = \(data)")
                    }
                }
                
            }
            
        }
    }
    
}

