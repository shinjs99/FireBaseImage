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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgEdit" {
            guard let cell = sender as? UITableViewCell else {
                print("Sender is not a UITableViewCell")
                return
            }
            guard let cellIndex = self.tableView.indexPath(for: cell) else {
                print("Failed to get indexPath for cell")
                return
            }

            if let editPage = segue.destination as? EditViewController {
                // EditViewController로 데이터 전달
                let data = dataArray[cellIndex.row]
                editPage.receiveId = data.id
                editPage.receiveName = data.name
                editPage.receivePhone = data.phone
                editPage.receiveAddress = data.address
                editPage.receiveRelation = data.relation
            } else if let navController = segue.destination as? UINavigationController,
                      let editPage = navController.topViewController as? EditViewController {
                // Navigation Controller를 통한 Segue 처리
                let data = dataArray[cellIndex.row]
                editPage.receiveId = data.id
                editPage.receiveName = data.name
                editPage.receivePhone = data.phone
                editPage.receiveAddress = data.address
                editPage.receiveRelation = data.relation
//                editPage.receiveImage = 

            } else {
                print("Segue destination is not EditViewController")
            }
        }
    }}
