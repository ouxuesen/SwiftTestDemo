//
//  FirstItemViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/5/23.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
import Photos

class FirstItemViewController: UITableViewController {
    var titleS = ["灭霸动画","音乐频谱","文件管理","相册管理","网络转模型","时间选择","RxSwiftTes","瀑布流"]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstItemtableViewCell", for: indexPath)
        cell.textLabel?.text = titleS[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if titleS[indexPath.row] == "灭霸动画"{
            let viewcontroller = ThanosSnapViewController()
                viewcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else if titleS[indexPath.row] == "音乐频谱"{
            let viewcontroller = AudioSpectrumViewController()
            viewcontroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else if titleS[indexPath.row] == "文件管理"{
         let viewCOntroller = AudioPlayTableViewController()
            viewCOntroller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewCOntroller, animated: true)
        }else if titleS[indexPath.row] == "相册管理"{
            let ruter = OZoneSouceRuter()
        
            ruter.showSeleAlbum(navigationController!) { (array) in
                for ozoitem:OzoneItem in array{
                    print(ozoitem.asset!)
                }
            }
        }else if titleS[indexPath.row] == "网络转模型"{
           TestHandyJson().testNetworkChage()
        }else if titleS[indexPath.row] == "时间选择"
        {
            let vc = MainSelectViewController()
            vc.seleDateBlock =  {
                date in
                  print("sele--0",date!.dateToString("MM月dd日HH:mm"))
            }
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }else if titleS[indexPath.row] == "RxSwiftTes"{
            let vc = RxSwiftTestViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }else if titleS[indexPath.row] == "瀑布流"{
            let vc = MyViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
