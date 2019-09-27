//
//  AutionListModel.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/12.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import HandyJSON
//Codable

class AutionListModel:HandyJSON {
    var entity:[YXMerchantDetailModel]?
     required init() {}
}
class YXMerchantDetailModel:HandyJSON {
 
    var merNo:String?
    var merName:String?
    var shopPrice:String?
    var cuisine:String?
    var storePicUrl:[String]?
    var latitude:String?
    var longitude:String?
    var distance:String?
    var businessHours:String?
    var bookHours:String?
    var wifi:Int?
    var park:Int?
    var privateRoom:Int?
    var storeDetail:Int?
    var recommendation:[RecommendationModel]?
    required init() {}
}
class RecommendationModel:HandyJSON{
 
    var dishName:String?
    var dishPicUrl:String?
     required init() {}
}
