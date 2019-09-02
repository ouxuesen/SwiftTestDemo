//
//  OZoneSouceRuter.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/23.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Photos
typealias swiftBlock = (_ souceArray:Array<OzoneItem>) -> Void

class PhotoAlbimError{
    enum PhotoAlbimError_type {
        case upc(Int)
        case error(String)
    }
}

class PhotoAlbumUtil: NSObject {
    func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized||PHPhotoLibrary.authorizationStatus() == .notDetermined
    }
    
   class func  getListAlbum() -> PHFetchResult<PHAssetCollection> {
//        var assetsLibrary = PHPhotoLibrary()
        //相册列表
        let listAlbum = PHAssetCollection.fetchAssetCollections(with:.smartAlbum, subtype: .any, options: nil)
         print("listalbum count \(listAlbum.count)")
        return listAlbum
    }
   class func getSoucePhoto(_ assetCollection:PHAssetCollection) -> PHFetchResult<PHAsset>{
       return PHAsset.fetchAssets(in:assetCollection, options: nil);
    }
    class func getThumbnail(_ asset:PHAsset) -> UIImage{
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .fast
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: imageRequestOption, resultHandler: {
            (result, _) -> Void in
            image = result!
        })
        return image
    }
    class func getFullImage(_ asset:PHAsset) -> UIImage{
        var image = UIImage()
        
        // 新建一个默认类型的图像管理器imageManager
        let imageManager = PHImageManager.default()
        
        // 新建一个PHImageRequestOptions对象
        let imageRequestOption = PHImageRequestOptions()
        
        // PHImageRequestOptions是否有效
        imageRequestOption.isSynchronous = true
        
        // 缩略图的压缩模式设置为无
        imageRequestOption.resizeMode = .none
        
        // 缩略图的质量为高质量，不管加载时间花多少
        imageRequestOption.deliveryMode = .highQualityFormat
        
        // 按照PHImageRequestOptions指定的规则取出图片
        
        imageManager.requestImageData(for: asset, options: imageRequestOption) { (imageData, dataUTI, orientation, info) in
//            let url = info?["PHImageFileURLKey"]
          image =  UIImage.init(data: imageData!)!
        }
        return image
    }
}

class OZoneSouceRuter: NSObject {

    override init() {
        
    }
    var viewControll :AlbumDirectoryViewController?
    
    func showSeleAlbum(_ presentVC:UINavigationController,block:@escaping swiftBlock) -> Void {
        viewControll = AlbumDirectoryViewController()
        viewControll?.SendActionBlock = block
       let navigation = UINavigationController.init(rootViewController:viewControll!)
        presentVC.present(navigation, animated: true, completion: nil)
        
    }
   
    
}

