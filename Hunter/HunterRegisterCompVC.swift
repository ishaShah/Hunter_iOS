//
//  HunterRegisterCompVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/21/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import SVProgressHUD
import AlignedCollectionViewFlowLayout

protocol hunterDelegate: class {
    func selectedData(selectedDict: NSDictionary, isFrom: String)
}

class HunterRegisterCompVC: UIViewController, UITextFieldDelegate,hunterDelegate{
   
    var profileDelegate: refreshProfileDelegate!
    @IBOutlet weak var contButton: UIButton!

    var profileDict = NSDictionary()
    var isFromReg = false
    var isEdit = false
    var arr_industry = [String]()
    var dict_industry = NSDictionary()
    var arr_industryID = [String]()
    var arr_headquarters = [String]()
    var arr_headquartersID = [String]()
    var dict_headquarters = NSDictionary()

    var arr_type = [String]()
    var arr_typeID = [String]()
    
    var selectedIndustry = String()
    var selectedIndustryID = String()
    var selectedFoundedYear = String()
    var selectedHeadquarters = String()
    var selectedHeadquartersID = String()
 
    @IBOutlet weak var lab_NameOfCompany: UILabel!
    @IBOutlet weak var lab_industry: UILabel!
    @IBOutlet weak var lab_headquaters: UILabel!
    @IBOutlet weak var lab_founded: UILabel!
    @IBOutlet weak var lab_website: UILabel!
    
    @IBOutlet weak var txt_companyName: UITextField!
    @IBOutlet weak var txt_industry: UITextField!
    @IBOutlet weak var txt_headquaters: UITextField!
    @IBOutlet weak var txt_founded: UITextField!
    @IBOutlet weak var txt_website: UITextField!
    @IBOutlet weak var img_Top: UIImageView!
    @IBOutlet weak var lab_top: UILabel!
    
    
    var industry_id = Int()
    var location_id = Int()
    
    @IBOutlet weak var stakc_threeDot: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
         
    }
    override func viewWillAppear(_ animated: Bool) {
        connectToRegisterCompanyIndustry()
         ifEdit()

    }
    func ifEdit(){
        if isEdit == true {
            img_Top.image = UIImage.init(named: "user-icon")
            lab_top.text = "Basic Information"
            
            lab_NameOfCompany.text = "Name of company"
            lab_industry.text = "Industry"
            lab_headquaters.text = "Headquaters"
            lab_founded.text = "Founded"
            lab_website.text = "Website"
            
            self.contButton.setTitle("SAVE", for: UIControl.State.normal)
            self.contButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"350B76" )
            
            self.txt_companyName.text = "\(profileDict["company_name"] as! String)".uppercased()
            self.txt_industry.text = "\(profileDict["industry"] as! String)"
            self.txt_headquaters.text  = "\(profileDict["location"] as! String)"
            self.txt_founded.text = "\(profileDict["founded"] as! Int)"
            self.txt_website.text = "\(profileDict["website"] as! String)"
            self.selectedFoundedYear = "\(profileDict["founded"] as! Int)"
            self.selectedIndustry = "\(profileDict["industry"] as! String)"
            self.selectedIndustryID =  "\(profileDict["industry_id"] as! Int)"
            self.selectedHeadquarters = "\(profileDict["location"] as! String)"
            self.selectedHeadquartersID = "\(profileDict["location_id"] as! Int)"
            // updateBasicInformationURL
            print(profileDict)
        }
        else {
            lab_NameOfCompany.text = ""
            lab_industry.text = ""
            lab_headquaters.text = ""
            lab_founded.text = ""
            lab_website.text = ""
        }
        stakc_threeDot.isHidden = isEdit

    }
    func autosizeCollectionView(_ collectionV: UICollectionView, _ collectionHeight: NSLayoutConstraint){
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            collectionV.layoutIfNeeded()
            let height = collectionV.contentSize.height
            collectionHeight.constant = height
            collectionV.needsUpdateConstraints()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !((textField == txt_companyName) || (textField == txt_website)){
             textField.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField == txt_companyName){
            textField.resignFirstResponder()
        }else{
            if textField.text == ""{
                self.contButton.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
                self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
            }else{
                if selectedIndustry.count != 0 && selectedHeadquarters.count != 0 {
                    self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
                    self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
                }
            }
        }
    }
    @objc func selectedData(selectedDict: NSDictionary , isFrom : String) {
        if isFrom == "Industry" {
            print(selectedDict["name"] as! String)
            self.txt_industry.text = (selectedDict["name"] as! String)
            selectedIndustry = selectedDict["name"] as! String
            selectedIndustryID = selectedDict["id"] as! String
        }else if isFrom == "Founded"{
            self.txt_founded.text = (selectedDict["selectedYear"] as! String)
            self.selectedFoundedYear = (selectedDict["selectedYear"] as! String)
        }
        else {
            self.txt_headquaters.text = (selectedDict["name"] as! String)
            selectedHeadquarters = selectedDict["name"] as! String
            selectedHeadquartersID = selectedDict["id"] as! String
        }
        print(selectedDict)
    }
    @IBAction func industryClick(_ sender: Any) {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
       HunterSelectionViewController.delegate = self
        HunterSelectionViewController.passedDict = dict_industry
        HunterSelectionViewController.isFrom = "Industry"
        HunterSelectionViewController.headerText = "Select Industry"

       HunterSelectionViewController.modalPresentationStyle = .overFullScreen
       self.present(HunterSelectionViewController, animated: true, completion: nil)
    }
    @IBAction func headquatersClick(_ sender: Any) {
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
       let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
       HunterSelectionViewController.delegate = self
        HunterSelectionViewController.passedDict = dict_headquarters
        HunterSelectionViewController.isFrom = "Headquaters"
        HunterSelectionViewController.headerText = "Select Headquaters"

       HunterSelectionViewController.modalPresentationStyle = .overFullScreen
       self.present(HunterSelectionViewController, animated: true, completion: nil)
    }
    @IBAction func foundedClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HunterPickerViewController = storyboard.instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
        HunterPickerViewController.isFrom = "Founded"
        HunterPickerViewController.delegate = self
        
        HunterPickerViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterPickerViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Webservice
    func connectToRegisterCompanyIndustry(){
        
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
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                let data = responseDict.value(forKey: "data") as! NSDictionary
                                let company_registration = data.value(forKey:"company_registration") as! NSDictionary
                                self.dict_industry = company_registration.value(forKey: "industry") as! NSDictionary
                                self.dict_headquarters = company_registration.value(forKey: "headquarters") as! NSDictionary
  
                                self.arr_industry = self.dict_industry.allValues as! [String]
                                self.arr_industryID = self.dict_industry.allKeys as! [String]
                                self.arr_headquarters  = self.dict_headquarters.allValues as! [String]
                                self.arr_headquartersID  = self.dict_headquarters.allKeys as! [String]

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
     func connectToRegisterSaveCompanyDetails(){
        if isEdit == true {
            if HunterUtility.isConnectedToInternet(){
 

//              company_name
//              industry_id
//              headquarters_id
//              founded_on
//              website
//
                
                let url = API.recruiterBaseURL + API.updateBasicInformationURL
                print(url)
                HunterUtility.showProgressBar()
                let paramsDict = ["company_name": self.txt_companyName.text!, "industry_id" : self.selectedIndustryID,  "headquarters_id" : self.selectedHeadquartersID , "founded_on" : self.selectedFoundedYear , "website" : self.txt_website.text! ] as [String : Any]
                
                let headers    = [ "Authorization" : "Bearer " + accessToken]
                
                Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        if let responseDict = response.result.value as? NSDictionary{
                            print(responseDict)
                            SVProgressHUD.dismiss()
                            if let status = responseDict.value(forKey: "status"){
                                if status as! Int == 1   {
                                    self.dismiss(animated: true) {
                                        var loginType = String()
                                               if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                                                   loginType = type
                                               }
                                               // Do any additional setup after loading the view.
                                        if self.isFromReg == false {
                                                
                                                self.profileDelegate.refetchFromCloud()
                                        }
                                               else {
                                                   let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompOneVC") as! HunterRegisterCompOneVC
                                                   self.navigationController?.pushViewController(vc, animated: true)
                                               }
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
        else {
        if HunterUtility.isConnectedToInternet(){
          
            
            let url = API.recruiterBaseURL + API.registerSaveCompanyDetailsURL
            print(url)
            HunterUtility.showProgressBar()
            let paramsDict = ["company_name": self.txt_companyName.text!, "industry_id" : self.selectedIndustryID,  "headquarters_id" : self.selectedHeadquartersID , "founded_on" : self.selectedFoundedYear , "website" : self.txt_website.text! ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                self.dismiss(animated: true) {
                                    var loginType = String()
                                           if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                                               loginType = type
                                           }
                                           // Do any additional setup after loading the view.
                                    if self.isFromReg == false {
                                            
                                            self.profileDelegate.refetchFromCloud()
                                    }
                                           else {
                                               let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompOneVC") as! HunterRegisterCompOneVC
                                               self.navigationController?.pushViewController(vc, animated: true)
                                           }
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
    }
    @IBAction func btn_continue(_ sender: Any) {
        if txt_companyName.text == ""{
            let alert = UIAlertController(title: "", message:
                "Company name cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if selectedIndustry == ""{
            let alert = UIAlertController(title: "", message:
                "Please select a industry", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if selectedHeadquarters == ""{
            let alert = UIAlertController(title: "", message:
                "Please select headquaters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            connectToRegisterSaveCompanyDetails()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        if isEdit {
            self.dismiss(animated: true, completion: nil)
        }
        else {
        self.navigationController?.popViewController(animated: true)
        }
    }
        
}

 
