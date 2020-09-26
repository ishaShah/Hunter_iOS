
//
//  HunterChatVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 18/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CropViewController
import Kingfisher
import FileBrowser


extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
//extension UIScrollView {
//    func scrollToBottom(animated: Bool) {
//        if self.contentSize.height < self.bounds.size.height { return }
//        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
//        self.setContentOffset(bottomOffset, animated: animated)
//    }
//}
class HunterChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CropViewControllerDelegate, UIImagePickerControllerDelegate,UIDocumentPickerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var tableChat: UITableView!
//    @IBOutlet weak var heightTableChat: NSLayoutConstraint!
    
    @IBOutlet weak var sendView: UIView!
    
    @IBOutlet weak var textMessage: UITextField!
     var arrayChatList = [HunterChatModel]()
    var dictRecruiterDetails = HunterChatDescriptionModel()
    var selectedJobId = Int()
    var selectedCandidateId = String()
    var selectedChatName = String()
    var loginType = String()
    var getMessagesURL = String()
    var sendMessageURL = String()
    
    
    private var croppingStyle = CropViewCroppingStyle.default
    var isSquarePics = false

    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
 
    var ratioPreset = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = selectedChatName
        print(selectedChatName)
        tableChat.tableFooterView = UIView()
        
//        scrollV.scrollToBottom(animated: true)

//        sendView.round(corners: [.bottomLeft, .bottomRight], radius: 30)

        sendView.layer.masksToBounds = false
        sendView.layer.shadowRadius = 4
        sendView.layer.shadowOpacity = 1
        sendView.layer.shadowColor = UIColor.gray.cgColor
        sendView.layer.shadowOffset = CGSize(width: 0 , height:2)
        
        if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
            loginType = type
        }
        if loginType == "candidate" {
            getMessagesURL = API.candidateBaseURL + API.chatMessageViewURL
            sendMessageURL = API.candidateBaseURL + API.sendCandidateMessageURL
        }else{
            getMessagesURL = API.recruiterBaseURL + API.chatMessageViewURL
            sendMessageURL = API.recruiterBaseURL + API.sendRecruiterMessageURL
        }
        connectToGetMessages()
    }
    // Apply round corner and border. An extension method of UIView.
    
    @IBAction func matches(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterMessagesVC") as! HunterMessagesVC
         
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func buttonSendChat(_ sender: UIButton) {
        if textMessage.text != ""{
            connectToSendChatMessage()
        }
    }
//    func scrollToBottom(){
//        DispatchQueue.main.async {
//            if self.scrollV.contentSize.height > self.scrollV.bounds.size.height {
//                let bottomOffset = CGPoint(x: 0, y: self.scrollV.contentSize.height - self.scrollV.bounds.size.height)
//                self.scrollV.setContentOffset(bottomOffset, animated: true)
//            }
//
////            let bottomOffset : CGPoint = CGPoint(x: 0, y: self.scrollV.contentSize.height - self.scrollV.bounds.size.height + self.scrollV.contentInset.bottom)
////            self.scrollV.setContentOffset(bottomOffset, animated: true)
//
////            let bottomOffset = CGPoint(x: 0, y: self.scrollV.contentSize.height - self.scrollV.bounds.size.height)
////            self.scrollV.setContentOffset(bottomOffset, animated: true)
//        }
//    }
    
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
//           if self.ratioPreset == "square" {
               cropController.aspectRatioPreset = .presetOriginal;
//           }
            
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
 
             connecToSendAttachmentsToRecruiter(newImage: image)
             cropViewController.dismiss(animated: true, completion: nil)
         
         }
    func connecToSendFileAttachmentsToRecruiter(_ file: Data,filename : String) {
        if HunterUtility.isConnectedToInternet(){
            
            var url = ""
            print(url)
            HunterUtility.showProgressBar()
            
            var parameters = [String:Any]()
            
            if loginType == "candidate" {
                url = API.candidateBaseURL + API.sendAttachmentToRecruiterURL
                parameters = ["swipe_id": selectedJobId]
            }else{
                url = API.recruiterBaseURL + API.sendAttachmentToCandidateURL

                parameters = ["swipe_id": selectedCandidateId]

            }
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
 
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
                if (filename.contains(".pdf")){
                    multipartFormData.append(file, withName: "upload_data" , fileName: filename, mimeType: "application/pdf")

                }
                else if (filename.contains(".docx")){
                    multipartFormData.append(file, withName: "upload_data" , fileName: filename, mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")

                }
                else if (filename.contains(".doc")){
                    multipartFormData.append(file, withName: "upload_data" , fileName: filename, mimeType: "application/msword")

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
                        
                        if dict.value(forKey: "status") as! Bool == true {
                            print(dict)
                            self.connectToGetMessages()
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
    func connecToSendAttachmentsToRecruiter(newImage : UIImage) {
        if HunterUtility.isConnectedToInternet(){
            
            var url = ""
            print(url)
            HunterUtility.showProgressBar()
            
            var parameters = [String:Any]()
            
            if loginType == "candidate" {
                url = API.candidateBaseURL + API.sendAttachmentToRecruiterURL
                parameters = ["swipe_id": selectedJobId]
            }else{
                url = API.recruiterBaseURL + API.sendAttachmentToCandidateURL

                parameters = ["swipe_id": selectedCandidateId]

            }
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
            let imageData = newImage.pngData()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if let data = imageData{
                    if let newImageData = newImage.jpeg(.lowest) {
                        multipartFormData.append(newImageData, withName: "attachment", fileName: "image.png", mimeType: "image/png")
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
                        
                        if dict.value(forKey: "status") as! Bool == true {
                            print(dict)
                            self.connectToGetMessages()
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
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var documentData = [Data]()
        do {
            for url in urls {
                documentData.append(try Data(contentsOf: url))
            }
            
            
        } catch {
            print("no data")
        }
        let theFileName = (urls[0].absoluteString as NSString).lastPathComponent
        self.connecToSendFileAttachmentsToRecruiter(documentData[0], filename: theFileName)
        
        

      
    }
    
    
    @IBAction func addAttachments(_ sender: Any) {
        
        
        
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
        let FilesAction = UIAlertAction(title: "Files", style: .default) { (action) in
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
            
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
            
            
            
            //                 let fileBrowser = FileBrowser()
            //                fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            //                    print(file.displayName)
            //                    let data = try? Data(contentsOf: file.filePath as URL)
            //                    self.connecToSendFileAttachmentsToRecruiter(data!, filename: file.displayName)
            //                }
            //                self.present(fileBrowser, animated: true, completion: nil)
            
            
        }
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.addAction(FilesAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
        
        
    }
    @IBAction func goToMessages(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
//    func autosizeChatTable(){
//        DispatchQueue.main.async {
//            self.view.layoutIfNeeded()
//            self.tableChat.layoutIfNeeded()
//            let height = self.tableChat.contentSize.height
//            print(height)
//            self.heightTableChat.constant = height
//            self.tableChat.needsUpdateConstraints()
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black

        setNeedsStatusBarAppearanceUpdate()
            
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    //MARK:- Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayChatList.count + 1
    }
    @IBAction func imageViewExpandReciever(_ sender: UIButton) {
        let tag = sender.tag
        if let message = arrayChatList[tag].message{
            let vc = UIStoryboard(name: "Jobs", bundle: nil).instantiateViewController(withIdentifier: "HunterImageVC") as! HunterImageVC
            vc.modalPresentationStyle = .overFullScreen
            vc.imgUrl = message
            self.present(vc, animated: true, completion: nil)
        }

    }
    @IBAction func imageViewExpand(_ sender: UIButton) {
        let tag = sender.tag
        if let message = arrayChatList[tag].message{
            let vc = UIStoryboard(name: "Jobs", bundle: nil).instantiateViewController(withIdentifier: "HunterImageVC") as! HunterImageVC
            vc.modalPresentationStyle = .overFullScreen
            vc.imgUrl = message
            self.present(vc, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HunterChatHeaderTableViewCell", for: indexPath) as! HunterChatHeaderTableViewCell
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            
            if loginType == "candidate" {
                
                if let logo = self.dictRecruiterDetails.square_logo{
                    cell.imageLogo.contentMode = .scaleToFill
                    let imageURL = URL(string: logo)
                    cell.imageLogo.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
                }
                if let recruiterName = self.dictRecruiterDetails.company_name{
                    cell.labelName.text = recruiterName
                }
                if let designation = self.dictRecruiterDetails.job_title{
                    cell.labelDesignation.text = designation
                }
                if let matchedOn = self.dictRecruiterDetails.matched_on{
                    cell.labelMatchedOn.text = matchedOn
                }
            }
            else {
                     if let logo = self.dictRecruiterDetails.profile_img{
                        cell.imageLogo.contentMode = .scaleToFill
                        let imageURL = URL(string: logo)
                        cell.imageLogo.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
                    }
                    if let name = self.dictRecruiterDetails.candidate_name{
                        cell.labelName.text = name
                    }
                    if let matchedOn = self.dictRecruiterDetails.matched_on{
                        cell.labelMatchedOn.text = matchedOn
                    }
                
            }
            return cell

        }
        else {
        if let postedBy = arrayChatList[indexPath.row-1].posted_by{
            if postedBy == loginType{
                
                let type = arrayChatList[indexPath.row-1].type
                if type == "image" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterChatSenderImageCell", for: indexPath) as! HunterChatSenderImageCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                
                cell.viewChatCV.layer.cornerRadius = 5.0
                cell.viewChatCV.layer.masksToBounds = true
                    
                    cell.imgClick.tag = indexPath.row-1
                    
                if let postedBy = arrayChatList[indexPath.row-1].posted_by{
                    if postedBy == loginType{
                        if let message = arrayChatList[indexPath.row-1].message{
                            let url = URL(string: message)
                            cell.imgSentImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
                            
                        }
                    }
                }
                return cell
                }
                    if type == "file" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HunterChatSenderFileCell", for: indexPath) as! HunterChatSenderFileCell
                    cell.selectionStyle = .none
                    tableView.separatorStyle = .none
                    
                    cell.viewChatCV.layer.cornerRadius = 5.0
                    cell.viewChatCV.layer.masksToBounds = true
                    if let postedBy = arrayChatList[indexPath.row-1].posted_by{
                        if postedBy == loginType{
                            if let message = arrayChatList[indexPath.row-1].message{
                                let url = URL(string: message)
                                 
                                
                            }
                        }
                    }
                    return cell
                    }
                else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterSenderCell", for: indexPath) as! HunterChatCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.viewChatCV.layer.cornerRadius = 5.0
                cell.viewChatCV.layer.masksToBounds = true
                
                if let message = arrayChatList[indexPath.row-1].message{
                    cell.textChat.text = message
                }
                return cell
                    }
            }else{
                 let type = arrayChatList[indexPath.row-1].type
               if type == "image" {
               let cell = tableView.dequeueReusableCell(withIdentifier: "HunterChatRecieverImageCell", for: indexPath) as! HunterChatRecieverImageCell
               cell.selectionStyle = .none
               tableView.separatorStyle = .none
               
               cell.viewChatCV.layer.cornerRadius = 5.0
               cell.viewChatCV.layer.masksToBounds = true
                
                cell.imgClick.tag = indexPath.row-1

               if let postedBy = arrayChatList[indexPath.row-1].posted_by{
                   if postedBy != loginType{
                       if let message = arrayChatList[indexPath.row-1].message{
                           let url = URL(string: message)
                           cell.imgRecievedImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))                        }
                   }
               }
               return cell
               }
                if type == "file" {
                                   let cell = tableView.dequeueReusableCell(withIdentifier: "HunterChatRecieverFileCell", for: indexPath) as! HunterChatRecieverFileCell
                                   cell.selectionStyle = .none
                                   tableView.separatorStyle = .none
                                   
                                   cell.viewChatCV.layer.cornerRadius = 5.0
                                   cell.viewChatCV.layer.masksToBounds = true
                                   if let postedBy = arrayChatList[indexPath.row-1].posted_by{
                                       if postedBy == loginType{
                                           if let message = arrayChatList[indexPath.row-1].message{
                                               let url = URL(string: message)
                                                
                                               
                                           }
                                       }
                                   }
                                   return cell
                                   }
                               else {
             
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterReceiverCell", for: indexPath) as! HunterChatCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                
                cell.viewChatCV.layer.cornerRadius = 5.0
                cell.viewChatCV.layer.masksToBounds = true
                if let postedBy = arrayChatList[indexPath.row-1].posted_by{
                    if postedBy != loginType{
                        if let message = arrayChatList[indexPath.row-1].message{
                            cell.textChat.text = message
                        }
                    }
                }
                return cell
                }
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HunterReceiverCell", for: indexPath) as! HunterChatCell
            return cell
        }
    }
    }
    @IBAction func matchClcik(_ sender: Any) {
        
    }
    /*    func scrollToBottom(){
        DispatchQueue.main.async {
            let bottomOffset = CGPoint(x: 0, y: self.scrollV.contentSize.height - self.scrollV.bounds.size.height)
            self.scrollV.setContentOffset(bottomOffset, animated: false)
        }
    }*/
    //MARK:- Webservice
    func connectToGetMessages(){
        if HunterUtility.isConnectedToInternet(){
            
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            var paramsDict = [String: Any]()
            if loginType == "candidate" {
                paramsDict = ["swipe_id": selectedJobId]
            }else{
                paramsDict = ["swipe_id": selectedCandidateId]

            }
            print(paramsDict)
            print(getMessagesURL)
            Alamofire.request(getMessagesURL, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let chatDict = dataDict.value(forKey: "chat") as? NSDictionary{
                                        self.dictRecruiterDetails = HunterChatDescriptionModel()
                                        if let recruiterDict = chatDict.value(forKey: "recruiter_details") as? NSDictionary{
                                            self.dictRecruiterDetails = HunterChatDescriptionModel().initWithDict(dictionary: recruiterDict)
                                            DispatchQueue.main.async {
                                            self.tableChat.reloadData()
                                             
//                                            self.autosizeChatTable()
                                            }
                                        }
                                        if let recruiterDict = chatDict.value(forKey: "candidate_details") as? NSDictionary {
                                            self.tableChat.reloadData()
//                                            self.autosizeChatTable()
                                        }
                                        if let messagesDict = chatDict.value(forKey: "messages") as? [NSDictionary]{
                                            self.arrayChatList = [HunterChatModel]()
                                            for data in messagesDict{
                                                self.arrayChatList.append(HunterChatModel().initWithDict(dictionary: data))
                                            }
                                            DispatchQueue.main.async {
                                                self.tableChat.reloadData()
                                                 
//                                                self.autosizeChatTable()
                                            }
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
    func connectToSendChatMessage(){
        if HunterUtility.isConnectedToInternet(){
            
            print(sendMessageURL)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            var paramsDict = [String: Any]()

             

            if loginType == "candidate" {
                paramsDict = ["swipe_id": selectedJobId,
                              "message": textMessage.text ?? ""]
            }else{
                paramsDict = ["swipe_id": selectedCandidateId,
                              "message": textMessage.text ?? ""]
            }
            
            print(paramsDict)
            
            Alamofire.request(sendMessageURL, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                self.textMessage.text = ""
                                self.connectToGetMessages()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
