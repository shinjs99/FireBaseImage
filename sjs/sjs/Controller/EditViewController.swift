//
//  EditViewController.swift
//  sjs
//
//  Created by 신정섭 on 12/18/24.
//

import UIKit

class EditViewController: UIViewController {
        
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfRelation: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var receiveName = ""
    var receivePhone = ""
    var receiveAddress = ""
    var receiveRelation = ""
    var receiveimage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfName.text = receiveName
        tfPhone.text = receivePhone
        tfAddress.text = receiveAddress
        tfRelation.text = receiveRelation
        imageView.image = receiveimage
        // Do any additional setup after loading the view.
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
