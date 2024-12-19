//
//  DeleteModel.swift
//  SwiftFirebase
//
//  Created by 하동훈 on 19/12/2024.
//

import Foundation
import Firebase

struct DeleteModel{
    let db = Firestore.firestore()
    
    func deleteItems(documentId: String) -> Bool{
        
        var status: Bool = true
        
        db.collection("memos").document(documentId).delete(){
            error in
                if error != nil{
                    status = false
                }else{
                    status = true
                }
        }
        
        return status
    }
}
