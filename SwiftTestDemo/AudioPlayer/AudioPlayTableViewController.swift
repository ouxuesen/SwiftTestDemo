//
//  AudioPlayTableViewController.swift
//  SwiftTestDemo
//
//  Created by ou xuesen on 2019/5/31.
//  Copyright © 2019 ou xuesen. All rights reserved.
//

import UIKit
enum FileType {
    case FileType_folder
    case FileType_mp3
    case FileType_other
}
class FileManagerModel: NSObject {
    var filetype:FileType!
    var pathStr :String?
    var name : String?
}
class AudioPlayTableViewController: UITableViewController {
    var relativePaths:String?
    var currentIndex:Int!
 
    var souceArray = [FileManagerModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if relativePaths == nil{
            relativePaths = NSHomeDirectory()+"/Documents"
        }
        let document = relativePaths!
        let domainsArray =  try?FileManager.default.contentsOfDirectory(atPath: document)
        for currentName in domainsArray! {
            let currentPath  = document + "/" + currentName;
            let fileAttributes = try?FileManager.default.attributesOfItem(atPath: currentPath)
            
            let managerModel = FileManagerModel()
            managerModel.pathStr = currentPath
            managerModel.name = currentName
            let filetype =  fileAttributes?[FileAttributeKey.init(rawValue: "NSFileType")]
            if filetype as! String == "NSFileTypeDirectory"{
               managerModel.filetype = .FileType_folder
            }else{
                if currentName.components(separatedBy: ".").last == "mp3"{
                     managerModel.filetype = .FileType_mp3
                }else{
                    managerModel.filetype = .FileType_other
                }
            }
            souceArray.append(managerModel)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return souceArray.count
    }
    

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let   reuseIdentifier  = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        if (cell == nil){
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
       let managerModel = souceArray[indexPath.row]
        cell?.textLabel?.text = managerModel.name
        return cell ?? UITableViewCell()
     }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let managerModel = souceArray[indexPath.row]
        if managerModel.filetype == .FileType_folder{
            let audioViewCont = AudioPlayTableViewController()
            audioViewCont.relativePaths = managerModel.pathStr
            self.navigationController?.pushViewController(audioViewCont, animated: true)
        }else if managerModel.filetype == .FileType_mp3{
          PlayerMangerDefault.shared.play(index: indexPath.row, playerS: souceArray)
        }

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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

