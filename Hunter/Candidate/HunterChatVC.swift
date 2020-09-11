
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
extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
class HunterChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var tableChat: UITableView!
    @IBOutlet weak var heightTableChat: NSLayoutConstraint!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var labelDesignation: UILabel!
    @IBOutlet weak var labelMatchedOn: UILabel!
    @IBOutlet weak var textMessage: UITextField!
    @IBOutlet weak var scrollV: UIScrollView!
    var arrayChatList = [HunterChatModel]()
    var dictRecruiterDetails = HunterChatDescriptionModel()
    var selectedJobId = Int()
    var selectedCandidateId = String()
    var selectedChatName = String()
    var loginType = String()
    var getMessagesURL = String()
    var sendMessageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = selectedChatName
        print(selectedChatName)
        tableChat.tableFooterView = UIView()
        
        scrollV.scrollToBottom(animated: true)

        sendView.round(corners: [.bottomLeft, .bottomRight], radius: 30)

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
            sendMessageURL = API.recruiterBaseURL + API.sendCandidateMessageURL
        }
        connectToGetMessages()
    }
    // Apply round corner and border. An extension method of UIView.
    
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
    func autosizeChatTable(){
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.tableChat.layoutIfNeeded()
            let height = self.tableChat.contentSize.height
            print(height)
            self.heightTableChat.constant = height
            self.tableChat.needsUpdateConstraints()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.black

        setNeedsStatusBarAppearanceUpdate()
            
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    //MARK:- Tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayChatList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let postedBy = arrayChatList[indexPath.row].posted_by{
            if postedBy == "candidate"{
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterSenderCell", for: indexPath) as! HunterChatCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                cell.viewChatCV.layer.cornerRadius = 5.0
                cell.viewChatCV.layer.masksToBounds = true
                
                if let message = arrayChatList[indexPath.row].message{
                    cell.textChat.text = message
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterReceiverCell", for: indexPath) as! HunterChatCell
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                
                cell.viewChatCV.layer.cornerRadius = 5.0
                cell.viewChatCV.layer.masksToBounds = true
                if let postedBy = arrayChatList[indexPath.row].posted_by{
                    if postedBy == "recruiter"{
                        if let message = arrayChatList[indexPath.row].message{
                            cell.textChat.text = message
                        }
                    }
                }
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HunterReceiverCell", for: indexPath) as! HunterChatCell
            return cell
        }
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
                paramsDict = ["job_id": selectedJobId]
            }else{
                paramsDict = ["job_id": selectedJobId,
                              "candidate_id": selectedCandidateId]
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
                                        if let recruiterDict = chatDict.value(forKey: "recuiter_details") as? NSDictionary{
                                            self.dictRecruiterDetails = HunterChatDescriptionModel().initWithDict(dictionary: recruiterDict)
                                            DispatchQueue.main.async {
                                                if let logo = self.dictRecruiterDetails.square_logo{
                                                    self.imageLogo.contentMode = .scaleToFill
                                                    let imageURL = URL(string: logo)
                                                    self.imageLogo.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
                                                }
                                                if let recruiterName = self.dictRecruiterDetails.company_name{
                                                    self.labelName.text = recruiterName
                                                }
                                                if let designation = self.dictRecruiterDetails.job_title{
                                                    self.labelDesignation.text = designation
                                                }
                                                if let matchedOn = self.dictRecruiterDetails.matched_message{
                                                    self.labelMatchedOn.text = matchedOn
                                                }
                                            }
                                        }
                                        if let recruiterDict = chatDict.value(forKey: "candidate_details") as? NSDictionary{
                                            self.dictRecruiterDetails = HunterChatDescriptionModel().initWithDict(dictionary: recruiterDict)
                                            DispatchQueue.main.async {
                                                if let logo = self.dictRecruiterDetails.profile_img{
                                                    self.imageLogo.contentMode = .scaleToFill
                                                    let imageURL = URL(string: logo)
                                                    self.imageLogo.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
                                                }
                                                if let name = self.dictRecruiterDetails.candidate_name{
                                                    self.labelName.text = name
                                                }
                                                if let matchedOn = self.dictRecruiterDetails.matched_message{
                                                    self.labelMatchedOn.text = matchedOn
                                                }
                                            }
                                        }
                                        if let messagesDict = chatDict.value(forKey: "messages") as? [NSDictionary]{
                                            self.arrayChatList = [HunterChatModel]()
                                            for data in messagesDict{
                                                self.arrayChatList.append(HunterChatModel().initWithDict(dictionary: data))
                                            }
                                            DispatchQueue.main.async {
                                                self.tableChat.reloadData()
                                                self.scrollV.scrollToBottom(animated: true)
                                                self.autosizeChatTable()
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
                paramsDict = ["job_id": selectedJobId,
                              "type": "0",
                              "message": textMessage.text ?? ""]
            }else{
                paramsDict = ["job_id": selectedJobId,
                              "candidate_id": selectedCandidateId,
                              "type": "0",
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
