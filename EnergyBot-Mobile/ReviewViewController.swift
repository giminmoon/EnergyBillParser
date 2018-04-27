//
//  ReviewViewController.swift
//  customCamera
//
//  Created by Yash Bazari on 3/20/18.
//  Copyright © 2018 Yash Bazari. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReviewViewController: UIViewController {

    

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var providerTitleLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rateTitleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    var currentBillImage : UIImage?
    let vp = VisionParser.init()
    var bp : BillParser? = nil
    var activityIndicator : UIActivityIndicatorView?
    var label : UILabel!
    let companyParser = CompanyParser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideLabels()
        createAcitivityIndicatorAndLabel()
        beginAnalyzing()
    }
    
    func beginAnalyzing() {
        let imageInBinaryForm = base64EncodeImage(currentBillImage!)
        vp.createRequest(with: imageInBinaryForm) { (fullTextJSON) in
            if fullTextJSON != JSON.null {
                let companyName = self.companyParser.getCompanyName(outputJSON: fullTextJSON) as String
                switch companyName {
                case "Ameren" :
                    self.bp = AmerenBill.init(fullText: fullTextJSON)
                    break
                case "Duke Energy":
                    self.bp = DukeBill.init(fullText: fullTextJSON)
                    break
                case "ComEd":
                    self.bp = ComedBill.init(fullText: fullTextJSON)
                    break
                case "UGI Utlities, Inc.":
                    self.bp = UGIBill.init(fullText: fullTextJSON)
                    break
                case "The Dayton Power and Light Company":
                    self.bp = DaytonBill.init(fullText: fullTextJSON)
                    break
                default:
                    self.showAlert(errorMsge: "Error processing: \n The company doesn't exist!")
                    break
                }
                if(self.bp != nil && self.bp!.isValidJSON(jsonData: fullTextJSON)) {
                    self.showLabels(companyName: companyName)
                }
                else
                {
                    print("Error")
                    self.showAlert(errorMsge: "Error processing: \n The company doesn't exist!")
                }
                
            }
            else {
                //show error message
                print("error")
                self.showAlert(errorMsge: "Please provide a valid Energy Bill.")
            }
        }
    }
    
    func showAlert(errorMsge : String)
    {
        let alert = UIAlertController(title: "Error!", message: errorMsge, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Back to Camera", style: UIAlertActionStyle.default, handler: { action in
            self.backToCamera()
        }));
        self.present(alert, animated: true, completion: nil)
    }
    
    func backToCamera()
    {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedConfirm(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    func createAcitivityIndicatorAndLabel() {
        //initialize activity indicator
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator?.center = view.center
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.startAnimating()
        
        //initialize label
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 375/2, y: 440)
        label.textAlignment = .center
        label.text = "Bill Processing"
        label.textColor = .blue
        
        //add both to view
        view.addSubview(label)
        view.addSubview(activityIndicator!)
    }
    
    func hideLabels() {
        providerLabel.isHidden = true
        providerTitleLabel.isHidden = true
        nameTitleLabel.isHidden = true
        nameLabel.isHidden = true
        locationTitleLabel.isHidden = true
        locationLabel.isHidden = true
        rateTitleLabel.isHidden = true
        rateLabel.isHidden = true
        descriptionLabel.isHidden = true
        confirmButton.isHidden = true
    }
    func showLabels(companyName: String) {
        providerLabel.isHidden = false
        providerTitleLabel.isHidden = false
        nameTitleLabel.isHidden = false
        nameLabel.isHidden = false
        locationTitleLabel.isHidden = false
        locationLabel.isHidden = false
        rateTitleLabel.isHidden = false
        rateLabel.isHidden = false
        descriptionLabel.isHidden = false
        confirmButton.isHidden = false
        label.isHidden = true
        self.activityIndicator?.stopAnimating()
        self.nameLabel.text = bp?.getName()
        self.locationLabel.text = bp?.getAddress()
        self.rateLabel.text = bp?.getUsage()
        self.providerLabel.text = companyName
    }

}

extension ReviewViewController{
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata!.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

enum company : String {
    case ameren = "Ameren"
    case ugi = "UGI Utlities, Inc."
    case duke = "Duke Energy"
    case comed = "ComEd"
    case dpl = "The Dayton Power and Light Company"
}
