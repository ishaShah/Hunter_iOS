//
//  HunterRegisterCompTwoVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/24/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import CropViewController
import iOSDropDown
import Alamofire
import SVProgressHUD
import MobileCoreServices
import AVFoundation
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
extension UIImageView {
func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
    containerView.clipsToBounds = false
    containerView.layer.shadowColor = UIColor.gray.cgColor
    containerView.layer.shadowOpacity = 0.5
    containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    containerView.layer.shadowRadius = 0.5
    containerView.layer.cornerRadius = cornerRadious
    containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
    containerView.layer.rasterizationScale = UIScreen.main.scale
    containerView.layer.shouldRasterize = true
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadious
}
}
class HunterRegisterCompTwoVC: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var coll_squarePics: UICollectionView!
    @IBOutlet weak var coll_rectPics: UICollectionView!
    @IBOutlet weak var coll_picMin: UICollectionView!
    @IBOutlet weak var coll_video: UICollectionView!
//    @IBOutlet weak var coll_socialMedia: UICollectionView!
    @IBOutlet weak var contButton: UIButton!
    
    var isSquarePics = false
    var isRectPics = false
    var isPicMin = false
    var isVideo = false
    var isSocialMedia = false

    var arr_squarePics = [UIImage]()
    var arr_rectPics = [UIImage]()
    var arr_picMin = [UIImage]()
    var arr_video = [UIImage]()
    var arr_socialMedia = [String]()
    var arr_socialMediaID = [String]()

    let videoFileName = "/video.mp4"

    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var ratioPreset = ""
    
    @IBOutlet weak var lab_square: UILabel!
    @IBOutlet weak var lab_rect: UILabel!
    @IBOutlet weak var lab_pics: UILabel!
    @IBOutlet weak var lab_video: UILabel!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        if self.ratioPreset == "video" {
            // 1
            var dataPath = URL(string: "")
             if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
                // Save video to the main photo album
                let selectorToCall = #selector(HunterRegisterCompTwoVC.videoSaved(_:didFinishSavingWithError:context:))
                
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
            lab_video.isHidden = true

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
        else if self.ratioPreset == "min4" {
            cropController.aspectRatioPreset = .presetSquare;
        }
        else {
            cropController.aspectRatioPreset = .preset16x9;
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
            lab_square.isHidden = true
            connectToRegisterSaveCompanyDetails(image)
            coll_squarePics.reloadData()
            coll_squarePics.isHidden = false
         }
        else if self.ratioPreset == "min4" {
            arr_picMin.append(image)
            lab_pics.isHidden = true
            connectToRegisterSaveAdditionalMediaImageURL(image)
            coll_picMin.reloadData()
            coll_picMin.isHidden = false
         }
        else {
            arr_rectPics = [UIImage]()
            arr_rectPics.append(image)
            lab_rect.isHidden = true
            connectToRegisterSaveCompanyDetails(image)
            coll_rectPics.reloadData()
            coll_rectPics.isHidden = false
         }

//        layoutImageView()
        if arr_squarePics.count != 0 && arr_rectPics.count != 0 && arr_picMin.count >= 4{
            
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }else{
            self.contButton.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }
        
        cropViewController.dismiss(animated: true, completion: nil)
    
    }
    

    
    



    override func viewDidLoad() {
        super.viewDidLoad()
        coll_squarePics.isHidden = true
        coll_rectPics.isHidden = true
        coll_picMin.isHidden = true
//        coll_socialMedia.isHidden = true
        coll_video.isHidden = true
 
        // Do any additional setup after loading the view.
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
    
    @IBAction func rectPicsBtnClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.ratioPreset =  "rect"

            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.ratioPreset =  "rect"

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
    @IBAction func min4PicsBtnClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.ratioPreset =  "min4"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.ratioPreset =  "min4"
            
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
    @IBAction func socialMediaBtnClick(_ sender: Any) {
        self.connectToRegisterSocialMedia()
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
    func connectToRegisterSocialMedia(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerFetchSocialMediaURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                let data = responseDict.value(forKey: "data") as! NSDictionary
                                print (data)
                                 let social_media_icons = data["social_media_icons"] as! NSDictionary
                                
                                self.arr_socialMedia = social_media_icons.allValues as! [String]
                                self.arr_socialMediaID = social_media_icons.allKeys as! [String]
//                                self.coll_socialMedia.reloadData()
//                                self.coll_socialMedia.isHidden = false
                                
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
                        }else{
                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }
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
    func connectToRegisterSaveCompanyDetails(_ selectedImg: UIImage){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerSaveCompanyLogoURL
            print(url)
            HunterUtility.showProgressBar()
            
            var type = 0
            if self.ratioPreset == "square" {
                type = 0
            }else if self.ratioPreset == "min4" {
                type = 0
            }else {
                type = 1
            }
            
            let parameters = ["type": type ] as [String : Any]
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
                        multipartFormData.append(newImageData, withName: "logo", fileName: "image.png", mimeType: "image/png")
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
                            }else if self.ratioPreset == "min4" {

                            }else {
                                self.isRectPics = true
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
                        
                        self.isPicMin = true

                        
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
        }else if arr_rectPics.count == 0{
            self.view.makeToast("Please upload rectangle logo")
        }else if arr_picMin.count < 4{
            self.view.makeToast("Please upload minimum 4 Additional Pics.")
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
                                self.isSocialMedia = true

                                if self.arr_squarePics.count != 0 && self.arr_rectPics.count != 0 && self.arr_picMin.count >= 4{
                                    self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
                                    self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
                                }else{
                                    self.contButton.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
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
        self.navigationController?.popViewController(animated: true)
    }
}
extension HunterRegisterCompTwoVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coll_squarePics {
            return self.arr_squarePics.count
        }
        else if collectionView == coll_rectPics {
            return self.arr_rectPics.count
        }
        else if collectionView == coll_picMin {
            if self.arr_picMin.count > 4{
                return 5
            }else{
                return self.arr_picMin.count
            }
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
            cell.cropImageView.image = self.arr_squarePics[indexPath.row]
//            cell.cropImageView.applyshadowWithCorner(containerView: cell.contentView, cornerRadious:20)
        }else if collectionView == coll_rectPics {
            cell.cropImageView.image = self.arr_rectPics[indexPath.row]
//            cell.cropImageView.applyshadowWithCorner(containerView: cell.contentView, cornerRadious:10)
        }else if collectionView == coll_picMin {
//            cell.cropImageView.applyshadowWithCorner(containerView: cell.contentView, cornerRadious:20)

            if arr_picMin.count > 4{
                if indexPath.row == 4{
                    cell.labelMoreImageCount.isHidden = false
                    cell.cropImageView.isHidden = true
                    cell.labelMoreImageCount.text = "+" + String(arr_picMin.count - 4)
                }else{
                    cell.labelMoreImageCount.isHidden = true
                    cell.cropImageView.isHidden = false
                    cell.cropImageView.image = self.arr_picMin[indexPath.row]
                }
            }else{
                cell.labelMoreImageCount.isHidden = true
                cell.cropImageView.isHidden = false
                cell.cropImageView.image = self.arr_picMin[indexPath.row]
            }
        }else if collectionView == coll_video {
//            cell.cropImageView.applyshadowWithCorner(containerView: cell.contentView, cornerRadious:10)
            cell.cropImageView.image = self.arr_video[indexPath.row]
        }

         return cell
    }
    
}
extension HunterRegisterCompTwoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == coll_rectPics || collectionView == coll_video {
            return CGSize(width: 191, height: 57)
        }
        else { return CGSize(width: 57, height: 57) }
 }
    }

extension HunterRegisterCompTwoVC : UICollectionViewDelegate {
    
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

class HunterRegisterCompTwoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cropImageView: UIImageView!
 
    @IBOutlet weak var labelMoreImageCount: UILabel!
 
}
extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
