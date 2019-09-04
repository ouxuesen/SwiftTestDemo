//
//  TopCollectionViewCell.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/3.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    var titleLable:UILabel = {
        let titleLable = UILabel.init()
        titleLable.font = UIFont.boldSystemFont(ofSize: 14)
        titleLable.numberOfLines = 0
        titleLable.textColor = UIColor.lightGray
        titleLable.textAlignment = .center
        return titleLable
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
    }
    func reloadSource(dateModel:DateModel) -> Void {
        titleLable.text = dateModel.title
        contentView.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var isSelected: Bool {
        willSet(newIsSelected){
            if isSelected {
                titleLable.textColor = UIColor.black
            }else{
                titleLable.textColor = UIColor.lightGray
            }
        }
        didSet{
            if isSelected != oldValue{
                
            }
            if isSelected {
                titleLable.textColor = UIColor.black
            }else{
                titleLable.textColor = UIColor.lightGray
            }
        }
    }
}
