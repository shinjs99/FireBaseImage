//
//  ViewController.swift
//  sjs
//
//  Created by 신정섭 on 12/18/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class AddViewController: UIViewController {
    
    @IBOutlet weak var gellaryImage: UIImageView! // 이미지
    @IBOutlet weak var tfName: UITextField!      // 이름 텍스트 필드
    @IBOutlet weak var tfPhone: UITextField!     // 전화번호 텍스트 필드
    @IBOutlet weak var tfAddress: UITextField!   // 주소 텍스트 필드
    @IBOutlet weak var tfRelation: UITextField!  // 관계 텍스트 필드
    @IBOutlet weak var btnAdd: UIButton!         // 등록 버튼
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 버튼 초기 상태 비활성화
        btnAdd.isEnabled = false
        btnAdd.backgroundColor = UIColor.lightGray
        
        // 텍스트 필드 이벤트 추가
        tfName.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        tfPhone.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        tfAddress.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        tfRelation.addTarget(self, action: #selector(validateFields), for: .editingChanged)
    }
    
    // 등록 버튼
    @IBAction func btnAdd(_ sender: UIButton) {
        uploadImageToStorage()
    }
    
    // 이미지 선택 시 validateFields 호출
    @IBAction func btnImage(_ sender: UIButton) {
        presentImagePicker()
        validateFields()
    }
    
    // 모든 필드와 이미지 선택 여부 확인
    @objc func validateFields() {
        let isNameFilled = !(tfName.text?.isEmpty ?? true)
        let isPhoneFilled = !(tfPhone.text?.isEmpty ?? true)
        let isAddressFilled = !(tfAddress.text?.isEmpty ?? true)
        let isRelationFilled = !(tfRelation.text?.isEmpty ?? true)
        
        // 모든 조건 충족 시 버튼 활성화
        let allFieldsFilled = isNameFilled && isPhoneFilled && isAddressFilled && isRelationFilled
        btnAdd.isEnabled = allFieldsFilled
        btnAdd.backgroundColor = allFieldsFilled ? UIColor.systemBlue : UIColor.lightGray
    }
    
    // Firebase Storage에 이미지 업로드
    func uploadImageToStorage() {
        guard let image = gellaryImage.image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert(title: "경고!", message: "이미지를 선택해주세요!")
            return
        }
        
        // Firebase Storage 경로 설정
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
    
    // Firestore에 데이터 등록
    func addDataToFirestore(imageUrl: String) {
        let userData = DBModel(
            name: tfName.text ?? "",
            phone: tfPhone.text ?? "",
            image: imageUrl,
            relation: tfRelation.text ?? "",
            address: tfAddress.text ?? ""
        )
        
        do {
            let data = try Firestore.Encoder().encode(userData)
            db.collection("memos").addDocument(data: data) { error in
                if let error = error {
                    self.showAlert(title: "등록 실패", message: "오류가 발생했습니다: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "등록 완료", message: "데이터가 성공적으로 저장되었습니다.")
                }
            }
        } catch {
            self.showAlert(title: "등록 실패", message: "데이터 변환 실패: \(error.localizedDescription)")
        }
    }
    
    // 이미지 선택 보여주기
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Alert 띄우기
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// ImagePicker Extension
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            gellaryImage.image = selectedImage
            validateFields() // 이미지 선택 후 버튼 활성화 여부 확인
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
