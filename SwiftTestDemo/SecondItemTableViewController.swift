//
//  SecondItemTableViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/5/23.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit

class SecondItemTableViewController: UITableViewController {
    var titleS = ["Then",]
       override func viewDidLoad() {
           super.viewDidLoad()
           tableView.tableFooterView = UIView.init()
           // Uncomment the following line to preserve selection between presentations
           // self.clearsSelectionOnViewWillAppear = false

           // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
           // self.navigationItem.rightBarButtonItem = self.editButtonItem
       }

       // MARK: - Table view data source

       override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return titleS.count
       }

    
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "SecondItemtableViewCell", for: indexPath)
           cell.textLabel?.text = titleS[indexPath.row]

           return cell
       }

     
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                 switch indexPath.row {
                 case 0:
                  let then = ThenTestViewController()
                  then.hidesBottomBarWhenPushed = true
                  navigationController?.pushViewController(then, animated: true)
                 default: break
                     
                 }
       }
}
