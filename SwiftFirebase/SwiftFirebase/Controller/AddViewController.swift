//
//  AddViewController.swift
//  SwiftFirebase
//
//  Created by 하동훈 on 19/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

protocol AddViewControllerDelegate: AnyObject {
    func didAddNewUser(user: DBModel)
}

class AddViewController: UIViewController {
    
    weak var delegate: AddViewControllerDelegate?
    
    @IBOutlet weak var gellaryImage: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnAdd.isEnabled = false
        btnAdd.backgroundColor = UIColor.lightGray
        
        tfName.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        tfPhone.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        tfAddress.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        tfRelation.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        uploadImageToStorage()
    }
    
    @IBAction func btnImage(_ sender: UIButton) {
        presentImagePicker()
        validateFields()
    }
    
    @objc func validateFields() {
        let isNameFilled = !(tfName.text?.isEmpty ?? true)
        let isPhoneFilled = !(tfPhone.text?.isEmpty ?? true)
        let isAddressFilled = !(tfAddress.text?.isEmpty ?? true)
        let isRelationFilled = !(tfRelation.text?.isEmpty ?? true)
        
        let allFieldsFilled = isNameFilled && isPhoneFilled && isAddressFilled && isRelationFilled
        btnAdd.isEnabled = allFieldsFilled
        btnAdd.backgroundColor = allFieldsFilled ? UIColor.systemBlue : UIColor.lightGray
    }
    
    func uploadImageToStorage() {
        guard let image = gellaryImage.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert(title: "경고!", message: "이미지를 선택해주세요!")
            return
        }
        
        let storageRef = storage.reference().child("image/\(UUID().uuidString).png")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.showAlert(title: "오류", message: "이미지 업로드 실패: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    self.showAlert(title: "오류", message: "URL 가져오기 실패: \(error.localizedDescription)")
                    return
                }
                if let imageUrl = url?.absoluteString {
                    self.addDataToFirestore(imageUrl: imageUrl)
                }
            }
        }
    }
    
    func addDataToFirestore(imageUrl: String) {
        let documentId = UUID().uuidString
        
        let userData: [String: Any] = [
            "documentId": documentId,
            "name": tfName.text ?? "",
            "phone": tfPhone.text ?? "",
            "image": imageUrl,
            "relation": tfRelation.text ?? "",
            "address": tfAddress.text ?? ""
        ]
        
        let dbModel = DBModel(
            documentId: documentId,
            name: tfName.text ?? "",
            phone: tfPhone.text ?? "",
            address: tfAddress.text ?? "",
            relation: tfRelation.text ?? "",
            image: imageUrl
        )
        
        db.collection("memos").document(documentId).setData(userData) { error in
            if let error = error {
                self.showAlert(title: "등록 실패", message: "데이터 저장 중 오류가 발생했습니다: \(error.localizedDescription)")
            } else {
                self.showConfirmationAlert(
                    title: "등록 완료",
                    message: "데이터가 성공적으로 저장되었습니다."
                ) {
                    self.delegate?.didAddNewUser(user: dbModel)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            gellaryImage.image = selectedImage
            validateFields()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
