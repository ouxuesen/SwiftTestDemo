//
//  OZOneAbumViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/26.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Photos

class OZOneAbumViewController: UIViewController {


    var selectBlock: ((_ ozoneItem :OzoneItem) ->())? = nil;
    var senDImagBlock:(()->())? = nil
    
    
    var dataSouce:Array<OzoneItem>!
    var seleedArray:Array<OzoneItem>!
    var currentIndex:Int = 0
    var showindex:Int = 0
    
    open func relodeSouce(_ sourse:Array<OzoneItem>,_ seleedArray:Array<OzoneItem> ,_ index:Int) -> Void {
        self.dataSouce = sourse
        self.seleedArray = seleedArray
        self.showindex = index
        colletiton.reloadData()
    }

    lazy var colletiton:UICollectionView = {
        let myflowLayout = UICollectionViewFlowLayout()
        myflowLayout.scrollDirection = .horizontal
        myflowLayout.minimumLineSpacing = 0;
        myflowLayout.sectionHeadersPinToVisibleBounds = true // 头部悬浮
    let collectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: myflowLayout)
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
    collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
    collectionView.delegate = self
    collectionView.register(OzoneImageCollectionViewCell.self, forCellWithReuseIdentifier: "OzoneImageCollectionViewCell")
    return collectionView
   }()
    lazy var seleBtn:UIButton = {
        let seleBtn = UIButton.init(type:.custom)
        seleBtn.setImage(UIImage.init(named: "image_picker_ensure_light"), for: .normal)
        seleBtn.setImage(UIImage.init(named: "image_picker_ensure"), for: .selected)
        seleBtn.addTarget(self, action:#selector(seleBtnClick) , for: .touchUpInside)
//        seleBtn.backgroundColor = .red
        return seleBtn
    }()
    @objc func seleBtnClick(_ btn:UIButton) -> Void {
        btn.isSelected = !btn.isSelected
        selectBlock?(dataSouce[currentIndex])
        eideSelectSourse(dataSouce[currentIndex])
    }
    lazy var tooBar:Ozonetoobar = {
        return Ozonetoobar.init(frame: CGRect.zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "预览";
        view.addSubview(colletiton)
        colletiton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        view.addSubview(tooBar)
        tooBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.zero)
            make.height.equalTo(50)
        }
        tooBar.lefButton.isHidden = true
        tooBar.buttonCallBack = { [unowned self]
            tag in
            if tag == 0{
                
            }else{
               self.senDImagBlock?()
            }
        }
        changeSelectArray()
        // Do any additional setup after loading the view.
        let rightButton = UIBarButtonItem.init(customView: seleBtn)
        
         navigationItem.rightBarButtonItem = rightButton
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showindex > 0 {
            colletiton.scrollToItem(at: NSIndexPath.init(row: showindex, section: 0) as IndexPath, at: .right, animated: false)
            currentIndex = showindex
        }
        self.seleBtn.isSelected = dataSouce[currentIndex].select
    }
    deinit {
      print("释放了当前类--\(NSStringFromClass(self.classForCoder))")
    }
}
extension OZOneAbumViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OzoneImageCollectionViewCell", for: indexPath) as! OzoneImageCollectionViewCell;
        cell.reloadCell(dataSouce[indexPath.row].asset)
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let lastPage = Int(roundf(Float(scrollView.contentOffset.x/view.frame.width)));
        if currentIndex !=  lastPage{
             currentIndex = lastPage;
            self.seleBtn.isSelected = dataSouce[currentIndex].select
        }
    }
}
extension OZOneAbumViewController{
    func changeSelectArray() -> Void {
        tooBar.lefButton.endEditing(seleedArray.count>0)
        tooBar.rightBrtton.endEditing(seleedArray.count>0)
        tooBar.coutLable.text = "\(seleedArray.count)"
    }
    func eideSelectSourse(_ ozoneTime:OzoneItem) -> Void {
        if seleedArray.contains(ozoneTime) {
            seleedArray.remove(at: seleedArray.firstIndex(of: ozoneTime)!)
        }else{
            seleedArray.append(ozoneTime)
        }
        changeSelectArray()
    }
    
}
