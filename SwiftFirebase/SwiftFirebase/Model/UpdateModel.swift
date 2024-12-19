//
//  UpdateModel.swift
//  SwiftFirebase
//
//  Created by 하동훈 on 19/12/2024.
//

import Foundation
import Firebase

struct UpdateModel {
    let db = Firestore.firestore()
    
    func updateItems(documentId: String, name: String, phone: String, address: String, relation: String, image: String) -> Bool {
        
        var status: Bool = true
        
        db.collection("memos").document(documentId).updateData([
            "name" : name,
            "phone" : phone,
            "address" : address,
            "relation" : relation,
            "image" : image
        ]){error in
            if error != nil {
                status = false
            }else{
                status = true
            }
        }
        
        return status
    }
}
