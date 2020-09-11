//
//  HunterEditProPicVC.swift
//  Hunter
//
//  Created by Zubin Manak on 20/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import CropViewController
import Alamofire
import SVProgressHUD

class HunterEditProPicVC : UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var ratioPreset = ""

    var isFrom = ""
    @IBOutlet weak var img_proPic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
             

            guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
            
            let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
            //cropController.modalPresentationStyle = .fullScreen
            cropController.delegate = self
            
            // Uncomment this if you wish to provide extra instructions via a title label
            //cropController.title = "Crop Image"
            
            // -- Uncomment these if you want to test out restoring to a previous crop setting --
            //cropController.angle = 90 // The initial angle in which the image will be rotated
            //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
            
            // -- Uncomment the following lines of code to test out the aspect ratio features --
                 cropController.aspectRatioPreset = .presetSquare;
             
            //Set the initial aspect ratio as a square
            cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
            cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
            cropController.aspectRatioPickerButtonHidden = true
            
            // -- Uncomment this line of code to place the toolbar at the top of the view controller --
            //cropController.toolbarPosition = .top
            //cropController.rotateButtonsHidden = true
            //cropController.rotateClockwiseButtonHidden = true
            
            //cropController.doneButtonTitle = "Title"
            //cropController.cancelButtonTitle = "Title"
            
           // self.image = image
            
            //If profile picture, push onto the same navigation stack
            if croppingStyle == .circular {
                if picker.sourceType == .camera {
                    picker.dismiss(animated: true, completion: {
                        self.present(cropController, animated: true, completion: nil)
                    })
                } else {
                    picker.pushViewController(cropController, animated: true)
                }
            }
            else { //otherwise dismiss, and then present from the main controller
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                    //self.navigationController!.pushViewController(cropController, animated: true)
                })
            }
            }
        
         
        public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            self.croppedRect = cropRect
            self.croppedAngle = angle
            updateImageViewWithImage(image, fromCropViewController: cropViewController)
        }
        
        public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            self.croppedRect = cropRect
            self.croppedAngle = angle
            updateImageViewWithImage(image, fromCropViewController: cropViewController)
        }
        
        public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
            img_proPic.image = image
            
            cropViewController.dismiss(animated: true, completion: nil)
        
        }
        

        

    
     @IBAction func useCameraClick(_ sender: Any) {
        self.ratioPreset =  "square"
        
        self.croppingStyle = .default
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadAPhoto(_ sender: Any) {
        self.ratioPreset =  "square"
        
        self.croppingStyle = .default
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtn(_ sender: Any) {
        connectToRegisterSaveCompanyDetails(img_proPic.image!)
    }
    func connectToRegisterSaveCompanyDetails(_ selectedImg: UIImage){
        if HunterUtility.isConnectedToInternet(){
            
            var url = ""
            
            HunterUtility.showProgressBar()
            var loginType = String()
            if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                loginType = type
            }
            
            var profile_image = ""
            // Do any additional setup after loading the view.
            if isFrom == "candidateReg" {
                url = API.candidateBaseURL + API.registerSaveCandidateProfileURL
                profile_image = "profile_image"
            }
            else {
            if loginType == "candidate" {
             
                url = API.candidateBaseURL + API.registerUpdateCandidateProfileURL
                profile_image = "profile_image"

            }
            else {
                url = API.recruiterBaseURL + API.registerUpdateCompanyLogoURL
                profile_image = "logo"

            }
            }
            print(url)

            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
            let imageData = selectedImg.pngData()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                 
                if let data = imageData{
                    if let newImageData = selectedImg.jpeg(.lowest) {
                        
                        multipartFormData.append(newImageData, withName:                 profile_image , fileName: "image.png", mimeType: "image/png")
                    }
                    
                }
                
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print(response.result.value!)
                        SVProgressHUD.dismiss()
                        let dict = (response.result.value!) as! NSDictionary
                        
                        if dict.value(forKey: "status") as! Bool == true{
                            
                            

                             
                            self.view.makeToast(dict["message"] as? String, duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in
                                if self.isFrom == "candidateReg" {
                                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pushToTabBar), userInfo: nil, repeats: false)

                                    }
                                else {
                                self.dismiss(animated: true, completion: nil)
                                }
                            }
                            
                                    
                                
                                
                            
                        }
                        else if dict.value(forKey: "status") as! Int == 2 {
                            let alert = UIAlertController(title: "", message: dict.value(forKey: "message") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            print("Logout api")
                            
                            UserDefaults.standard.removeObject(forKey: "accessToken")
                            UserDefaults.standard.removeObject(forKey: "loggedInStat")
                            accessToken = String()
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
                            let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
                            navigationController.viewControllers = [mainRootController]
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = navigationController
                        }
                        else{
                            let alert = UIAlertController(title: "", message: dict.value(forKey: "error") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    SVProgressHUD.dismiss()
                    
                }
            }
        }else{
            self.view.makeToast("Please check your internet connection.", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
        }
    }
    @objc func pushToTabBar() {
        let vc = UIStoryboard(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
        self.navigationController?.pushViewController(vc, animated: true)
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
