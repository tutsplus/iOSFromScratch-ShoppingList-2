//
//  Item.swift
//  Shopping List
//
//  Created by Bart Jacobs on 12/12/15.
//  Copyright © 2015 Envato Tuts+. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {

    var uuid: String = NSUUID().UUIDString
    var name: String = ""
    var price: Float = 0.0
    var inShoppingList = false

    // MARK: -
    // MARK: Initialization
    init(name: String, price: Float) {
        super.init()
        
        self.name = name
        self.price = price
    }

    // MARK: -
    // MARK: NSCoding Protocol
    required init?(coder decoder: NSCoder) {
        super.init()
        
        if let archivedUuid = decoder.decodeObjectForKey("uuid") as? String {
            uuid = archivedUuid
        }
        
        if let archivedName = decoder.decodeObjectForKey("name") as? String {
            name = archivedName
        }
        
        price = decoder.decodeFloatForKey("price")
        inShoppingList = decoder.decodeBoolForKey("inShoppingList")
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(uuid, forKey: "uuid")
        coder.encodeObject(name, forKey: "name")
        coder.encodeFloat(price, forKey: "price")
        coder.encodeBool(inShoppingList, forKey: "inShoppingList")
    }

}
