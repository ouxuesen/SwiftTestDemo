//
//  ThenTestViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/29.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Then

class ThenTestViewController: UIViewController {

    var lable = UILabel().with {
        $0.text = "测试"
        $0.textColor = UIColor.red
    }
  var array:Array = Array().with { (array) in
        array.append(123)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(lable)
        view.backgroundColor = UIColor.white
        lable.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        print(array)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
