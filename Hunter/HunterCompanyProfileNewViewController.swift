//
//  HunterCompanyProfileNewViewController.swift
//  Hunter
//
//  Created by Shamzi on 09/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Player

protocol refreshProfileDelegate {
    func refetchFromCloud()
}

class HunterCompanyProfileNewViewController: UIViewController ,hunterDelegate,refreshProfileDelegate {
    
    

    @IBOutlet weak var btn_editCover: UIButton!
    
    @IBOutlet weak var btn_editProPic: UIButton!
    @IBOutlet weak var viewWhiteProOverLap: UIView!
    @IBOutlet weak var viewWhiteBannOverLap: UIView!
    @IBOutlet weak var img_bannerImg: UIImageView!
    
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
    if isFrom == "businessType" {
        print(selectedDict["name"] as! String)
        self.lblBusinessType.text = (selectedDict["name"] as! String)
        selectedBusinessTypeID = selectedDict["id"] as! String
        connectToUpdateBusTypeAndCompanySize(type: isFrom)
    }
    else {
        print(selectedDict["name"] as! String)
        self.lblCompanySize.text = (selectedDict["name"] as! String)
        selectedCompanySizeID = selectedDict["id"] as! String
        connectToUpdateBusTypeAndCompanySize(type: isFrom)

    }
}
    @IBAction func btn_editPro(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditProPicVC") as! HunterEditProPicVC
        vc.modalPresentationStyle = .overFullScreen
        vc.profileDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var view_video: UIView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewImageOutter: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblIndustry: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblFounded: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var txtViewAbout: UITextView!
    
    @IBOutlet weak var lblCompanySize: UILabel!
    @IBOutlet weak var lblBusinessType: UILabel!
    
    @IBOutlet weak var cTxtViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collImages: UICollectionView!
    
    @IBOutlet weak var editView: UIView!

    @IBOutlet weak var edit_basic: UIView!
    @IBOutlet weak var edit_abt: UIView!
    @IBOutlet weak var edit_companyS: UIView!
    @IBOutlet weak var edit_ImageV: UIView!
    @IBOutlet weak var edit_businessT: UIView!
    var isEdit = false
    var isFrom = String()
    var candidate_Id = 0
    var arrayImages = [String]()
    var arrayVideos = [String]()


    var selectedBusinessTypeID = String()
    var selectedCompanySizeID = String()
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_threeLines: UIButton!
    fileprivate var player = Player()

 

    override func viewDidLoad() {
        super.viewDidLoad()

        if isFrom == "cards"{
            btn_back.isHidden = false
            btn_threeLines.isHidden = true
        }
        else {
            btn_back.isHidden = true
            btn_threeLines.isHidden = false


        }
        editView.isHidden = true;

        collImages.delegate = nil
        collImages.dataSource = nil
        applyUIChanges()
        
 
        edit_abt.isHidden = !isEdit
        edit_companyS.isHidden = !isEdit
        edit_basic.isHidden = !isEdit
        edit_businessT.isHidden = !isEdit
        edit_ImageV.isHidden = !isEdit
        btn_editCover.isHidden = !isEdit
        btn_editProPic.isHidden = !isEdit
        viewWhiteProOverLap.isHidden = !isEdit
        viewWhiteBannOverLap.isHidden = !isEdit
        
        self.player = Player()
        self.player.playerDelegate = self
        self.player.playbackDelegate = self
        self.player.view.frame = self.view_video.bounds
        
        self.addChild(self.player)
        self.view_video.addSubview(self.player.view)
     //   self.player.didMove(toParent: self)
        
        
        collImages.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        connectToGetProfileData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetProfileData(notification:)), name: NSNotification.Name(rawValue: "candidate_Id"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func applyUIChanges(){
        
        
        imgProfile.applyshadowWithCorner(containerView: viewImageOutter, cornerRadious: 72)
        
        txtViewAbout.text = ""
        viewContent.layer.masksToBounds =  true
        viewContent.layer.cornerRadius = 10
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewContent.clipsToBounds = true
        
        
   
    }
    @objc  func GetProfileData(notification: NSNotification) {
        if let candidate_Id = notification.userInfo?["candidate_Id"] as? Int {
            // do something with your image
            self.candidate_Id = candidate_Id
            isFrom = "cards"
            connectToGetProfileData()
        }
        
    }
    func refetchFromCloud() {
        connectToGetProfileData()
    }
    @IBAction func uploadProPic(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditCoverImVC") as! HunterEditCoverImVC
        vc.profileDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var view_viewHt: NSLayoutConstraint!
    var profileDict = NSDictionary()
    func connectToGetProfileData(){
        
        if isFrom == "cards" {
            if HunterUtility.isConnectedToInternet(){
                
                let url = API.candidateBaseURL + API.recruiterViewURL
                
                print(url)
                HunterUtility.showProgressBar()
                
                let headers    = [ "Authorization" : "Bearer " + accessToken]
                let params = ["recruiter_id" : candidate_Id]
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
                                            self.profileDict = profile
                                            self.lblCompanyName.text = "\(profile["company_name"] as! String)".uppercased()
                                            self.lblIndustry.text = "\(profile["industry"] as! String)"
                                            self.lblLocation.text  = "\(profile["location"] as! String)"
                                            self.lblFounded.text = "\(profile["founded_on"] as! String)"
                                            self.lblWebsite.text = "\(profile["website"] as! String)"
                                            self.txtViewAbout.text = "\(profile["about"] as! String)"
                                            self.txtViewAbout.sizeToFit()
                                            DispatchQueue.main.async {
                                                self.cTxtViewHeight.constant = self.txtViewAbout.contentSize.height
                                            }
                                            self.lblCompanySize.text = "\(profile["company_size"] as! String)"
                                            self.lblBusinessType.text = "\(profile["business_type"] as! String)"
                                            if let url = profile["square_logo"] as? String{
                                                self.imgProfile.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                            }
                                            if let url = profile["rectangle_logo"] as? String{
                                                self.img_bannerImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                            }
                                            
                                            self.arrayImages = profile["additional_images"] as! [String]
                                            self.arrayVideos = profile["additional_videos"] as! [String]
                                            self.collImages.delegate = self
                                            self.collImages.dataSource = self
                                            if self.arrayVideos.count != 0 {
                                            self.player.url = URL(string:self.arrayVideos[0])
//                                            self.player.playFromBeginning()
                                                
//                                                self.player.fillMode = .resizeAspectFill

 
                                                let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureRecognizer(_:)))
                                            tapGestureRecognizer.numberOfTapsRequired = 1
                                            self.player.view.addGestureRecognizer(tapGestureRecognizer)
                                            }
                                            else {
                                                self.view_viewHt.constant = 0.0
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
                
                let url = API.recruiterBaseURL + API.profileURL
                
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
                                            self.profileDict = profile
                                            self.lblCompanyName.text = "\(profile["company_name"] as! String)".uppercased()
                                            self.lblIndustry.text = "\(profile["industry"] as! String)"
                                            self.lblLocation.text  = "\(profile["location"] as! String)"
                                            self.lblFounded.text = "\(profile["founded_on"] as! String)"
                                            self.lblWebsite.text = "\(profile["website"] as! String)"
                                            self.txtViewAbout.text = "\(profile["about"] as! String)"
                                            self.txtViewAbout.sizeToFit()
                                            self.cTxtViewHeight.constant = self.txtViewAbout.contentSize.height
                                            
                                            self.txtViewAbout.layoutIfNeeded()
                                            self.lblCompanySize.text = "\(profile["company_size"] as! String)"
                                            self.lblBusinessType.text = "\(profile["business_type"] as! String)"
                                            if let url = profile["square_logo"] as? String{
                                                self.imgProfile.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                            }
                                            if let url = profile["rectangle_logo"] as? String{
                                                self.img_bannerImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                            }
                                            self.arrayImages = profile["additional_images"] as! [String]
                                            self.arrayVideos = profile["additional_videos"] as! [String]

                                            self.collImages.delegate = self
                                            self.collImages.dataSource = self
                                            
                                            if self.arrayVideos.count != 0 {
                                                self.player.url = URL(string:self.arrayVideos[0] )
                                                self.player.playFromBeginning()
//                                                self.player.fillMode = .res
    
                                                let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGestureRecognizer(_:)))
                                               tapGestureRecognizer.numberOfTapsRequired = 1
                                               self.player.view.addGestureRecognizer(tapGestureRecognizer)
                                           }
                                            else {
                                                self.view_viewHt.constant = 0.0
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
    func connectToUpdateBusTypeAndCompanySize(type : String){
        if HunterUtility.isConnectedToInternet(){
            var url = ""
            var paramsDict = [String : Any]()
            if type == "businessType" {
                url = API.recruiterBaseURL + API.updateCompanyBusinessTypeURL
                paramsDict = ["business_type" : Int(selectedBusinessTypeID)!] as   [String : Any]

                //business_type
            }
            else {
                url = API.recruiterBaseURL + API.updateCompanySizeURL
                paramsDict = ["company_size_id": Int(selectedCompanySizeID)!] as   [String : Any]

                //company_size_id
            }
            
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                
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
    
    @IBAction func threeLine(_ sender: Any) {
        editView.isHidden = false;
    }
    
    @IBAction func closeEditView(_ sender: Any) {
        editView.isHidden = true;
        isEdit = false
        edit_abt.isHidden = true
        edit_companyS.isHidden = true
        edit_basic.isHidden = true
        edit_businessT.isHidden = true
        edit_ImageV.isHidden = true
        btn_editCover.isHidden = true
        btn_editProPic.isHidden = true
        viewWhiteProOverLap.isHidden = true
        viewWhiteBannOverLap.isHidden = true
    }
    
    @IBAction func editClick(_ sender: Any) {
        if isEdit == false {
            isEdit = true
            
        }
        else {
            isEdit = false
        }
        
        edit_abt.isHidden = !isEdit
        edit_companyS.isHidden = !isEdit
        edit_basic.isHidden = !isEdit
        edit_businessT.isHidden = !isEdit
        edit_ImageV.isHidden = !isEdit
        btn_editCover.isHidden = !isEdit
        btn_editProPic.isHidden = !isEdit
        viewWhiteProOverLap.isHidden = !isEdit
        viewWhiteBannOverLap.isHidden = !isEdit
    }
    @IBAction func edit_individual(_ sender: UIButton) {
        if sender.tag == 1 {
            // basic
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompVC") as! HunterRegisterCompVC
            vc.isEdit = true
            vc.modalPresentationStyle = .overFullScreen
            vc.profileDict = self.profileDict
            vc.profileDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
        else if sender.tag == 2 {
            // about
            let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditBioVC") as! HunterEditBioVC
            vc.modalPresentationStyle = .overFullScreen
            vc.txt = txtViewAbout.text!
            vc.profileDelegate = self
            self.present(vc, animated: true, completion: nil)
            
        }
        else if sender.tag == 3 {
            // company size
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
            vc.isFrom = "companySize"
            vc.delegate = self
            
            var anyDict = [String: String?]()

                   for (key, value) in profileDict["company_size_data"] as! NSDictionary {
                       anyDict[key as! String] = value as! String
                   }
                    
                    
                   
                    let sortedYourArray = anyDict.sorted( by: { $0.0 < $1.0 })
                    print(sortedYourArray)
                   
                   var jsonError : NSError?
                   let jsonData = try? JSONSerialization.data(withJSONObject: anyDict, options: .prettyPrinted)
                   // Verifying it worked:
                 let  company_size_data = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSDictionary
            
            
            
            
            
            vc.passedDict = company_size_data
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)

        }
        else if sender.tag == 4 {
            // business type
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
            vc.isFrom = "businessType"
            vc.delegate = self
            
            
            var anyDict = [String: String?]()

              for (key, value) in profileDict["business_type_data"] as! NSDictionary {
                  anyDict[key as! String] = value as! String
              }
               
               
              
               let sortedYourArray = anyDict.sorted( by: { $0.0 < $1.0 })
               print(sortedYourArray)
              
              var jsonError : NSError?
              let jsonData = try? JSONSerialization.data(withJSONObject: anyDict, options: .prettyPrinted)
              // Verifying it worked:
            let  business_type_data = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSDictionary
            
            
            vc.passedDict = business_type_data
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)

        }
        else if sender.tag == 5 {
            // additional image/video
            let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterImagesVC") as! HunterImagesVC
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            

        }
    }
    @IBAction func settingsClick(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterRecSettingsVC") as! HunterRecSettingsVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        

    }
}

extension HunterCompanyProfileNewViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
        
        if let url = arrayImages[indexPath.row] as? String{
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
        }
        cell.contentView.addSubview(imageView)
        return cell
  
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 180, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HunterCompanyProfileNewViewController {
    
    @objc func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
        switch self.player.playbackState {
        case .stopped:
            self.player.playFromBeginning()
            break
        case .paused:
            self.player.playFromCurrentTime()
            break
        case .playing:
            self.player.pause()
            break
        case .failed:
            self.player.pause()
            break
        }
    }
    
}

// MARK: - PlayerDelegate

extension HunterCompanyProfileNewViewController: PlayerDelegate {
    
    func playerReady(_ player: Player) {
        print("\(#function) ready")
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        print("\(#function) \(player.playbackState.description)")
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        print("\(#function) error.description")
    }
    
}

// MARK: - PlayerPlaybackDelegate

extension HunterCompanyProfileNewViewController: PlayerPlaybackDelegate {
    
    func playerCurrentTimeDidChange(_ player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
    }

    func playerPlaybackDidLoop(_ player: Player) {
    }
}
