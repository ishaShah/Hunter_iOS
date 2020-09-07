//
//  HunterSettingsVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 10/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterSettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var tableSettings: UITableView!
    @IBOutlet weak var heightTableSettings: NSLayoutConstraint!
    @IBOutlet weak var mainViewPopUp: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var viewPopupAccDisabled: UIView!
    @IBOutlet weak var imagePopUpIcon: UIImageView!
    @IBOutlet weak var labelPopUpTitle: UILabel!
    @IBOutlet weak var labelPopUpMessage: UILabel!
    
    var arrayMenuNames = [String]()
    var arrayMenuImages = [String]()
    var dictSettingsData = HunterSettingsModel()
    var isLogout = Bool()
    var notifyStatus = Int()
    var showStatus = Int()
    var accountStatus = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrayMenuNames = ["Basic Infomation", "Privacy", "Notifications", "Help and Support", "Sign Out"]
        arrayMenuImages = ["email-icon-color", "password-icon", "notifications", "support", "logoutnew"]
       
        if UIDevice.current.hasNotch {
            //... consider notch
        } else {
            //... don't have to consider notch
        }
        connectToGetSettingsData()
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()

    }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if sender.tag == 2{
            if notifyStatus == 1{
                connectToChangeNotifyStatus(0)
            }else{
                connectToChangeNotifyStatus(1)
            }
        }else if sender.tag == 3{
            if showStatus == 1{
                connectToChangeShowStatus(0)
            }else{
                connectToChangeShowStatus(1)
            }
        }
    }
    @IBAction func buttonBack(_ sender: UIButton) {
//        mainViewPopUp.isHidden = true
//        viewPopup.isHidden = true
//        viewPopupAccDisabled.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonYesPopUp(_ sender: UIButton) {
        if isLogout {
            print("Logout api")
            mainViewPopUp.isHidden = true
            viewPopup.isHidden = true
            viewPopupAccDisabled.isHidden = true
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "loggedInStat")
            accessToken = String()
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
            let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
            navigationController.viewControllers = [mainRootController]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationController
        }else{
            connectToDisableAccount()
        }
    }
    @IBAction func buttonNoPopUp(_ sender: UIButton) {
        mainViewPopUp.isHidden = true
        viewPopup.isHidden = true
        viewPopupAccDisabled.isHidden = true
    }
    func autosizeTableView(){
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.tableSettings.layoutIfNeeded()
            let height = self.tableSettings.contentSize.height
//            self.heightTableSettings.constant = height
            self.tableSettings.needsUpdateConstraints()
        }
    }
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuNames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterRecSettingsCollectionCell", for: indexPath) as! HunterRecSettingsCollectionCell
        tableView.separatorStyle = .none
        cell.selectionStyle = .none
        cell.imageArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
        cell.switchChange.tag = indexPath.row
        cell.labelTitle.text = arrayMenuNames[indexPath.row]
        cell.imageIcon.image = UIImage(named: arrayMenuImages[indexPath.row])
        if indexPath.row == 2{
            cell.switchChange.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            cell.switchChange.isHidden = false
            cell.imageArrow.isHidden = true
            if indexPath.row == 2{
                if let notifyStatus = dictSettingsData.notification_status{
                    if notifyStatus{
                        cell.switchChange.isOn = true
                        self.notifyStatus = 1
                    }else{
                        cell.switchChange.isOn = false
                        self.notifyStatus = 0
                    }
                }
            }
            //            if indexPath.row == 3{
            //                if let showStatus = dictSettingsData.show_me_on_hunterapp{
            //                    if showStatus{
            //                        cell.switchChange.isOn = true
            //                        self.showStatus = 1
            //                    }else{
            //                        cell.switchChange.isOn = false
            //                        self.showStatus = 0
            //                    }
            //                }
            //            }
        }else{
            cell.switchChange.isHidden = true
            cell.imageArrow.isHidden = false
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterProfileVC") as! HunterProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("privacy information page here")
        case 2:
            print("Turn Notification On/Off here")
        case 3:
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterHelpAndSupportVC") as! HunterHelpAndSupportVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
           
            labelPopUpTitle.text = "Logout"
            isLogout = true
            labelPopUpMessage.text = "Are you sure you would like to Log Out?"
        case 5:
            mainViewPopUp.isHidden = false
            viewPopup.isHidden = false
            viewPopupAccDisabled.isHidden = true
            imagePopUpIcon.image = UIImage(named: "error_new")
            isLogout = false
            if accountStatus == 1{
                labelPopUpTitle.text = "Disable Account"
                labelPopUpMessage.text = "Are you sure you would like to disable your Hunter Account"
            }else{
                labelPopUpTitle.text = "Enable Account"
                labelPopUpMessage.text = "Are you sure you would like to enable your Hunter Account"
            }
        case 6:
            print("default case")
        default:
            print("default case")
        }
    }
    //MARK:- Webservice
    func connectToGetSettingsData(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.settingsURL
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
                            self.dictSettingsData = HunterSettingsModel()
                            if status as! Int == 1{
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                                    self.dictSettingsData = HunterSettingsModel().initWithDict(dictionary: dataDict["settings"] as! NSDictionary)
                                    DispatchQueue.main.async {
                                        self.tableSettings.reloadData()
                                        self.autosizeTableView()
                                    }
                                }
                            } else if status as! Int == 2 {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                                
                                self.mainViewPopUp.isHidden = true
                                self.viewPopup.isHidden = true
                                self.viewPopupAccDisabled.isHidden = true
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
                            else {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
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
    func connectToChangeNotifyStatus(_ change : Int){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.changeNotifyStatusURl
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["notification_status": change]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                self.connectToGetSettingsData()
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
    func connectToChangeShowStatus(_ change : Int){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.changeShowStatusURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["show_me_on_app": change]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                self.connectToGetSettingsData()
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
    func connectToDisableAccount(){
        if HunterUtility.isConnectedToInternet(){
            var url = String()
            if accountStatus == 1{
                url = API.candidateBaseURL + API.disableCandidateAccURL
            }else{
                url = API.candidateBaseURL + API.enableCandidateAccURL
            }
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
                            if status as! Int == 1   {
                                self.mainViewPopUp.isHidden = true
                                self.viewPopup.isHidden = true
                                self.viewPopupAccDisabled.isHidden = true
                                self.connectToGetSettingsData()
                                self.view.makeToast(responseDict.value(forKey: "message") as? String, duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
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
