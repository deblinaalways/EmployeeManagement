//
//  AddNewEmployee + ImagePicker.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 05/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import UIKit
import AVFoundation

extension AddNewEmployeeTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func uploadProfilePicture() {
        let alert:UIAlertController = UIAlertController(title: "Choose Image", message: "", preferredStyle:.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { _ in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                imagePickerController.allowsEditing = true;
                self.present(imagePickerController, animated: true, completion: nil)
            } else { self.showErrorAccessingCamera() }
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) { _ in
            if UIDevice.current.userInterfaceIdiom == .phone {
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePickerController.delegate = self
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // if there is no camera hardware
    func showErrorAccessingCamera() {
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present( alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Extracting the image from the gallery is a costly operation so do it on an async queue.
        DispatchQueue.global().async { 
            let profileImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            DispatchQueue.main.async {
                self.employeeImageView.image = profileImage
                self.imageSelected = true
            }
        }
        picker.dismiss(animated: false, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

