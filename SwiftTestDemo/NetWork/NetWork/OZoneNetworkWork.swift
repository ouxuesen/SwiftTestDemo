//
//  OZoneNetworkWork.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/4.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Alamofire

class OZoneNetworkWork: NSObject {
    func getRequset(_ Complete:@escaping(Dictionary<String, Any>?,Bool)->())-> DataRequest {
        return  Alamofire.request(url_MerchantsMList, method: .get, parameters:["pageSize":20,"currentPageNo":0,"showType":1], encoding: JSONEncoding.default, headers: SessionManager.defaultHTTPHeaders).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success(_):
                print("successful")
                if let result = response.result.value as? Dictionary<String,Any>{
                   Complete(result,true)
                }
            case .failure(_):
                print("failure")
                 Complete(nil,false)
                break
            }
        })
    }
}
