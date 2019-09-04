//
//  MainSelectViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/9/3.
//  Copyright © 2019 ou xuesen. All rights reserved.
//
// MARK: - 打印相关


import UIKit

typealias SeleDateBlock = (_ seleDate:Date?)->()
@objc(MainSelectViewControllerProtocol)
protocol MainSelectViewControllerProtocol:NSObjectProtocol {
    func seletDate(seleDate:Date?)
}

class MainSelectViewController: UIViewController {

    var currentData:Date?
  @objc  var seleDateBlock:SeleDateBlock?
  @objc  var delegate :MainSelectViewControllerProtocol?
    
    var leftSouce = TimeDateSource.getDaySource()
    //右侧表格当前是否正在向下滚动（即true表示手指向上滑动，查看下面内容）
    var rightTableIsScrollDown = true
    //右侧表格垂直偏移量
    var bottomLastOffsetX : CGFloat = 0.0
    var currentIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        topCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(UIEdgeInsets.zero)
            make.top.equalTo(topLayoutGuide.snp.bottom).inset(0)
            make.height.equalTo(80)
        }
        bottomCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 40, right: 0))
            make.top.equalTo(topCollectionView.snp.bottom).inset(0)
        }
        topCollectionView.delegate = self
        bottomCollectionView.delegate = self
        topCollectionView.dataSource = self
        bottomCollectionView.dataSource = self
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets.zero)
            make.height.equalTo(40)
        }
        chageButtonStatue(Enable: false)
        // Do any additional setup after loading the view.
    }
    
   lazy var topCollectionView:UICollectionView = {
        let myflowLayout = UICollectionViewFlowLayout()
        myflowLayout.minimumLineSpacing = 0
        myflowLayout.minimumInteritemSpacing = 0
        myflowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: myflowLayout)

        collectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: "TopCollectionViewCell")
        return collectionView
    }()
   lazy var bottomCollectionView:UICollectionView = {
        let myflowLayout = UICollectionViewFlowLayout()
        myflowLayout.minimumLineSpacing = 0
        myflowLayout.minimumInteritemSpacing = 0
        myflowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: myflowLayout)
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .lightGray
        collectionView.register(BootomCollectionViewCell.self, forCellWithReuseIdentifier: "BootomCollectionViewCell")
        return collectionView
    }()
    lazy var bottomButton:UIButton = {
       let button = UIButton.init(type: .custom)
        button.setTitle("确定", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(bottomClick), for: .touchUpInside)
        return button
    }()
    @objc func bottomClick(_ btn:UIButton) -> Void {
       delegate?.seletDate(seleDate: currentData)
       seleDateBlock?(currentData)
       navigationController?.popViewController(animated: true)
    }
    func chageButtonStatue(Enable:Bool) -> Void {
        if Enable {
               bottomButton.backgroundColor = .red
        }else{
               bottomButton.backgroundColor = .lightGray
        }
        bottomButton.isEnabled = Enable
     
        
    }
}
extension MainSelectViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView
        {
           return leftSouce.count
        }else{
           return leftSouce.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
            cell.reloadSource(dateModel: leftSouce[indexPath.row])
            cell.isSelected  = indexPath.row == currentIndex
            return cell
        }else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BootomCollectionViewCell", for: indexPath) as! BootomCollectionViewCell
            cell.selectCallBack = { [unowned self]
                seleDate in
                self.currentData = seleDate
                self.chageButtonStatue(Enable: true)
            }
           cell.reloadSource(dateModel: leftSouce[indexPath.row])
            return cell
        }
    }
   
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == topCollectionView {
//            return;
//        }
//        if !(collectionView.isDragging || collectionView.isDecelerating) {
//            return
//        }
//        if !(collectionView.isDragging || collectionView.isDecelerating) {
//            return
//        }
//        if rightTableIsScrollDown {
//            HWPrint("右滑")
//        } else {
//            HWPrint("左滑")
//            topCollectionView.selectItem(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .left)
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            return;
        }
        if !(collectionView.isDragging || collectionView.isDecelerating) {
            return
        }
        let current = round(collectionView.contentOffset.x/collectionView.frame.size.width)
        currentIndex = Int(current)
        if rightTableIsScrollDown {
            print("右滑")
            topCollectionView.selectItem(at: IndexPath(row: Int(current), section: 0), animated: true, scrollPosition: .right)
            topCollectionView.reloadData()
        } else {
            print("左滑")
              topCollectionView.selectItem(at: IndexPath(row: Int(current), section: 0), animated: true, scrollPosition: .left)
             topCollectionView.reloadData()
        }
        self.currentData = nil
        self.chageButtonStatue(Enable: false)
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == topCollectionView { return } // 如果是左边就结束
        rightTableIsScrollDown = bottomLastOffsetX < scrollView.contentOffset.x
        bottomLastOffsetX = scrollView.contentOffset.x
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if bottomCollectionView == collectionView {return}
        bottomCollectionView.scrollToItem(at: IndexPath(item:indexPath.row, section: 0), at: UICollectionView.ScrollPosition.right, animated: true)
        currentIndex = indexPath.row
        topCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if collectionView == topCollectionView
         {
            return CGSize.init(width: topCollectionView.frame.size.height, height: topCollectionView.frame.size.height)
         }else{
            return bottomCollectionView.frame.size
        }
    }
}
