//
//  BootomCollectionViewCell.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/3.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit

class CustmButton: UIButton {
    override var isSelected: Bool{
        didSet{
            if isSelected {
                backgroundColor = .red
            }else{
              backgroundColor = .white
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = .white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BootomCollectionViewCell: UICollectionViewCell {
    var currentIndex:Int = 0
    var  dataModel:DateModel?
    var  selectCallBack:((_ selectDate:Date)->())?
    
   lazy var leftButton:UIButton = {
        let btn:UIButton = BootomCollectionViewCell.creatTopButton(tag: 0, title: "午餐")
        btn.setImage(UIImage.init(named: "ic_booked_afternoon_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "ic_booked_afternoon_select"), for: .selected)
        btn.addTarget(self, action: #selector(topButtonClick), for: .touchUpInside)
        return btn
    }()
   lazy var rightButton:UIButton = {
        let btn:UIButton = BootomCollectionViewCell.creatTopButton(tag: 0, title: "晚餐")
        btn.setImage(UIImage.init(named: "ic_booked_evening_normal"), for: .normal)
        btn.setImage(UIImage.init(named: "ic_booked_evening_select"), for: .selected)
        btn.addTarget(self, action: #selector(topButtonClick), for: .touchUpInside)
        return btn
    }()
    class func creatTopButton(tag:Int,title:String) -> UIButton {
        let button = UIButton.init(type:.custom)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.setTitle(title, for: .normal)
        button.tag = tag
        return button
    }
    
   lazy var continerVIew:UIView = {
        let continerView = UIView.init()
        return continerView
    }()
   lazy var topContinerView:UIView = {
        let continerView = UIView.init()
        continerView.backgroundColor = .white
        continerView.isUserInteractionEnabled = true
        return continerView
    }()
    
    
    
    func creatSubButton(tag:Int,title:String) -> UIButton {
         let button = CustmButton.init(frame: CGRect.zero)
        button.addTarget(self, action: #selector(subButtonClick), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.tag = tag
        return button
    }
    func updateSubVIew(_ isleft:Bool) -> Void {

        for subview in continerVIew.subviews{
            subview.removeFromSuperview()
        }
        var souceArray = dataModel?.souceArray?[0]
        if !isleft{souceArray = dataModel?.souceArray?[1]}
        var count = 0
        var tempArray:Array = [CustmButton]()
        for data in souceArray ?? [] {
           let sub = creatSubButton(tag: count, title: data.dateToString("HH:mm"))
            continerVIew.addSubview(sub)
            tempArray.append(sub as! CustmButton)
            count += 1
        }
        if !tempArray.isEmpty {
            var leftView:CustmButton? = nil
            var topView:CustmButton? = nil
            let gaps:CGFloat = 5.0
            let rol_c = 4
            var count_1 = 0
            for cusView in tempArray
            {
                cusView.snp.makeConstraints { (make) in
                    make.width.equalTo(cusView.snp.height)
                    make.width.equalTo((self.frame.size.width-gaps * CGFloat(rol_c-1))/CGFloat(rol_c)).priority(.medium)
                }
                if leftView == nil{
                    cusView.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().inset(0)
                    }
                }else{
                    cusView.snp.makeConstraints { (make) in
                        make.left.equalTo(leftView!.snp.right).inset(-gaps)
                        make.width.equalTo(leftView!).multipliedBy(1)
                    }
                }
                if topView == nil{
                    cusView.snp.makeConstraints { (make) in
                        make.top.equalToSuperview().inset(0)
                    }
                }else{
                    cusView.snp.makeConstraints { (make) in
                        make.top.equalTo(topView!.snp.bottom).inset(-gaps)
                         make.width.equalTo(topView!).multipliedBy(1)
                    }
                }
                
                count_1 += 1
                if count_1%rol_c == 0{
                   topView = cusView
                    cusView.snp.makeConstraints { (make) in
                        make.right.equalToSuperview().inset(0)
                    }
                }
                if count_1%rol_c != 0{
                   leftView = cusView
                }else{
                    leftView = nil;
                }
                
            }
        }
    }
    @objc func topButtonClick(_ btn:UIButton) -> Void {
        if btn == leftButton{
            if !leftButton.isSelected{
                leftButton.isSelected = true;
                rightButton.isSelected = false;
                updateSubVIew(true)
            }
        }else{
            if !rightButton.isSelected{
                rightButton.isSelected = true;
                leftButton.isSelected = false;
                updateSubVIew(false)
            }
        }
    }
    @objc func subButtonClick(_ btn:UIButton) -> Void {
        
        for subview in continerVIew.subviews{
            if subview.isKind(of: CustmButton.self){
                let btn :CustmButton = subview as! CustmButton
                 btn.isSelected = false
            }
        }
        btn.isSelected = true
        currentIndex = btn.tag
        var curentTag:Int = 0
        if rightButton.isSelected {
            curentTag = 1
        }
        let seleDate = dataModel?.souceArray?[curentTag][currentIndex] ?? Date()
        selectCallBack?(seleDate)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .lightText
       resetView()
    }
    func resetView() -> Void {
        topContinerView.addSubview(leftButton)
        topContinerView.addSubview(rightButton)

        let line = UIView()
        line.backgroundColor = .lightGray
        topContinerView.addSubview(line)
        leftButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview().inset(UIEdgeInsets.zero)
            make.left.equalTo(leftButton.snp.right).inset(0)
            make.width.equalTo(leftButton.snp.width)
        }
        line.snp.makeConstraints { (make) in
             make.top.bottom.equalToSuperview().inset(UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5))
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(topContinerView)
        topContinerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(UIEdgeInsets.init(top: 0.5, left: 0, bottom: 0, right: 0))
            make.height.equalTo(45)
        }
        contentView.addSubview(continerVIew)
        continerVIew.snp.makeConstraints { (make) in
             make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15))
            make.top.equalTo(topContinerView.snp.bottom).inset(-15)
        }
      
        
    }
    func reloadSource(dateModel:DateModel) -> Void {
        dataModel = dateModel
        leftButton.isSelected = true
        rightButton.isSelected = false
        updateSubVIew(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   

//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("被点击")
//        return super.hitTest(point, with: event)
//    }
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        super.point(inside: point, with: event)
//        return false
//    }
}
