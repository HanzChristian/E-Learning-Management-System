//
//  UserModel.swift
//  skripsi
//
//  Created by Hanz Christian on 16/03/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserModel{
    var users = [User]()
    private var db = Firestore.firestore()
    
    //Take user ID
    func fetchUID() -> String?{
        return Auth.auth().currentUser?.uid
    }
    
    func fetchUser(completion: @escaping(User) -> ()){
        let id = fetchUID()
        
        guard let id = id else{
            return
        }
        
        db.collection("users").whereField("uid", isEqualTo: "\(id)").getDocuments{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> User in
                
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let role = data["role"] as? String ?? ""
                let id = data["uid"] as? String ?? ""
                print("fetchuser 2")
                return User(name: name, role: role, id: id)
            }
            completion(self.users.first!)
        }
    }
    
}
