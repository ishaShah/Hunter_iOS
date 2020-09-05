//
//  HunterPostAJobVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 22/09/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import SVProgressHUD
import AlignedCollectionViewFlowLayout

class HunterPostAJobVC: UIViewController , UITextViewDelegate {
    @IBOutlet weak var coll_jobType: UICollectionView!
    @IBOutlet weak var coll_loc: UICollectionView!
    @IBOutlet weak var constraintHeightCollectionJobType: NSLayoutConstraint!
    
    @IBOutlet weak var txt_desc: UITextView!
    @IBOutlet weak var txt_exp: DropDown!
    
    var isFromDash = false
    var arr_exp = ["0-1 years", "1-3 years", "3-6 years", "6-10 years", "10-15 years", "15-20 years", "20-30 years", "30+ years"]

    @IBOutlet weak var txt_jobTitle: UITextField!
    @IBOutlet weak var txt_jobType: DropDown!
    @IBOutlet weak var txt_salary: UITextField!
    
    @IBOutlet weak var txt_loc: DropDown!
    
    
    
    var arr_jobType = [String]()
    var arr_jobTypeID = [Int]()
    var selectedjobType = String()
    var selectedjobTypeID = Int()
    
    var arr_loc = [String]()
    var arr_locID = [Int]()
    var selectedLoc = String()
    var selectedLocID = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        connectToRegisterJobType()
        connectToRegisterLoc()
        
/*        let alignedFlowLayout1 = coll_jobType?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout1?.minimumLineSpacing = 5.0
        alignedFlowLayout1?.minimumInteritemSpacing = 5.0
        alignedFlowLayout1?.horizontalAlignment = .justified
        alignedFlowLayout1?.verticalAlignment = .center
        
        let alignedFlowLayout2 = coll_loc?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout2?.minimumLineSpacing = 5.0
        alignedFlowLayout2?.minimumInteritemSpacing = 5.0
        alignedFlowLayout2?.horizontalAlignment = .justified
        alignedFlowLayout2?.verticalAlignment = .center*/
        
        coll_jobType.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
        coll_loc.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
        
        self.txt_desc.delegate = self
        txt_desc.text = "Description..."
        txt_desc.textColor = UIColor.officialApplePlaceholderGray

        
        self.txt_exp.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
        self.txt_exp.selectedRowColor = UIColor.init(hexString: "E8E4F2")
        self.txt_exp.textColor = UIColor.init(hexString: "531B93")
        self.txt_exp.checkMarkEnabled = false
        self.txt_exp.rowHeight = 40.0
        self.txt_exp.isSearchEnable = false
        // The list of array to display. Can be changed dynamically
        self.txt_exp.optionArray = self.arr_exp
        //Its Id Values and its optional
        
        // Image Array its optional
        // The the Closure returns Selected Index and String
        self.txt_exp.didSelect{(selectedText , index ,id) in
            self.txt_exp.text = "\(selectedText)"
             
             
        }
        
    }
    @IBAction func buttonRemoveFromJobType(_ sender: UIButton) {
        self.txt_jobType.text = ""
        self.selectedjobType = String()
        self.selectedjobTypeID = Int()
        self.coll_jobType.reloadData()
    }
    @IBAction func buttonRemoveFromLocation(_ sender: UIButton) {
        self.txt_loc.text = ""
        self.selectedLoc = String()
        self.selectedLocID = Int()
        self.coll_loc.reloadData()
    }
    //MARK:- Textview delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description..."{
            textView.text = ""
            textView.textColor = Color.darkVioletColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Description..."
            textView.textColor = UIColor.officialApplePlaceholderGray
        }
    }
    //MARK:- Webservice
    func connectToRegisterJobType(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.getTypesURL
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
                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
                                print (data)
                                
                                for locData in data {
                                    print (locData)
                                    self.arr_jobType.append(locData.value(forKey: "job_type") as! String)
                                    self.arr_jobTypeID.append(locData.value(forKey: "id") as! Int)
                                }
                                self.txt_jobType.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
                                self.txt_jobType.selectedRowColor = UIColor.init(hexString: "E8E4F2")
                                self.txt_jobType.textColor = UIColor.init(hexString: "531B93")
                                self.txt_jobType.checkMarkEnabled = false
                                self.txt_jobType.rowHeight = 40.0
                                self.txt_jobType.isSearchEnable = false
                                // The list of array to display. Can be changed dynamically
                                self.txt_jobType.optionArray = self.arr_jobType
                                //Its Id Values and its optional
                                
                                // Image Array its optional
                                // The the Closure returns Selected Index and String
                                self.txt_jobType.didSelect{(selectedText , index ,id) in
                                    self.txt_jobType.text = "\(selectedText)"
                                    self.selectedjobType = self.arr_jobType[index]
                                    self.selectedjobTypeID = self.arr_jobTypeID[index]
                                    DispatchQueue.main.async {
                                        self.coll_jobType.reloadData()
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
                            }else{
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
    func connectToRegisterLoc(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.getPrefLocURL
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
                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
                                print (data)
                                for locData in data {
                                    
                                    print (locData)
                                    self.arr_loc.append(locData.value(forKey: "location") as! String)
                                    self.arr_locID.append(locData.value(forKey: "id") as! Int)
                                    
                                }
                                self.txt_loc.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
                                self.txt_loc.selectedRowColor = UIColor.init(hexString: "E8E4F2")
                                self.txt_loc.textColor = UIColor.init(hexString: "531B93")
                                self.txt_loc.checkMarkEnabled = false
                                self.txt_loc.rowHeight = 40.0
                                
                                // The list of array to display. Can be changed dynamically
                                self.txt_loc.optionArray = self.arr_loc
                                //Its Id Values and its optional
                                //                                self.typeDropDown.optionIds = self.arr_typeID
                                
                                // Image Array its optional
                                // The the Closure returns Selected Index and String
                                self.txt_loc.didSelect{(selectedText , index ,id) in
                                    self.txt_loc.text = "\(selectedText)"
                                    self.selectedLoc = self.arr_loc[index]
                                    self.selectedLocID = self.arr_locID[index]
                                    DispatchQueue.main.async {
                                        self.coll_loc.reloadData()
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
                            }else{
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
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueBtn(_ sender: Any) {
        if txt_jobTitle.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter Job Title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txt_salary.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter salary.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txt_exp.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter experience.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if selectedjobType.count == 0{
            let alert = UIAlertController(title: "", message:
                "Please select atleast one job type", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if selectedLoc == ""{
            let alert = UIAlertController(title: "", message:
                "Please choose a location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            connectToRegisterVerifyCompanyURL()
        }
    }
    func connectToRegisterVerifyCompanyURL(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.recruiterBaseURL + API.getPostJobURL
            print(url)
            HunterUtility.showProgressBar()
//            title
//            job_type_id
//            location_id
//            description
//            salary
//            experience
            let paramsDict = ["job_type_id": selectedjobTypeID , "location_id" : selectedLocID, "salary" : txt_salary.text!, "description":txt_desc.text! , "experience": txt_exp.text!, "title":txt_jobTitle.text! ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                if self.isFromDash == true {
                                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pushToTabBar), userInfo: nil, repeats: false)
                                }
                                else {
                                    self.navigationController?.popViewController(animated: true)
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
                            }else{
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }else{
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
}
    extension HunterPostAJobVC : UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == coll_jobType {
                if self.selectedjobType != ""{
                    return 1
                }else{
                    return 0
                }
                /*if self.selectedjobType.count == 0 {
                    return self.arr_jobType.count
                }else {
                    return self.selectedjobType.count
                }*/
            }else if collectionView == coll_loc {
                /*if self.selectedLoc == "" {
                    return self.arr_loc.count
                }else {
                    return self.selectedLoc.count
                }*/
                if self.selectedLoc != ""{
                    return 1
                }else{
                    return 0
                }
            }else {
                return 0
            }
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterPostAJobCollectionCell", for: indexPath) as! HunterPostAJobCollectionCell
            if collectionView == coll_jobType {
                cell.titleLabel.text = selectedjobType.uppercased()
                cell.buttonRemove.isHidden = false
                cell.buttonRemove.tag = indexPath.item
                
                cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                cell.titleLabel.textColor = UIColor.white
                
                cell.userImageView.image = UIImage.init(named: "close-icon-white")
                
/*                if self.selectedjobType.count == 0 {
                    cell.titleLabel.text = arr_jobType[indexPath.row].uppercased()
                    cell.titleLabel.textColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    cell.backgroundColor = UIColor.init(red: 232.0/255.0, green: 228.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                }else {
                    cell.titleLabel.text = selectedjobType[indexPath.row].uppercased()
                    cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    cell.titleLabel.textColor = UIColor.white
                    
                    cell.userImageView.image = UIImage.init(named: "close-icon-white")
                }*/
            }else if collectionView == coll_loc {
                cell.titleLabel.text = selectedLoc.uppercased()
                cell.buttonRemove.isHidden = false
                cell.buttonRemove.tag = indexPath.item
                
                cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                cell.titleLabel.textColor = UIColor.white
                
                cell.userImageView.image = UIImage.init(named: "close-icon-white")
/*                if self.selectedLoc == "" {
                    cell.titleLabel.text = arr_loc[indexPath.row].uppercased()
                    cell.titleLabel.textColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    cell.backgroundColor = UIColor.init(red: 232.0/255.0, green: 228.0/255.0, blue: 242.0/255.0, alpha: 1.0)
                }else {
                    cell.titleLabel.text = selectedLoc.uppercased()
                    cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                    cell.titleLabel.textColor = UIColor.white
                    
                    cell.userImageView.image = UIImage.init(named: "close-icon-white")
                }*/
            }
            return cell
        }
    }
    extension HunterPostAJobVC: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == coll_jobType {
                let label = UILabel(frame: CGRect.zero)
                label.text = selectedjobType.uppercased()
                label.sizeToFit()
                return CGSize(width: label.frame.width+55, height: 30)
            }else{
                let label = UILabel(frame: CGRect.zero)
                label.text = arr_loc[indexPath.row].uppercased()
                label.sizeToFit()
                return CGSize(width: label.frame.width+55, height: 30)
            }
        }
    }
    class HunterPostAJobCollectionCell: UICollectionViewCell {
        @IBOutlet weak var userImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var buttonRemove: UIButton!
    }


