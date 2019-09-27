//
//  OzoneConversion.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/3.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Foundation
class OzoneConversion: NSObject {
    
//    func conversionModel<T:Codable>(_ dicJosn:[String:Any],_ object:T.self) -> resulet:T{
//    do {
    
//    let city = try JSONDecoder().decode(City.self, from: jsonData)
//    print("city:", city)
//    } catch {
//    print(error.localizedDescription)
//    }
//    }
//      JSONDecoder().decode(AutionListModel.self.self, from: "123")
//    JSONDecoder().d(AutionListModel.self, from: jsonData)
    
class func ListModelConversion(_ data:Dictionary<String, Any>) -> AutionListModel?{
        if let object = AutionListModel.deserialize(from: data, designatedPath: "data") {
            print(123,object)
            return object
        }else{
            print("报错")
        }
        return nil
    }
}
