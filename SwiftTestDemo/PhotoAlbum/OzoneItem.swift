//
//  OzoneItem.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/29.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Photos
class OzoneItem: NSObject {
    var select:Bool = false;
    var asset:PHAsset! = nil
    init(_ assset:PHAsset,select:Bool) {
        self.select = select;
        self.asset = assset;
    }
}
