//
//  QueryModel.swift
//  SwiftFirebase
//
//  Created by 하동훈 on 19/12/2024.
//

import Foundation
import Firebase

protocol QueryModelProtocol{
    func itemDownloaded(items: [DBModel])
}

@MainActor
struct QueryModel {
    
    var delegate: QueryModelProtocol!
    let db = Firestore.firestore()
    
    func downloadItems(){
        var locations: [DBModel] = []
        
        db.collection("memos")
            .order(by: "name")
            .getDocuments(completion: {(querySnapshot, err) in
                    if let err = err{
                        print("Error getting documents : \(err)")
                    }else{
                        print("Data is downloaded")
                        for document in querySnapshot!.documents{
                            guard let data = document.data()["name"] else{return}
                            let query = DBModel(documentId: document.documentID,
                                                name: document.data()["name"] as! String,
                                                phone: document.data()["phone"] as! String,
                                                address: document.data()["address"] as! String,
                                                relation: document.data()["relation"] as! String,
                                                image: document.data()["image"] as! String)
                            print(query)
                            locations.append(query)
                        }
                        self.delegate.itemDownloaded(items: locations)
                    }
                })
    }// downloadItems
    
    
} // QueryModel
