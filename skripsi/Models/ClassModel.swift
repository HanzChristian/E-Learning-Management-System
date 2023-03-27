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
    
    func fetchClassGuru(completion: @escaping(Class) -> ()){
        let id = userModel.fetchUID()
        
        db.collection("class").whereField("uid", isEqualTo: "\(id!)").addSnapshotListener{ [self] querySnapshot, error in
            
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
    
    func fetchClassMurid(completion: @escaping(Class) -> ()){
        let id = userModel.fetchUID()
        
        db.collection("muridClass").whereField("uidMurid", isEqualTo: "\(id!)").addSnapshotListener{ [self] querySnapshot, error in
            
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
    
    func fetchClassAll(completion: @escaping(Class) -> ()){
        
        db.collection("class").addSnapshotListener{ [self] querySnapshot, error in
            
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
                        
                        completion(eachClass)
                    }
                    else{
                        print("Data image tidak ada/error\n error = \(error) & data = \(data)")
                    }
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
