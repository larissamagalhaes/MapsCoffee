//
//  PlaceService.swift
//  Maps Coffee
//
//  Created by Larissa Magalhaes on 2019-05-06.
//  Copyright © 2019 Larissa Magalhaes. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol PlaceServiceDelegate {
    
    func getDetailsPlaceSuccessful(_ place: Place)
    func getDetailsPlaceFailed(_ data: Data?)
}

class PlaceService {
    
    let delegate: PlaceServiceDelegate
    
    init(delegate: PlaceServiceDelegate) {
        
        self.delegate = delegate
    }
    
    func getDetails(from id: String) {
        
        let url = baseURL + "/place/details/json"
        
        let parameters: [String : Any] = ["placeid": id, "key": "AIzaSyB2pcmC0RETrG_mCDbSlf58Zz6AWdtsvW0"]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseObject(keyPath: "result") { (response: DataResponse<Place>) -> Void in
            
            switch response.result {
                
            case .success:
                
                if let result = response.result.value {
                    Place.save(result)
                    self.delegate.getDetailsPlaceSuccessful(result)
                }
                
            case .failure:
                
                self.delegate.getDetailsPlaceFailed(response.data)
            }
        }
    }
}
