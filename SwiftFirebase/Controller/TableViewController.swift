//
//  TableViewController.swift
//  SwiftFirebase
//
//  Created by mac on 12/18/24.
//

import UIKit

class TableViewController: UITableViewController {

    
    @IBOutlet var tvListView: UITableView!
    
    let queryModel = QueryModel()
    var dataArray: [DBModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataInit()
    }
    
    
    func dataInit() {
        queryModel.fetchUserData { [weak self] users in
            guard let self = self else { return }
            self.dataArray = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let user = dataArray[indexPath.row]
        // Configure the cell...

        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.relation
        
        if let url = URL(string: user.image) {
                   loadImage(from: url) { image in
                       DispatchQueue.main.async {
                           if let updatedCell = tableView.cellForRow(at: indexPath) {
                               var updatedContent = updatedCell.defaultContentConfiguration()
                               updatedContent.text = user.name
                               updatedContent.secondaryText = user.relation
                               updatedContent.image = image // 로드된 이미지 설정
                               updatedCell.contentConfiguration = updatedContent
                           }
                       }
                   }
               }

        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Failed to load image from URL: \(url), Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                completion(UIImage(data: data))
            }
            task.resume()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgEdit" {
//            let cell = sender as! UITableViewCell // cell 지정
            // index 찾기
//            let editView = segue.destination as! EditViewController // 페이지 지정
            // 값 넘겨주기
        }else if segue.identifier == "sgAdd"{
//            let addView = segue.destination as! AddViewController
            
                
            }
        }
    

}
