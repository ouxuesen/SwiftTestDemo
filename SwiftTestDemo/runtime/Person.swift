//
//  Person.swift
//  Runtime
//
//  Created by 徐丽 on 2019/9/4.
//  Copyright © 2019 徐丽. All rights reserved.
//

import UIKit
class Animal : NSObject {
    @objc  func run() {
        print("run")
    }
}
class Person: NSObject {
    func test() -> Void{
        
    }
    override class func resolveInstanceMethod(_ sel: Selector!) -> Bool {
        guard let method = class_getInstanceMethod(self, #selector(other))  else {
            return super.resolveInstanceMethod(sel)
        }
        return class_addMethod(self, Selector("ss"), method_getImplementation(method), method_getTypeEncoding(method))
    }
    
    @objc func other() -> Void {
        print("other")
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return Animal()
    }
//    override func forwardingTarget(for aSelector: Selector!) -> Any? {
//        return Animal()
//    }
}
