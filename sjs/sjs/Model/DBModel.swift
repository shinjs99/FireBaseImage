//
//  DBModel.swift
//  SwiftFirebase
//
//  Created by mac on 12/18/24.
//

import Foundation

class DBModel{
    var name: String
    var phone: String
    var image: String
    var relation: String
    var address: String
    init(name: String, phone: String, image: String, relation: String, address: String) {
        self.name = name
        self.phone = phone
        self.image = image
        self.relation = relation
        self.address = address
    }
}
