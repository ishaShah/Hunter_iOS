//
//  HunterImagesVC.swift
//  Hunter
//
//  Created by Zubin Manak on 20/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import CropViewController
import iOSDropDown
import Alamofire
import SVProgressHUD
import MobileCoreServices
import AVFoundation

class HunterImagesVC: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var coll_squarePics: UICollectionView!
     
    @IBOutlet weak var coll_video: UICollectionView!
     @IBOutlet weak var contButton: UIButton!
    
    
    var isVideo = false
 
    var arr_squarePics = [UIImage]()
    
    var arr_video = [UIImage]()
     

    let videoFileName = "/video.mp4"

    private var croppingStyle = CropViewCroppingStyle.default
    var isSquarePics = false

    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var arrayImages = [String]()

    var ratioPreset = ""
    // https://huntrapp.chkdemo.com/api/recruiter/profile/get-additional-media
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        if self.ratioPreset == "video" {
            // 1
            var dataPath = URL(string: "")
             if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
                // Save video to the main photo album
                let selectorToCall = #selector(HunterImagesVC.videoSaved(_:didFinishSavingWithError:context:))
                
                // 2
                UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
                // Save the video to the app directory
                let videoData = try! Data(contentsOf: selectedVideo)
                let paths = NSSearchPathForDirectoriesInDomains(
                    FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
                dataPath = documentsDirectory.appendingPathComponent(videoFileName)
                connectToRegisterSaveAdditionalMediaVideoURL(videoData)


                try! videoData.write(to: dataPath!, options: [])
            }
            // 3
            
            arr_video.append(generateThumbnail(url: dataPath!)!)
 
            coll_video.reloadData()
            coll_video.isHidden = false
            
            
            picker.dismiss(animated: true)
        }
        else {

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
        if self.ratioPreset == "square" {
            cropController.aspectRatioPreset = .presetSquare;
        }
         
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
    }
    func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            // Select the right one based on which version you are using
            // Swift 4.2
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)
            // Swift 4.0
//            let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero,
//                                                         actualTime: nil)
            
            
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
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
        if self.ratioPreset == "square" {
            arr_squarePics = [UIImage]()
            arr_squarePics.append(image)
             connectToRegisterSaveCompanyDetails(image)
         }
         

//        layoutImageView()
        if arr_squarePics.count != 0{
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }else{
            self.contButton.setTitleColor(UIColor.init(hexString:"300471" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }
        
        cropViewController.dismiss(animated: true, completion: nil)
    
    }
    

    
    



    override func viewDidLoad() {
        super.viewDidLoad()
        coll_squarePics.isHidden = true
        
//        coll_socialMedia.isHidden = true
        coll_video.isHidden = true
        connectToGetAdditionalMedia()
        // Do any additional setup after loading the view.
    }
    //MARK:- Webservice
    func connectToGetAdditionalMedia(){
        if HunterUtility.isConnectedToInternet(){
            self.arrayImages = []
            let url = API.recruiterBaseURL + API.getAdditionalMediaURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if let dataDict = responseDict.value(forKey: "data") as? NSDictionary {
                                if let profile = dataDict.value(forKey: "profile") as? NSDictionary {
                                if let additional_images = profile.value(forKey: "additional_images") as? [NSDictionary] {
                                    for imag in additional_images {
                                        self.arrayImages.append(imag["filename"] as! String)
                                    }
                                    self.coll_squarePics.reloadData()
                                    self.coll_squarePics.isHidden = false
                                    }
                                }
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            print("no internet")
        }
    }
    @IBAction func squarePicsBtnClick(_ sender: Any) {
        
        
        
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.ratioPreset =  "square"
                
                self.croppingStyle = .default
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            let profileAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                self.ratioPreset =  "square"
                
                self.croppingStyle = .default
                
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            alertController.addAction(defaultAction)
            alertController.addAction(profileAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            alertController.modalPresentationStyle = .popover
            
            let presentationController = alertController.popoverPresentationController
            presentationController?.barButtonItem = (sender as! UIBarButtonItem)
            present(alertController, animated: true, completion: nil)
        
        
    }
    
        @IBAction func videoBtnClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.ratioPreset =  "video"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.ratioPreset =  "video"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Webservice
 
    func connectToRegisterSaveCompanyDetails(_ selectedImg: UIImage){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.addAdditionalImagesURL
            print(url)
            HunterUtility.showProgressBar()
            
             
            
 
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
            let imageData = selectedImg.pngData()

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if let data = imageData{
                    if let newImageData = selectedImg.jpeg(.lowest) {
                        multipartFormData.append(newImageData, withName: "media", fileName: "image.png", mimeType: "image/png")
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
                            
                            

                            if self.ratioPreset == "square" {
                                self.isSquarePics = true
                                self.connectToGetAdditionalMedia()
                            }
                            
                            self.view.makeToast(dict["message"] as? String, duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
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
    func connectToRegisterSaveAdditionalMediaImageURL(_ selectedImg: UIImage){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerSaveAdditionalMediaURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            
            let parameters = ["media_type": 0 ] as [String : Any]
            print(parameters)
            
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
            let imageData = selectedImg.pngData()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
 
                if let data = imageData{
                    if let newImageData = selectedImg.jpeg(.lowest) {
                        multipartFormData.append(newImageData, withName: "media", fileName: "image.png", mimeType: "image/png")
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
                            self.view.makeToast(dict["message"] as? String, duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
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
    func connectToRegisterSaveAdditionalMediaVideoURL(_ videoData: Data){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerSaveAdditionalMediaURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            
            let parameters = ["media_type": 1 ] as [String : Any]
            print(parameters)
            
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                    multipartFormData.append(videoData, withName: "media", fileName: "file.mp4", mimeType: "video/mp4")
                    
                
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
                            self.view.makeToast(dict["message"] as? String, duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
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
    @IBAction func continueBtnCLick(_ sender: Any) {
/*        if isSquarePics == false {
            self.view.makeToast("Please upload square logo")
        }
        else if isRectPics == false {
            self.view.makeToast("Please upload rectangle logo")
        }
        else if isSocialMedia == false {
            self.view.makeToast("Please upload Social Media link")
        }
        else if isPicMin == false {
            self.view.makeToast("Please upload Additional Pics.")
        }*/
        if arr_squarePics.count == 0{
            self.view.makeToast("Please upload square logo")
        }
/*        else if isSocialMedia == false {
            self.view.makeToast("Please upload Social Media link")
        }*/
        else {
            connectToRegisterSaveCompanyFinal()
        }
    }
    func connectToRegisterSaveCompanyFinal(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerCompleteRegistrationURL
            print(url)
            HunterUtility.showProgressBar()
            
        
            let paramsDict = ["complete_registration": 1 ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                                                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pushToTabBar), userInfo: nil, repeats: false)

                            }
                            else if status as! Int == 2 {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
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
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            print("no internet")
        }
    }
    @objc func pushToTabBar() {
        let vc = UIStoryboard(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func connectToRegisterSocialMediaFinal(_ social_media_id : Int , _ link : String){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerSaveSocialMediaURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            let paramsDict = ["social_media_id": social_media_id  , "link" : link ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
//                                self.coll_socialMedia.isHidden = true
 
                                if self.arr_squarePics.count != 0 {
                                    self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
                                    self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
                                }else{
                                    self.contButton.setTitleColor(UIColor.init(hexString:"300471" ), for: UIControl.State.normal)
                                    self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
                                }
                            }
                            else if status as! Int == 2 {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
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
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            print("no internet")
        }
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension HunterImagesVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coll_squarePics {
            return self.arrayImages.count
        }
        else if collectionView == coll_video {
            return self.arr_video.count
        }
//        else if collectionView == coll_socialMedia {
//            return self.arr_socialMedia.count
//        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterRegisterCompTwoCollectionCell", for: indexPath) as! HunterRegisterCompTwoCollectionCell
        if collectionView == coll_squarePics {
            if let url = arrayImages[indexPath.row] as? String{
                cell.cropImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
            }
        }else if collectionView == coll_video {
            cell.cropImageView.applyshadowWithCorner(containerView: cell.contentView, cornerRadious:10)
            cell.cropImageView.image = self.arr_video[indexPath.row]
        }

         return cell
    }
    
}
extension HunterImagesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coll_squarePics {
            
            return CGSize(width: 180, height: 180)
        }
        else {
            return CGSize(width: 220, height: 150)
            
        }
    }
}

extension HunterImagesVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == coll_socialMedia {
//            showInputDialog(title: "Add Link",
//                            subtitle: "Please enter the Link below.",
//                            actionTitle: "Add",
//                            cancelTitle: "Cancel",
//                            inputPlaceholder: "Link",
//                            inputKeyboardType: .default)
//            { (input:String?) in
//                self.connectToRegisterSocialMediaFinal(Int(self.arr_socialMediaID[indexPath.row])!, input!)
//            }
//        }
        
    }
    
}

 
 
