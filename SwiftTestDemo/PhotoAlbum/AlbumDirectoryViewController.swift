//
//  AlbumDirectoryViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/8/23.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import SnapKit

class AlbumDirectoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var SendActionBlock:swiftBlock?
    
    var reuslt = PhotoAlbumUtil.getListAlbum()
    
    //表格
  lazy var tableView:UITableView = {
    let tableView = UITableView.init(frame: CGRect.zero, style:.plain)
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "uitableviewCell")
        // Do any additional setup after loading the view.
           title = "相簿"
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
       let left = NSLayoutConstraint.init(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint.init(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint.init(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint.init(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([left,right,top,bottom])
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return reuslt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "uitableviewCell")
        if cell == nil {
            cell = UITableViewCell.init(style:.value1, reuseIdentifier: "uitableviewCell")
        }
 
        let count = PhotoAlbumUtil.getSoucePhoto(reuslt[indexPath.row]).count;
        cell?.textLabel?.text = reuslt[indexPath.row].localizedTitle
        cell?.detailTextLabel?.text = "数量\(count)"
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         let ozoneVC = ShowDetailAbumViewController()
         ozoneVC.relodeSouce(reuslt[indexPath.row])
        ozoneVC.title = reuslt[indexPath.row].localizedTitle
        ozoneVC.SendActionBlock = SendActionBlock
        self.navigationController?.pushViewController(ozoneVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
 
}
