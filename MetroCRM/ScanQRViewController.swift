//
//  ScanQRViewController.swift
//  MetroCRM
//
//  Created by phonestop on 11/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ScanQRViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
        // Do any additional setup after loading the view.
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
extension ScanQRViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // imageViewPic.contentMode = .scaleToFill
            // imageViewPic.image = pickedImage
            
            
            var user_Id = String()
            if let userId = UserDefaults.standard.string(forKey: "userlogin_id") {
                user_Id = userId
                //self.callApi(user_id: user_Id, image: pickedImage)
                
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
