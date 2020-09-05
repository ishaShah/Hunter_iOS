
//
//  HunterCompanyProfileVC.swift
//  Hunter
//
//  Created by Zubin Manak on 07/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import SVProgressHUD
import SDWebImage
import CropViewController

class HunterCompanyProfileVC: UIViewController, UITextFieldDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textCompanyName: UITextField!
    @IBOutlet weak var imgEditView: UIView!
    @IBOutlet weak var textCompanySize: DropDown!
    @IBOutlet weak var textFounded: DropDown!
    @IBOutlet weak var textCompanyType: DropDown!
    @IBOutlet weak var textLocation: DropDown!
    @IBOutlet weak var stackName: UIStackView!
    @IBOutlet weak var constraintHeightNameStack: NSLayoutConstraint!
    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textLastName: UITextField!
    @IBOutlet weak var btn_uploadCover: UIButton!
    @IBOutlet weak var imageCoverIcon: UIImageView!
    @IBOutlet weak var imageUploadButton: UIImageView!
    @IBOutlet weak var scrlV: UIScrollView!
    @IBOutlet weak var scrlCV: UIView!
    
    @IBOutlet weak var txt_desc: UITextView!
    @IBOutlet weak var imgv_proPic: UIImageView!
    @IBOutlet weak var img_thumb: UIImageView!

    @IBOutlet weak var btn_uploadImg: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var edit1: UIButton!
    @IBOutlet weak var edit2: UIButton!
    @IBOutlet weak var edit3: UIButton!
    @IBOutlet weak var edit4: UIButton!
    @IBOutlet weak var edit5: UIButton!
    @IBOutlet weak var edit6: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    var arrayLocation = [String]()
    var arrayLocationID = [Int]()
    var selectedlocationID = 0
    
    var arraySize = [String]()
    var arraySizeID = [Int]()
    var selectedSizeID = 0
    
    var arrayType = [String]()
    var arrayTypeID = [String]()
    var selectedTypeID = 0
    
    var isNameEdited = false
    var firstName = String()
    var lastName = String()
    
    var isSQImage = false
    var isRGImage = false
    var editMode = true
    var profileDesc = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Do any additional setup after loading the view.
//        scrlCV.roundCorners([.topLeft, .topRight], radius: 20.0)
        scrlV.roundCorners([.topLeft, .topRight], radius: 20.0)

        textName.isHidden = false
        stackName.isHidden = true
        constraintHeightNameStack.constant = 20.0
        hidenAndShowBtns(true)
        
        let df = DateFormatter()
        let year = Calendar.current.component(.year, from: Date())
        self.textFounded.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
        self.textFounded.selectedRowColor = UIColor.init(hexString: "E8E4F2")
        self.textFounded.checkMarkEnabled = false
        self.textFounded.rowHeight = 40.0
        self.textFounded.isSearchEnable = false
        // The list of array to display. Can be changed dynamically
        self.textFounded.optionArray = df.years(1970...year).reversed()
        //Its Id Values and its optional
        // Image Array its optional
        // The the Closure returns Selected Index and String
        self.textFounded.didSelect{(selectedText , index ,id) in
            self.textFounded.text = "\(selectedText)"
        }
        isFrom = ""

        connectToGetProfileData()
        connectToGetCompanyLocations()

        NotificationCenter.default.addObserver(self, selector: #selector(self.GetProfileData(notification:)), name: NSNotification.Name(rawValue: "candidate_Id"), object: nil)

    }
    
    @objc  func GetProfileData(notification: NSNotification) {
        if let candidate_Id = notification.userInfo?["candidate_Id"] as? Int {
            // do something with your image
            self.candidate_Id = candidate_Id
            isFrom = "cards"

            connectToGetProfileData()
            connectToGetCompanyLocations()

        }

    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        setNeedsStatusBarAppearanceUpdate()
        
        
        textCompanySize.leftViewEnabled = false
        textFounded.leftViewEnabled = false
        textCompanyType.leftViewEnabled = false
        textLocation.leftViewEnabled = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func hidenAndShowBtns(_ edit: Bool){
        editBtn.isHidden = !edit
        cancelBtn.isHidden = edit
        saveBtn.isHidden = edit
        btn_uploadCover.isHidden = edit
        btn_uploadImg.isHidden = edit
        imgEditView.isHidden = edit
        edit1.isHidden = edit
        edit2.isHidden = edit
        edit3.isHidden = edit
        edit4.isHidden = edit
        edit5.isHidden = edit
        edit6.isHidden = edit
        editMode = edit
    }
    @IBAction func settings(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterRecSettingsVC") as! HunterRecSettingsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonEditProfile(_ sender: Any) {
        connectToGetCompanyLocations()
        connectToGetCompanySizeType()
        hidenAndShowBtns(false)
    }
    @IBAction func cancelProfile(_ sender: Any) {
        textName.isHidden = false
        stackName.isHidden = true
        constraintHeightNameStack.constant = 20.0
        txt_desc.text = self.profileDesc
        txt_desc.borderWidthV = 1.0
        txt_desc.isEditable = false
        textCompanySize.isEnabled = false
        textFounded.isEnabled = false
        textLocation.isEnabled = false
        textCompanyType.isEnabled = false
        imageCoverIcon.isHidden = false
        imageUploadButton.isHidden = false
        hidenAndShowBtns(true)
        connectToGetProfileData()
    }
    @IBAction func saveBtn(_ sender: Any) {
        hidenAndShowBtns(true)
        connectToUpdateProfileDetails()
    }
    @IBAction func buttonEditProfileName(_ sender: UIButton) {
        textFirstName.text = firstName
        textLastName.text = lastName
        isNameEdited = true
        textName.isHidden = true
        stackName.isHidden = false
        constraintHeightNameStack.constant = 40.0
    }
    @IBAction func buttonEditCompanySize(_ sender: UIButton) {
        textCompanySize.isEnabled = true
        textCompanySize.becomeFirstResponder()
    }
    @IBAction func buttonEditFounded(_ sender: UIButton) {
        textFounded.isEnabled = true
        textFounded.becomeFirstResponder()
    }
    @IBAction func buttonEditLocation(_ sender: UIButton) {
        textLocation.isEnabled = true
        textLocation.becomeFirstResponder()
    }
    @IBAction func buttonEditCompanyType(_ sender: UIButton) {
        textCompanyType.isEnabled = true
        textCompanyType.becomeFirstResponder()
    }
    @IBAction func buttonEditCompanyDesc(_ sender: UIButton) {
        txt_desc.isEditable = true
        txt_desc.borderWidthV = 1.0
        txt_desc.becomeFirstResponder()
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
    @IBAction func uploadCover(_ sender: Any) {
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
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var ratioPreset = ""
    //MARK:- Image picker delegate
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
        if self.ratioPreset == "square" {
            cropController.aspectRatioPreset = .presetSquare;
        }else if self.ratioPreset == "min4" {
            cropController.aspectRatioPreset = .presetSquare;
        }else {
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
            }else {
                picker.pushViewController(cropController, animated: true)
            }
        }else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    //MARK:- Cropview delegates
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
            imgv_proPic.image = image
            isSQImage = true
            imageUploadButton.isHidden = true
        }else {
            img_thumb.image = image
            isRGImage = true
            imageCoverIcon.isHidden = true
        }
        //        layoutImageView()
        cropViewController.dismiss(animated: true, completion: nil)
    }
    //MARK:- Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    var isFrom = ""
    var candidate_Id = 0
    //MARK:- Webservice
    func connectToGetProfileData(){
        
        if isFrom == "cards" {
            if HunterUtility.isConnectedToInternet(){
                
                var url = API.recruiterBaseURL + API.candidate_profileURL
                
                print(url)
                HunterUtility.showProgressBar()
                
                let headers    = [ "Authorization" : "Bearer " + accessToken]
                let params = ["candidate_id" : candidate_Id]
                Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        if let responseDict = response.result.value as? NSDictionary{
                            print(responseDict)
                            SVProgressHUD.dismiss()
                            if let status = responseDict.value(forKey: "status"){
                                if status as! Int == 1   {
                                    if let dataDict = responseDict.value(forKey: "data") as? NSDictionary {
                                       if let profile = dataDict.value(forKey: "profile") as? NSDictionary {
                                            self.textName.text = "\(profile["first_name"] as! String)  \(profile["last_name"] as! String)"
                                            self.firstName = profile["first_name"] as! String
                                            self.lastName = profile["last_name"] as! String
                                        self.textCompanyName.text = "\(profile["company_name"] as! String)".uppercased()
                                            self.textCompanySize.text = "\(profile["company_size"] as! String)"
                                            self.textCompanyType.text = "\(profile["company_type"] as! String)"
                                            self.txt_desc.text = "\(profile["description"] as! String)"
                                            self.profileDesc = "\(profile["description"] as! String)"
                                            self.textFounded.text = "\(profile["founded"] as! String)"
                                            self.textLocation.text = "\(profile["location"] as! String)"
                                            if let url = profile["square_logo"] as? String{
                                                self.imgv_proPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                            }
                                        }
                                    }
                                }else if status as! Int == 2 {
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
        else {
        if HunterUtility.isConnectedToInternet(){
            
            var url = API.recruiterBaseURL + API.profileURL
            
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
                            if status as! Int == 1   {
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary {
                                    if let profile = dataDict.value(forKey: "profile") as? NSDictionary {
                                        self.textName.text = "\(profile["first_name"] as? String ?? "")  \(profile["last_name"] as? String ?? "")"
                                        self.firstName = profile["first_name"] as? String ?? ""
                                        self.lastName = profile["last_name"] as? String ?? ""
                                        self.textCompanyName.text = "\(profile["company_name"] as! String)".uppercased()
                                        self.textCompanySize.text = "\(profile["company_size"] as! String)"
                                        self.textCompanyType.text = "\(profile["business_type"] as! String)"
                                        self.txt_desc.text = "\(profile["about"] as! String)"
                                        self.profileDesc = "\(profile["about"] as! String)"
                                        self.textFounded.text = "\(profile["founded_on"] as! String)"
                                        self.textLocation.text = "\(profile["location"] as! String)"
                                        if let url = profile["square_logo"] as? String{
                                            self.imgv_proPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                        }
                                    }
                                }
                            }else if status as! Int == 2 {
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
    }
    func connectToUpdateProfileDetails(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.profileUpdateURL
            print(url)
            HunterUtility.showProgressBar()
            
            var parameters = [String : Any]()
            
            var desc = String()
            if txt_desc.text == "Type description here"{
                desc = ""
            }else{
                desc = txt_desc.text
            }
            
            parameters = ["description": desc,
                          "company_name": textCompanyName.text ?? "",
                          "location_id": selectedlocationID,
                          "company_size_id": selectedSizeID,
                          "company_type_id": selectedTypeID,
                          "founded": textFounded.text ?? ""]
            if isNameEdited{
                parameters["first_name"] = textFirstName.text!
                parameters["last_name"] = textLastName.text!
            }
            print(parameters)
            
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
                        
            let imageData = imgv_proPic.image!.pngData()
            let imageDataRect = img_thumb.image!.pngData()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if self.isSQImage == true {
                    if let data = imageData{
                        multipartFormData.append(data, withName: "square_logo", fileName: "image.png", mimeType: "image/png")
                    }
                }
                
                if self.isRGImage == true {
                    if let data = imageDataRect{
                        multipartFormData.append(data, withName: "rectangle_logo", fileName: "image.png", mimeType: "image/png")
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
                        if self.isSQImage == true {
                            self.isSQImage = false
                            
                        }
                        
                        if self.isRGImage == true {
                            self.isRGImage = false
                        }
                        
                        if dict.value(forKey: "status") as! Bool == true{
                            DispatchQueue.main.async {
                                self.textName.isHidden = false
                                self.stackName.isHidden = true
                                self.constraintHeightNameStack.constant = 20.0
                                self.textName.text = self.firstName.uppercased() + " " + self.lastName.uppercased()
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
    func connectToGetCompanyLocations(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.recruiterBaseURL + API.registerPreferedLocationsURL
            print(url)
            HunterUtility.showProgressBar()
            let headers = [ "Authorization" : "Bearer " + accessToken]
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        self.arrayLocation = [String]()
                        self.arrayLocationID = [Int]()
                        self.selectedlocationID = 0
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
                                print (data)
                                for locData in data {
                                    print (locData)
                                    self.arrayLocation.append(locData.value(forKey: "location") as! String)
                                    self.arrayLocationID.append(locData.value(forKey: "id") as! Int)
                                }
                                self.textLocation.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
                                self.textLocation.selectedRowColor = UIColor.init(hexString: "E8E4F2")
                                self.textLocation.checkMarkEnabled = false
                                self.textLocation.rowHeight = 40.0
                                self.textLocation.isSearchEnable = false
                                
                                // The list of array to display. Can be changed dynamically
                                self.textLocation.optionArray = self.arrayLocation
                                //Its Id Values and its optional
                                self.textLocation.optionIds = self.arrayLocationID
                                
                                // Image Array its optional
                                // The the Closure returns Selected Index and String
                                self.textLocation.didSelect{(selectedText , index ,id) in
                                    self.textLocation.text = "\(selectedText)"
                                    self.selectedlocationID = self.arrayLocationID[index]
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
    func connectToGetCompanySizeType(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerCompanyDataURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        self.arraySize = [String]()
                        self.arraySizeID = [Int]()
                        self.selectedSizeID = 0
                        
                        self.arrayType = [String]()
                        self.arrayTypeID = [String]()
                        self.selectedTypeID = 0
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                let data = responseDict.value(forKey: "data") as! NSDictionary
                                let company_registration = data.value(forKey:"company_registration") as! NSDictionary
                                let size = company_registration.value(forKey: "size") as! NSDictionary
                                let type = company_registration.value(forKey: "type") as! NSDictionary
                                
                                let sizeData = size.value(forKey: "data") as! [NSDictionary]
                                let typeData = type.value(forKey: "data") as! NSDictionary
                                //fetching company size data
                                for data in sizeData {
                                    print (data)
                                    self.arraySize.append(data.value(forKey: "company_size") as! String)
                                    self.arraySizeID.append(data.value(forKey: "id") as! Int)
                                }
                                self.textCompanySize.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
                                self.textCompanySize.selectedRowColor = UIColor.init(hexString: "E8E4F2")
                                self.textCompanySize.checkMarkEnabled = false
                                self.textCompanySize.rowHeight = 40.0
                                self.textCompanySize.isSearchEnable = false
                                
                                // The list of array to display. Can be changed dynamically
                                self.textCompanySize.optionArray = self.arraySize
                                //Its Id Values and its optional
                                self.textCompanySize.optionIds = self.arraySizeID
                                
                                // Image Array its optional
                                // The the Closure returns Selected Index and String
                                self.textCompanySize.didSelect{(selectedText , index ,id) in
                                    self.textCompanySize.text = "\(selectedText)"
                                    self.selectedSizeID = self.arraySizeID[index]
                                }
 
                                for key in typeData.allKeys {
                                    self.arrayType.append(typeData[key] as! String)
                                    self.arrayTypeID.append(key as! String)
                                }
                                self.textCompanyType.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
                                self.textCompanyType.selectedRowColor = UIColor.init(hexString: "E8E4F2")
                                self.textCompanyType.checkMarkEnabled = false
                                self.textCompanyType.rowHeight = 40.0
                                self.textCompanyType.isSearchEnable = false
                                
                                // The list of array to display. Can be changed dynamically
                                self.textCompanyType.optionArray = self.arrayType
                                //Its Id Values and its optional
//                                self.textCompanyType.optionIds = self.arrayTypeID
                                
                                // Image Array its optional
                                // The the Closure returns Selected Index and String
                                self.textCompanyType.didSelect{(selectedText , index ,id) in
                                    self.textCompanyType.text = "\(selectedText)"
                                    self.selectedTypeID = Int(self.arrayTypeID[index])!
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
}
