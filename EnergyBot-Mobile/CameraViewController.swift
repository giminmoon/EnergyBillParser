//
//  ViewController.swift
//  customCamera
//
//  Created by Yash Bazari on 2/27/18.
//  Copyright © 2018 Yash Bazari. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var overlayView: UIView!     // Overlay rectangle
    @IBOutlet weak var previewView: UIView!     // Preview View for camera and image
    @IBOutlet weak var cameraButton: UIButton!  // Button to click picture
    @IBOutlet weak var doneButton: UIButton!    // Button to submit picture
    @IBOutlet weak var retakeButton: UIButton!
    var imageView:UIImageView?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?// Image view to preview image clicked by user
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? // Layer on top of preview View to show rear camera contents
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var vp = VisionParser.init()
    @IBOutlet weak var corner1: CustomBorder!
    
    @IBOutlet weak var corner2: CustomBorder!
    @IBOutlet weak var corner3: CustomBorder!
    @IBOutlet weak var corner4: CustomBorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.isHidden = true
        self.retakeButton.isHidden = true
        navigationController?.navigationBar.isHidden = false
        // Set up overlay view rectangle dimensions and configurations
//        overlayView.layer.borderColor = UIColor.green.cgColor
//        overlayView.layer.borderWidth = 10
//        overlayView.layer.zPosition = 2
        corner1.transform = CGAffineTransform(rotationAngle: 0)
        corner2.transform = CGAffineTransform(rotationAngle: CGFloat(90.0*Double.pi/180))
        corner3.transform = CGAffineTransform(rotationAngle: CGFloat(270.0*Double.pi/180))
        corner4.transform = CGAffineTransform(rotationAngle: CGFloat(180.0*Double.pi/180))
        initOutput()
    }
    
    func initOutput()
    {
        stillImageOutput = AVCapturePhotoOutput()
        stillImageOutput?.isHighResolutionCaptureEnabled = true
        session?.addOutput(stillImageOutput!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
        videoPreviewLayer!.frame.size = previewView.frame.size
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)

        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }

        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)

            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                previewView.layer.addSublayer(videoPreviewLayer!)
                self.previewView.addSubview(corner1)
                self.previewView.addSubview(corner2)
                self.previewView.addSubview(corner3)
                self.previewView.addSubview(corner4)
                session!.startRunning()
            }

        }
    }
    
     //Action for when user clicks a photo
        @IBAction func didTakePhoto(_ sender: Any) {
            
            guard let capturePhotoOutput = self.stillImageOutput else {
                return
            }
            //get instance of avcapturephotosettings
            let photoSettings = AVCapturePhotoSettings()
            
            photoSettings.isAutoStillImageStabilizationEnabled = true
            photoSettings.isHighResolutionPhotoEnabled = true
            photoSettings.flashMode = .auto
            
            //call delegate method
            capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            // Save our captured image to photos album
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView = UIImageView(frame: self.overlayView.frame)
            self.imageView?.image = image
            self.imageView?.tag = 100
            self.previewView.addSubview(self.imageView!)
            
            changeSettings()
        }
    }
    
    func changeSettings() {
        self.retakeButton.isHidden = false
        self.doneButton.isHidden = false
        videoPreviewLayer?.isHidden = true
        self.cameraButton.isEnabled = false
        
    }
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        //reset cameraView
        videoPreviewLayer?.isHidden = false
        if let currentImageView = self.previewView.viewWithTag(100){
            currentImageView.removeFromSuperview()
        }
        self.retakeButton.isHidden = true
        self.doneButton.isHidden = true
        self.cameraButton.isEnabled = true
        //storyboard instance

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let reviewviewcontroller = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController {
            reviewviewcontroller.currentBillImage = self.imageView?.image
            if let navigtaioncontrol = navigationController {
                reviewviewcontroller.currentBillImage = self.imageView?.image
                navigtaioncontrol.pushViewController(reviewviewcontroller, animated: true)
            }
        }
    }
    
    @IBAction func retakeButtonTouched(_ sender: Any) {
        //show the cameraview
        videoPreviewLayer?.isHidden = false
        //use a tag to reference the imageView currently in View
        if let currentImageView = self.previewView.viewWithTag(100){
            currentImageView.removeFromSuperview()
        }
        //hide side buttons
        self.retakeButton.isHidden = true
        self.doneButton.isHidden = true
        self.cameraButton.isEnabled = true
    }
    
}



