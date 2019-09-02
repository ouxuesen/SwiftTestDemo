//
//  OzoneImageCollectionViewCell.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/26.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Photos
class OzoneImageCollectionViewCell: UICollectionViewCell {
    lazy var imageVIew:UIImageView = {
        var iamgeView = UIImageView()
        iamgeView.contentMode = .scaleAspectFit
        return iamgeView
    }()
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3;
        scrollView.minimumZoomScale = 1.0;
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    open func reloadCell(_ asset:PHAsset) -> Void {
        if (imageVIew.superview == nil) {
            self.contentView.addSubview(scrollView)
            scrollView.addSubview(imageVIew)
            imageVIew.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
                make.width.equalTo(self.contentView)
                make.height.equalTo(self.contentView)
            }
            scrollView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
            }
        }
       imageVIew.image = PhotoAlbumUtil.getFullImage(asset)
       scrollView.setZoomScale(1.0, animated: false)
    }
    
}
extension OzoneImageCollectionViewCell:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageVIew
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
//    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
//        return imageVIew
//    }
}
