//
//  EditViewController.swift
//  sjs
//
//  Created by 신정섭 on 12/18/24.
//

import UIKit
import FirebaseFirestoreInternal
import Firebase
import FirebaseStorage



class EditViewController: UIViewController {
    
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var imgJson: UIImageView!
    
    
    //    @IBOutlet var tfRelation: UITextField!
    
    var receiveId = ""
    var receiveName = ""
    var receivePhone = ""
    var receiveAddress = ""
    var receiveRelation = ""
    var receiveImage: String?
    
    let db = Firestore.firestore()
    let updateModel = UpdateModel()
    let deleteModel = DeleteModel()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName.text = receiveName
        tfPhone.text = receivePhone
        tfAddress.text = receiveAddress
        if let imageUrl = receiveImage, let url = URL(string: imageUrl) {
            loadImage(from: url) {
                image in
                DispatchQueue.main.async {
                    self.imgJson.image = image
                }
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
    
    
    @IBAction func btnEdit(_ sender: UIButton) {
        print(receiveId)
        Task{
            do {
                let imgurl = try await uploadImageToStorage()
                
                let updatedData = [
                    "name": tfName.text!,
                    "phone": tfPhone.text!,
                    "image": imgurl,
//                    "relation": "",
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
            }catch{
                
            }
        }
    }
    
    
    func uploadImageToStorage() async throws -> String {
        guard let image = imgJson.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "이미지를 선택해주세요!"])
        }
        
        // Firebase Storage 경로 설정
        let storageRef = storage.reference().child("image/\(UUID().uuidString).png")
        
        do {
            // 이미지 데이터를 Firebase Storage에 업로드
            let _ = try await storageRef.putDataAsync(imageData, metadata: nil)
            
            // 업로드된 이미지의 다운로드 URL 가져오기
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            throw NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "이미지 업로드 실패: \(error.localizedDescription)"])
        }
    }
    
    
    @IBAction func updateImage(_ sender: UIButton) {
        guard let image = receiveImage else{return}
        presentImagePicker()
        UpdateModel()
            .updateItems(
                documentId: receiveId,
                name: receiveName,
                phone: receivePhone,
                address: receiveAddress,
                relation: receiveRelation,
                image: image
            )
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
    
    @IBAction func btnDelete(_ sender: UIButton) {
        Task {
            let deleteModel = DeleteModel()
            let isSuccess = await deleteModel.deleteItems(documentId: receiveId)
            
            if isSuccess {
                showAlert(title: "성공", message: "데이터가 삭제되었습니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                showAlert(title: "오류", message: "데이터 삭제에 실패했습니다.")
            }
        }
    }
    
    func showAlert(title: String, message: String, onCompletion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            onCompletion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(title: String, message: String, onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            onConfirm()
        })
        present(alert, animated: true, completion: nil)
    }
}
    extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                imgJson.image = selectedImage
                //            validateFields()
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

