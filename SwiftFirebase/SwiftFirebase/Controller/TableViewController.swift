//
//  TableViewController.swift
//  SwiftFirebase
//
//  Created by 하동훈 on 19/12/2024.
//

import UIKit

class TableViewController: UITableViewController, QueryModelProtocol {

    @IBOutlet var tvListView: UITableView!
    
    var queryModel = QueryModel() // QueryModel 객체 생성
    var dataArray: [DBModel] = [] // 데이터를 담을 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        queryModel.delegate = self // delegate 설정
        
    }

    // MARK: - QueryModelProtocol 구현
    func itemDownloaded(items: [DBModel]) {
        dataArray = items // 데이터를 dataArray에 저장
        DispatchQueue.main.async {
            self.tableView.reloadData() // 테이블 뷰 갱신
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let user = dataArray[indexPath.row]
        
        // 셀 내용 구성
        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = user.phone
        
        if let url = URL(string: user.image) {
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    if let updatedCell = tableView.cellForRow(at: indexPath) {
                        var updatedContent = updatedCell.defaultContentConfiguration()
                        updatedContent.text = user.name
                        updatedContent.secondaryText = user.phone
                        updatedContent.image = image
                        updatedCell.contentConfiguration = updatedContent
                    }
                }
            }
        }

        cell.contentConfiguration = content
        return cell
    }

    // URL로부터 이미지를 비동기로 로드하는 함수
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

    // MARK: - Segue 처리
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgEdit" {
                    guard let cell = sender as? TableViewCell else {
                        print("Sender is not a TableViewCell")
                        return
                    }
                    guard let cellIndex = self.tableView.indexPath(for: cell) else {
                        print("Failed to get indexPath for cell")
                        return
                    }

                    if let editPage = segue.destination as? EditViewController {
                        // EditViewController로 데이터 전달
                        let data = dataArray[cellIndex.row]
                        editPage.receiveId = data.documentId
                        editPage.receiveName = data.name
                        editPage.receivePhone = data.phone
                        editPage.receiveAddress = data.address
                        editPage.receiveRelation = data.relation
                        editPage.receiveImage = data.image
                    } else if let navController = segue.destination as? UINavigationController,
                              let editPage = navController.topViewController as? EditViewController {
                        // Navigation Controller를 통한 Segue 처리
                        let data = dataArray[cellIndex.row]
                        editPage.receiveId = data.documentId
                        editPage.receiveName = data.name
                        editPage.receivePhone = data.phone
                        editPage.receiveAddress = data.address
                        editPage.receiveRelation = data.relation
                        editPage.receiveImage = data.image
                    } else {
                        print("Segue destination is not EditViewController")
                    }
        } else if segue.identifier == "sgAdd" {
            let addView = segue.destination as! AddViewController
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryModel.downloadItems()
    }
    
} // TableViewController

// MARK: - 데이터 추가 및 수정 델리게이트
extension TableViewController: AddViewControllerDelegate {
    func didAddNewUser(user: DBModel) {
        dataArray.append(user) // 새로운 사용자 추가
        tableView.reloadData() // 테이블 뷰 갱신
    }
}
