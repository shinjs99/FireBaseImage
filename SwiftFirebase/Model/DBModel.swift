//
//  DBModel.swift
//  SwiftFirebase
//
//  Created by mac on 12/18/24.
//

import Foundation

class DBModel : Codable{
    var id : String
    var name: String
    var phone: String
    var image: String
    var relation: String
    var address: String
    init(id : String, name: String, phone: String, image: String, relation: String, address: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.image = image
        self.relation = relation
        self.address = address
    }
}
