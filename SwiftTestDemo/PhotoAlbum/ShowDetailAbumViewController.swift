//
//  ShowDetailAbumViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/27.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Photos

class Ozonetoobar: UIView {
    var buttonCallBack:((_ tag:Int) -> ())?
    
    var lefButton:UIButton = {
        let button = UIButton.init(type:.custom)
        button.addTarget(self, action: #selector(leftButtonClick), for:.touchUpInside)
       button.setImage(UIImage.init(named: "image_picker_preview"), for: .normal)
    button.setImage(UIImage.init(named: "image_picker_preview_light"), for: .disabled)
        return button
    }()
    var rightBrtton:UIButton = {
        let button = UIButton.init(type:.custom)
        button.addTarget(self, action: #selector(rightButtonClick), for:.touchUpInside)
        button.setImage(UIImage.init(named: "image_picker_send"), for: .normal)
        button.setImage(UIImage.init(named: "image_picker_send_light"), for: .disabled)
        return button
    }()
    var coutLable:UILabel = {
        let showLable = UILabel.init()
        showLable.backgroundColor = .red
        showLable.textAlignment = .center
        showLable.font = UIFont.systemFont(ofSize: 13)
        showLable.textColor = .white
        showLable.text = "0"
        showLable.layer.cornerRadius = 3.0
        showLable.clipsToBounds = true
        return showLable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        resetView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func resetView() -> Void {
        self.addSubview(lefButton)
        self.addSubview(rightBrtton)
        self.addSubview(coutLable)
        lefButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        rightBrtton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        coutLable.snp.makeConstraints { (make) in
            make.left.equalTo(rightBrtton).inset(-5)
            make.top.equalTo(rightBrtton).inset(-5)
            make.width.equalTo(20)
            make.height.equalTo(15)
        }
    }
    @objc func leftButtonClick() -> Void {
        buttonCallBack?(0)
    }
   @objc func rightButtonClick() -> Void {
        buttonCallBack?(1)
    }
    
}
class ShowDetailAbumViewController: UIViewController {
    
    var dataSouce:Array<OzoneItem>! = {
        return Array.init()
    }()
    //已选择选择
    var seleedArray:Array<OzoneItem>! = {
        return Array.init()
    }()
    
    var SendActionBlock:swiftBlock?
 
    //
    open func relodeSouce(_ cpllection:PHAssetCollection) -> Void {
//        dataSouce = PhotoAlbumUtil.getSoucePhoto(cpllection)
        PhotoAlbumUtil.getSoucePhoto(cpllection).enumerateObjects { (asset, index, stop) in
            self.dataSouce.append(OzoneItem.init(asset, select: false))
        }
    }
 
    lazy var tooBar:Ozonetoobar = {
        return Ozonetoobar.init(frame: CGRect.zero)
    }()
    lazy var collection:UICollectionView = {
        let myflowLayout = UICollectionViewFlowLayout()
        myflowLayout.sectionHeadersPinToVisibleBounds = true // 头部悬浮
        myflowLayout.minimumLineSpacing = 3
        myflowLayout.minimumInteritemSpacing = 3
        myflowLayout.itemSize  = CGSize(width:UIScreen.main.bounds.size.width/4.5, height: UIScreen.main.bounds.size.width/4.5)
        let collectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: myflowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShowDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ShowDetailCollectionViewCell")
        return collectionView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        view.backgroundColor = .white
        view.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }
        view.addSubview(tooBar)
        tooBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.zero)
            make.height.equalTo(50)
        }
        tooBar.buttonCallBack = { [unowned self]
            tag in
            if tag == 0{
                self.showDetailPrew()
            }else{
                self.sendAction()
            }
        }
        collection.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
        let barbutton = UIBarButtonItem.init(title:"取消", style: .plain, target: self, action: #selector(cancleButtonClick))
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = barbutton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
  @objc  func cancleButtonClick() -> Void {
        navigationController?.popViewController(animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    deinit {
        print("释放了当前类--\(NSStringFromClass(self.classForCoder))")
    }
}
extension ShowDetailAbumViewController{
    
    func changeSelectArray() -> Void {
        tooBar.lefButton.endEditing(seleedArray.count>0)
        tooBar.rightBrtton.endEditing(seleedArray.count>0)
        tooBar.coutLable.text = "\(seleedArray.count)"
    }
    func eideSelectSourse(_ ozoneTime:OzoneItem) -> Void {
         ozoneTime.select = !ozoneTime.select
        if seleedArray.contains(ozoneTime) {
            seleedArray.remove(at: seleedArray.firstIndex(of: ozoneTime)!)
        }else{
            seleedArray.append(ozoneTime)
        }
        changeSelectArray()
        collection.reloadData()
    }
    //完成
    func sendAction() -> Void {
        SendActionBlock?(seleedArray)
       navigationController?.dismiss(animated: true, completion: nil)
    }
    
    //调转预览
    func showPrew(index:Int) -> Void {
        let showPrewVC = OZOneAbumViewController.init()
        //        showPrewVC.
        showPrewVC.relodeSouce(dataSouce,seleedArray,index)
        showPrewVC.selectBlock = { [unowned self]
            ozoneItem in
            self.eideSelectSourse(ozoneItem)
        }
        showPrewVC.senDImagBlock = {
            [unowned self] in
                self.sendAction()
        }
        navigationController?.pushViewController(showPrewVC, animated: true)
    }
    //跳转详情
    //调转预览
    func showDetailPrew() -> Void {
        let showPrewVC = OZOneAbumViewController.init()
        showPrewVC.relodeSouce(seleedArray,seleedArray,0)
        showPrewVC.selectBlock = { [unowned self]
            ozoneItem in
            self.eideSelectSourse(ozoneItem)
        }
        showPrewVC.senDImagBlock = {
            [unowned self] in
            self.sendAction()
        }
        navigationController?.pushViewController(showPrewVC, animated: true)
    }
  
}
extension ShowDetailAbumViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSouce.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowDetailCollectionViewCell", for: indexPath) as!ShowDetailCollectionViewCell;
        cell.ozoneItem = dataSouce[indexPath.row]
//         weak var weekSef = self;
        cell.callback = {[unowned self] ozoneTime in
            self.eideSelectSourse(ozoneTime)
        }
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showPrew(index: indexPath.row)
    }
  
}

