//
//  TestHandyJson.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/12.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import HandyJSON

class TestHandyJson: NSObject {
    func textChage() {
        let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
        if let object = BasicTypes.deserialize(from: jsonString) {
           print(123,object)
        }
    }
    func testNetworkChage() {
        _ = OZoneNetworkWork().getRequset({ (jsonDic, result) in
            if let tempJson = jsonDic{
                print(tempJson)
                if  let model =  OzoneConversion.ListModelConversion(tempJson){
                    print("",model)
                }
            }else{
                
            }
          
        })
    }
}
struct BasicTypes: HandyJSON {
    var int: Int = 2
    var doubleOptional: Double?
    var stringImplicitlyUnwrapped: String!

}


