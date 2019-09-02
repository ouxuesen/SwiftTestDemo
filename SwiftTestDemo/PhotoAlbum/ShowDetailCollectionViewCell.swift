//
//  ShowDetailCollectionViewCell.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/29.
//  Copyright © 2019 ou xuesen. All rights reserved.
//
import SnapKit
import UIKit
import Photos

class ShowDetailCollectionViewCell: UICollectionViewCell {
    
   open var ozoneItem:OzoneItem!{
        didSet {
            if ozoneItem != oldValue  {
                if ozoneItem != nil{
                     fullImage.image = PhotoAlbumUtil.getThumbnail(ozoneItem.asset!)
                }
            }
            seleBtn.isSelected = ozoneItem.select
        }
    }
    
  open var callback:((_ ozoneItem:OzoneItem)->())?
    
   lazy var seleBtn:UIButton = {
        let seleBtn = UIButton.init(type:.custom)
        seleBtn.setImage(UIImage.init(named: "image_picker_ensure_light"), for: .normal)
        seleBtn.setImage(UIImage.init(named: "image_picker_ensure"), for: .selected)
    seleBtn.addTarget(self, action:#selector(seleBtnClick) , for: .touchUpInside)
        return seleBtn
    }()
   lazy var fullImage:UIImageView = {
        let imageView = UIImageView.init()
        return imageView;
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        restView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restView() -> Void {
        contentView.addSubview(fullImage)
        fullImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(seleBtn)
        seleBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(0)
            make.top.equalToSuperview().inset(0)
            make.width.equalTo(30);
            make.height.equalTo(30)
        }
        
    }
    
    @objc func seleBtnClick(_ btn:UIButton) -> Void {
//        btn.isSelected = !btn.isSelected
        callback?(ozoneItem!)
    }
    
}
