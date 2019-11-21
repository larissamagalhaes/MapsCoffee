//
//  Place.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Place: Object, Mappable {
    
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
    
    func mapping(map: Map) {
    
        id <- map["place_id"]
        name <- map["name"]
        address <- map["formatted_address"]
        site <- map["website"]
        phoneNumber <- map["formatted_phone_number"]
        latitude <- map["geometry.location.lat"]
        longitude <- map["geometry.location.lng"]
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    static func current(_ realm: Realm = uiRealm) -> Place? {
        
        return realm.objects(Place.self).first
    }
    
    static func getByID(_ id: String) -> Place? {
        
        let results = uiRealm.objects(Place.self).filter("id = %@", id)
        
        return results.first
    }
    
    static func all(_ realm: Realm = uiRealm) -> [Place]? {
        
        var list: [Place] = []
        
        list.append(contentsOf: uiRealm.objects(Place.self))
        
        return list
    }
    
    static func save(_ object: Place) {
        
        do {
            
            try uiRealm.write {
                
                uiRealm.add(object, update: true)
                
            }
            
        } catch  {
            
            assert(false, "Could not persist Place")
        }
    }
    
    static func saveAll(_ objects: List<Place>) {
        
        do {
            
            try uiRealm.write {
                
                uiRealm.add(objects, update: true)
            }
            
        } catch  {
            
            assert(false, "Could not persist Place")
        }
    }
    
    static func deleteObject(_ object: Place) {
        
        do {
            
            try uiRealm.write {
                
                uiRealm.delete(object)
            }
            
        } catch  {
            
            print("Could not persist Place")
        }
    }
}
