//
//  OzoneNetworkError.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/5.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit

class OzoneNetworkError: Error {
    
    enum Errortpe {
        case systemError(error: Error)
        case businessError(show:Bool,errorStr:String)
    }
    
    
}
