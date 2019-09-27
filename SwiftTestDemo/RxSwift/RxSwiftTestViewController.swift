//
//  RxSwiftTestViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/18.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import RxSwift

class RxSwiftTestViewController: UIViewController {

    lazy var button:UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("点击", for: .normal)
        return button
    }()
    var textField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    



}
