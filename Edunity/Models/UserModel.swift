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
        
        db.collection("users").whereField("uid", isEqualTo: "\(id)").getDocuments{ [self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else{
                print("No document")
                return
            }
            
            for document in documents{
                print("documents \(document.data())")
                let data = document.data()
                let name = data["name"] as? String ?? ""
                let role = data["role"] as? String ?? ""
                let id = data["uid"] as? String ?? ""
                let user = User(name: name, role: role, id: id)
                users.append(user)
                completion(self.users.first!)
            }
        }
    }
    
}
