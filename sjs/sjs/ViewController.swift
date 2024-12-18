//
//  ViewController.swift
//  sjs
//
//  Created by 신정섭 on 12/18/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gellaryImage: UIImageView! // 이미지
    @IBOutlet weak var tfName: UITextField! // 이름 텍스트 필드
    @IBOutlet weak var tfPhone: UITextField! // 전화번호 텍스트 필드
    @IBOutlet weak var tfAddress: UITextField! // 주소 텍스트 필드
    @IBOutlet weak var tfRelation: UITextField! // 관계 텍스트 필드
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    
    // Photo 불러오기 버튼
    @IBAction func btnImage(_ sender: UIButton) {
        presentImagePicker()
    }
    
    // 등록 버튼
    @IBAction func btnAdd(_ sender: UIButton) {
        // firebase 등록 
    }
    
    // 선택한 이미지 보여주기
    func presentImagePicker() {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    
    }

 // ImagePicker Extension
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 이미지 선택
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            gellaryImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    // 선택 취소
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

    




