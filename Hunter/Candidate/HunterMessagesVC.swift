//
//  HunterMessagesVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 11/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Kingfisher

class HunterMessagesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var collectionMatches: UICollectionView!
    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var viewMessageLine: UIView!
    @IBOutlet weak var viewMatchesLine: UIView!
    @IBOutlet weak var imageBgEmpty: UIImageView!
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var viewBgEmpty: UIView!
    @IBOutlet weak var labelMatchesCount: UILabel!
    @IBOutlet weak var labelMessageCount: UILabel!
    @IBOutlet weak var lab_selectedJob: UILabel!
    @IBOutlet weak var img_arrow: UIImageView!
    @IBOutlet weak var topSpace: NSLayoutConstraint!
     

    var arrayChatList = [HunterChatListModel]()
    var arrayMatchesList = [HunterMatchesModel]()
    var baseURL = String()
    var loginType = String()
    var dropDownStatus = false
    var jobList = [String]()
    var jobIDList = [Int]()
    var total_suggestions = [Int]()
    var job_id = 0
    var isDropDownSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageBgEmpty.isHidden = true
        viewBgEmpty.isHidden = true
        imageBg.isHidden = false
        viewMessageLine.isHidden = true
        viewMatchesLine.isHidden = false
        collectionMatches.isHidden = true
        tableMessages.isHidden = true
        labelMatchesCount.isHidden = true
        labelMessageCount.isHidden = true
        tableMessages.tableFooterView = UIView()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = ((UIScreen.main.bounds.width - 60) / 3) //some width
        layout.itemSize = CGSize(width: width, height: 130)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionMatches.collectionViewLayout = layout
        
        if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
            loginType = type
        }
         

    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        imageBgEmpty.isHidden = true
        viewBgEmpty.isHidden = true
        imageBg.isHidden = false
        viewMessageLine.isHidden = true
        viewMatchesLine.isHidden = false
        if loginType == "candidate" {
            baseURL = API.candidateBaseURL
            connectToGetMatches()
        }else{
            baseURL = API.recruiterBaseURL
            self.isDropDownSelected = false
            self.connectToGetRecruiterData()
        }

        setNeedsStatusBarAppearanceUpdate()
            
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    @IBAction func dropDownList(_ sender: Any) {
        if dropDownStatus == false {
            topSpace.constant = 50
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            dropDownStatus = true
        }
        else if dropDownStatus == true {
            self.img_arrow.transform = CGAffineTransform(scaleX: -1, y: 1)
            topSpace.constant = -210
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            dropDownStatus = false
        }
        
    }
    @IBAction func buttonMatches(_ sender: UIButton) {
        imageBgEmpty.isHidden = true
        viewBgEmpty.isHidden = true
        imageBg.isHidden = false
        viewMessageLine.isHidden = true
        viewMatchesLine.isHidden = false
        if loginType == "candidate" {
            connectToGetMatches()
        }else{
            if self.arrayMatchesList.count == 0 {
                self.tableMessages.isHidden = true
                self.collectionMatches.isHidden = true
                self.imageBg.isHidden = true
                self.imageBgEmpty.isHidden = false
                self.viewBgEmpty.isHidden = false
            }else {
                self.tableMessages.isHidden = true
                self.collectionMatches.isHidden = false
                self.collectionMatches.reloadData()
                self.imageBg.isHidden = false
                self.imageBgEmpty.isHidden = true
                self.viewBgEmpty.isHidden = true
            }
        }
    }
    @IBAction func buttonMessages(_ sender: UIButton) {
        imageBgEmpty.isHidden = true
        viewBgEmpty.isHidden = true
        imageBg.isHidden = false
        viewMessageLine.isHidden = false
        viewMatchesLine.isHidden = true
        if loginType == "candidate"{
            connectToGetChats()
        }else{
            connectToGetChats()

            if self.arrayChatList.count == 0 {
                self.collectionMatches.isHidden = true
                self.tableMessages.isHidden = true
                self.imageBg.isHidden = true
                self.imageBgEmpty.isHidden = false
                self.viewBgEmpty.isHidden = false
            }
            else {
                self.collectionMatches.isHidden = true
                self.tableMessages.isHidden = false
                self.tableMessages.reloadData()
                self.imageBg.isHidden = false
                self.imageBgEmpty.isHidden = true
                self.viewBgEmpty.isHidden = true
            }
        }
    }
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMatchesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterMatchesCell", for: indexPath) as! HunterMatchesCell
        if loginType == "candidate" {
            if let name = arrayMatchesList[indexPath.item].company_name{
                cell.labelName.text = name
            }
            
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: cell.viewBG.frame.size)
            gradient.colors = [UIColor.init(red: 220.0/255.0, green: 82.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor, UIColor.init(red: 48.0/255.0, green: 4.0/255.0, blue: 113.0/255.0, alpha: 1).cgColor]

            let shape = CAShapeLayer()
            shape.lineWidth = 2
//            shape.path = UIBezierPath(rect: cell.viewBG.bounds).cgPath
             shape.path = UIBezierPath(roundedRect: (cell.viewBG.bounds), cornerRadius: 40).cgPath

            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            cell.viewBG.layer.addSublayer(gradient)
            
            if let logo = arrayMatchesList[indexPath.item].square_logo{
                cell.imageLogo.contentMode = .scaleToFill
                let url = URL(string: logo)
                cell.imageLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
        }else{
            if let name = arrayMatchesList[indexPath.item].candidate_name{
                cell.labelName.text = name
            }
            
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: cell.viewBG.frame.size)
            gradient.colors = [UIColor.init(red: 220.0/255.0, green: 82.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor, UIColor.init(red: 48.0/255.0, green: 4.0/255.0, blue: 113.0/255.0, alpha: 1).cgColor]
            
            let shape = CAShapeLayer()
            shape.lineWidth = 2
            //            shape.path = UIBezierPath(rect: cell.viewBG.bounds).cgPath
            shape.path = UIBezierPath(roundedRect: (cell.viewBG.bounds), cornerRadius: 40).cgPath
            
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            cell.viewBG.layer.addSublayer(gradient)
            
            if let logo = arrayMatchesList[indexPath.item].profile_img{
                cell.imageLogo.contentMode = .scaleToFill
                let url = URL(string: logo)
                cell.imageLogo.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
             let vc = UIStoryboard.init(name: "Jobs", bundle: nil).instantiateViewController(withIdentifier: "HunterChatVC") as! HunterChatVC
            if loginType == "candidate" {
                if let jobId = arrayMatchesList[indexPath.row].swipe_id{
                    vc.selectedJobId = jobId
                }
                if let title = arrayMatchesList[indexPath.row].job_title{
                    vc.selectedChatName = title
                }
            }else{
                vc.selectedJobId = job_id
                if let candidateId = arrayMatchesList[indexPath.row].swipe_id{
                    vc.selectedCandidateId = String(candidateId)
                }
                if let title = arrayMatchesList[indexPath.row].candidate_name{
                    vc.selectedChatName = title
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableMessages{
            return arrayChatList.count
        }else{
            return jobList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableMessages{
            return UITableView.automaticDimension
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableMessages{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HunterMessagesCell", for: indexPath) as! HunterMessagesCell
            cell.selectionStyle = .none
            if let chatName = arrayChatList[indexPath.row].candidate_name{
                cell.labelChatName.text = chatName
            }
            if let lastMessage = arrayChatList[indexPath.row].latest_message{
                cell.labelChatMessage.text = lastMessage
            }
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: cell.imageChat.frame.size)
            gradient.colors = [UIColor.init(red: 220.0/255.0, green: 82.0/255.0, blue: 245.0/255.0, alpha: 1).cgColor, UIColor.init(red: 48.0/255.0, green: 4.0/255.0, blue: 113.0/255.0, alpha: 1).cgColor]
            
            let shape = CAShapeLayer()
            shape.lineWidth = 2
            //            shape.path = UIBezierPath(rect: cell.viewBG.bounds).cgPath
            shape.path = UIBezierPath(roundedRect: (cell.imageChat.bounds), cornerRadius: 40).cgPath
            
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            cell.imageChat.layer.addSublayer(gradient)
            
            if loginType == "candidate" {
            if let logo = arrayChatList[indexPath.row].logo{
                cell.imageChat.contentMode = .scaleToFill
                let url = URL(string: logo)
                cell.imageChat.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
            }
            else {
            if let logo = arrayChatList[indexPath.row].profile_img{
                cell.imageChat.contentMode = .scaleToFill
                let url = URL(string: logo)
                cell.imageChat.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HunterJobListTableViewCell", for: indexPath) as! HunterJobListTableViewCell
            cell.selectionStyle = .none
            
            cell.labelTitle.text = jobList[indexPath.row]
//            cell.labelSubTitle.text = "\(total_suggestions[indexPath.row]) MATCHES"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             let vc = UIStoryboard.init(name: "Jobs", bundle: nil).instantiateViewController(withIdentifier: "HunterChatVC") as! HunterChatVC
            if loginType == "candidate" {
                if let jobId = arrayChatList[indexPath.row].job_id{
                    vc.selectedJobId = jobId
                }
                if let title = arrayChatList[indexPath.row].title{
                    vc.selectedChatName = title
                }
            }else{
                vc.selectedJobId = job_id
                if let candidateId = arrayChatList[indexPath.row].candidate_id{
                    vc.selectedCandidateId = String(candidateId)
                }
                if let title = arrayChatList[indexPath.row].candidate_name{
                    vc.selectedChatName = title
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK:- Webservice
    func connectToGetChats(){
         arrayChatList = []

        if HunterUtility.isConnectedToInternet(){
            
            let url = baseURL + API.getChatCandidateMessagesURL
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
                                self.arrayChatList = [HunterChatListModel]()
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let chatDict = dataDict.value(forKey: "messages") as? [NSDictionary]{
                                        for data in chatDict{
                                            self.arrayChatList.append(HunterChatListModel().initWithDict(dictionary: data))
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        if dataDict.count != 0{
                                            if self.arrayChatList.count == 0 {
                                                self.collectionMatches.isHidden = true
                                                self.tableMessages.isHidden = true
                                                self.imageBg.isHidden = true
                                                self.imageBgEmpty.isHidden = false
                                                self.viewBgEmpty.isHidden = false
                                            }else {
                                                self.collectionMatches.isHidden = true
                                                self.tableMessages.isHidden = false
                                                self.tableMessages.reloadData()
                                                self.imageBg.isHidden = false
                                                self.imageBgEmpty.isHidden = true
                                                self.viewBgEmpty.isHidden = true
                                            }
                                        }else{
                                            self.collectionMatches.isHidden = true
                                            self.tableMessages.isHidden = true
                                            self.imageBg.isHidden = true
                                            self.imageBgEmpty.isHidden = false
                                            self.viewBgEmpty.isHidden = false
                                        }
                                    }
                                }else{
                                    DispatchQueue.main.async {
                                        self.imageBg.isHidden = true
                                        self.imageBgEmpty.isHidden = false
                                        self.viewBgEmpty.isHidden = false
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
    func connectToGetRecruiterData(){
        
         arrayChatList = []

        if HunterUtility.isConnectedToInternet(){
            
            let url = baseURL + API.getMatchesURL
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
                            if status as! Int == 1{
                                self.arrayMatchesList = [HunterMatchesModel]()
                                self.arrayChatList = [HunterChatListModel]()
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let dropDownData = dataDict.value(forKey: "jobs_list") as? [NSDictionary]{
                                         self.jobList = [String]()
                                         self.jobIDList = [Int]()
                                        
                                        for dic in dropDownData {
                                            self.jobList.append(dic["title"] as! String)
                                            self.jobIDList.append(dic["id"] as! Int)
                                            
                                            if !self.isDropDownSelected{
                                                self.lab_selectedJob.text = self.jobList[0]
                                                self.job_id = self.jobIDList[0]
                                            }
                                         }
                                        
                                        
                                         
                                        
                                        
                                    }
                                    if let chatDict = dataDict.value(forKey: "chat_room") as? [NSDictionary]{
                                        for data in chatDict{
                                            self.arrayChatList.append(HunterChatListModel().initWithDict(dictionary: data))
                                        }
                                    }
                                    if let matchesDict = dataDict.value(forKey: "matched") as? [NSDictionary]{
                                        for data in matchesDict{
                                            self.arrayMatchesList.append(HunterMatchesModel().initWithDict(dictionary: data))
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        if dataDict.count != 0{
                                            self.imageBgEmpty.isHidden = true
                                            self.viewBgEmpty.isHidden = true
                                            self.imageBg.isHidden = false
                                            self.viewMessageLine.isHidden = true
                                            self.viewMatchesLine.isHidden = false
                                            if self.arrayMatchesList.count == 0 {
                                                self.tableMessages.isHidden = true
                                                self.collectionMatches.isHidden = true
                                                self.imageBg.isHidden = true
                                                self.imageBgEmpty.isHidden = false
                                                self.viewBgEmpty.isHidden = false
                                            }else {
                                                self.tableMessages.isHidden = true
                                                self.collectionMatches.isHidden = false
                                                self.collectionMatches.reloadData()
                                                self.imageBg.isHidden = false
                                                self.imageBgEmpty.isHidden = true
                                                self.viewBgEmpty.isHidden = true
                                            }
                                        }else{
                                            self.imageBgEmpty.isHidden = true
                                            self.viewBgEmpty.isHidden = true
                                            self.imageBg.isHidden = false
                                            self.viewMessageLine.isHidden = true
                                            self.viewMatchesLine.isHidden = false
                                            
                                            self.collectionMatches.isHidden = true
                                            self.tableMessages.isHidden = true
                                            self.imageBg.isHidden = true
                                            self.imageBgEmpty.isHidden = false
                                            self.viewBgEmpty.isHidden = false
                                        }
                                    }
                                }else{
                                    DispatchQueue.main.async {
                                        self.imageBg.isHidden = true
                                        self.imageBgEmpty.isHidden = false
                                        self.viewBgEmpty.isHidden = false
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
    func connectToGetMatches(){

         arrayMatchesList = []

        if HunterUtility.isConnectedToInternet(){
            
            let url = baseURL + API.getMatchesURL
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
                            if status as! Int == 1{
                                self.arrayMatchesList = [HunterMatchesModel]()
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                                    var selectedKey = String()
                                    if self.loginType == "candidate" {
                                        selectedKey = "matched"
                                    }else{
                                        selectedKey = "matched_candidates"
                                    }
                                    if let matchesDict = dataDict.value(forKey: selectedKey) as? [NSDictionary]{
                                        for data in matchesDict{
                                            self.arrayMatchesList.append(HunterMatchesModel().initWithDict(dictionary: data))
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        if dataDict.count != 0{
                                            if self.arrayMatchesList.count == 0 {
                                                self.tableMessages.isHidden = true
                                                self.collectionMatches.isHidden = true
                                                self.imageBg.isHidden = true
                                                self.imageBgEmpty.isHidden = false
                                                self.viewBgEmpty.isHidden = false
                                            }else {
                                                self.tableMessages.isHidden = true
                                                self.collectionMatches.isHidden = false
                                                self.collectionMatches.reloadData()
                                                self.imageBg.isHidden = false
                                                self.imageBgEmpty.isHidden = true
                                                self.viewBgEmpty.isHidden = true
                                            }
                                        }else{
                                            self.tableMessages.isHidden = true
                                            self.collectionMatches.isHidden = true
                                            self.imageBg.isHidden = true
                                            self.imageBgEmpty.isHidden = false
                                            self.viewBgEmpty.isHidden = false
                                        }
                                    }
                                }else{
                                    DispatchQueue.main.async {
                                        self.imageBg.isHidden = true
                                        self.imageBgEmpty.isHidden = false
                                        self.viewBgEmpty.isHidden = false
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

    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
    }*/


}
