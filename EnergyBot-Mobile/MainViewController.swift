//
//  ViewController.swift
//  GoogleVision Demo
//
//  Created by Gimin Moon on 1/29/18.
//  Copyright © 2018 Gimin Moon. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var ParseButton: UIButton!

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        imagePicker.delegate = self
    }
    
    @IBAction func showActionSheetTapped(sender: AnyObject) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            //Code for launching the camera goes here
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let cameraVC = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            if let navigationcontrol = self.navigationController {
                navigationcontrol.pushViewController(cameraVC, animated: true)
            }
            
        }
        actionSheetController.addAction(takePictureAction)
        //Code to launch imagePicker
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)            
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
}

//functions for imagepicker delegation
extension MainViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let navigationC = navigationController {
                let reviewVC = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
                reviewVC.currentBillImage = pickedImage
                navigationC.pushViewController(reviewVC, animated: true)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


