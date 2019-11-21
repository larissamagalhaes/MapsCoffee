//
//  HomeService.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol HomeServiceDelegate {
    
    func getOpenPlacesSuccessful(_ places: [Place])
    func getOpenPlacesFailed(_ data: Data?)
}

class HomeService {
    
    let delegate: HomeServiceDelegate
    
    init(delegate: HomeServiceDelegate) {
        
        self.delegate = delegate
    }
    
    func getOpenPlaces(from location: String) {
        
        let url = baseURL + "/place/nearbysearch/json"
        
        let parameters: [String : Any] = ["location": location, "radius": 1500, "type": "cafe", "opennow": true, "key": "AIzaSyB2pcmC0RETrG_mCDbSlf58Zz6AWdtsvW0"]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseArray(keyPath: "results") { (response: DataResponse<[Place]>) -> Void in
            
            switch response.result {
                
            case .success:
                
                if let result = response.result.value {
                    self.delegate.getOpenPlacesSuccessful(result)
                }
                
            case .failure:
                
                self.delegate.getOpenPlacesFailed(response.data)
            }
        }
    }
}

