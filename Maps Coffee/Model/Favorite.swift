//
//  Favorite.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Favorite: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var site = ""
    @objc dynamic var phoneNumber = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    static func current(_ realm: Realm = uiRealm) -> Favorite? {
        
        return realm.objects(Favorite.self).first
    }
    
    static func getByID(_ id: String) -> Favorite? {
        
        let results = uiRealm.objects(Favorite.self).filter("id = %@", id)
        
        return results.first
    }
    
    static func all(_ realm: Realm = uiRealm) -> [Favorite]? {
        
        var list: [Favorite] = []
        
        list.append(contentsOf: uiRealm.objects(Favorite.self))
        
        return list
    }
    
    static func save(_ object: Favorite) {
        
        do {
            
            try uiRealm.write {
                
                uiRealm.add(object, update: true)
                
            }
            
        } catch  {
            
            assert(false, "Could not persist Favorite")
        }
    }
    
    static func saveAll(_ objects: List<Favorite>) {
        
        do {
            
            try uiRealm.write {
                
                uiRealm.add(objects, update: true)
            }
            
        } catch  {
            
            assert(false, "Could not persist Favorite")
        }
    }
    
    static func deleteObject(_ object: Favorite) {
        
        do {
            
            try uiRealm.write {
                
                uiRealm.delete(object)
            }
            
        } catch  {
            
            print("Could not persist Favorite")
        }
    }
}
