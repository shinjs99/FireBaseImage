//
//  EditViewController.swift
//  sjs
//
//  Created by 신정섭 on 12/18/24.
//

import UIKit
import FirebaseFirestoreInternal
import Firebase

class EditViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    
//    @IBOutlet var tfRelation: UITextField!
    
    var receiveId = ""
    var receiveName = ""
    var receivePhone = ""
    var receiveAddress = ""
    var receiveRelation = ""
    var receiveImage : UIImage?
    let db = Firestore.firestore()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName.text = receiveName
        tfPhone.text = receivePhone
        tfAddress.text = receiveAddress
        print(receiveRelation)
//        tfRelation.text = receiveRelation
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnEdit(_ sender: UIButton) {
        print(receiveId)
        let updatedData = [
               "name": tfName.text!,
               "phone": tfPhone.text!,
               "image": "",
               "relation": "",
               "address": tfAddress.text!
           ]
           
           updateUserData(id: receiveId, updatedData: updatedData) { result in
               switch result {
               case .success:
                   print("데이터가 성공적으로 업데이트되었습니다.")
                   // 여기에 성공 후 수행할 작업을 추가하세요 (예: 알림 표시, 화면 이동 등)
                   
               case .failure(let error):
                   print("데이터 업데이트 실패: \(error.localizedDescription)")
                   // 여기에 실패 시 수행할 작업을 추가하세요 (예: 오류 메시지 표시)
               }
           }
       }

       func updateUserData(id: String, updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
           db.collection("memos").document(id).updateData(updatedData) { error in
               if let error = error {
                   
                   completion(.failure(error))
               } else {
                   completion(.success(()))
               }
           }
       }
        
        
   
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
}
