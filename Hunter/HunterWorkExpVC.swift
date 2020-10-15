//
//  HunterWorkExpVC.swift
//  Hunter
//
//  Created by Zubin Manak on 06/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterWorkExpVC: UIViewController {
    
    var isFromProfile = String()

    @IBOutlet weak var btnContinue: UIButton!
    var isFrom = String()
    @IBOutlet weak var txtWorkExTitle: HunterTextField!
    @IBOutlet weak var txtWorkExCompany: HunterTextField!
    @IBOutlet weak var txtWorkExEmpType: HunterTextField!
    @IBOutlet weak var txtWorkExLoc: HunterTextField!
    @IBOutlet weak var txtWorkStartDate: HunterTextField!
    @IBOutlet weak var txtWorkEndDate: HunterTextField!
    
    var selectedLoc = String()
    var selectedLocID = Int()

    var selectedEmpType = String()
    var selectedEmpTypeID = Int()
    
    
    var selectedStartDate = String()
    var selectedStartDateID = Int()
    
    var selectedEndDate = String()
    var selectedEndDateID = Int()
    
    @IBOutlet weak var btn_currentlyWorking: UIButton!
    @IBOutlet weak var btn_showMyProfile: UIButton!
    
    var dict_EmpType = NSDictionary()
    var dict_Loc = NSDictionary()
 
    var currentWork = 0
    var showMyProfile = 0

    var selectedData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
//        txtWorkExTitle.delegate = self
//        txtWorkExCompany.delegate = self
        txtWorkExEmpType.delegate = self
        txtWorkExLoc.delegate = self
        txtWorkStartDate.delegate = self
        txtWorkEndDate.delegate = self
        
 
        getLookUpData()
        
        updateUIforSelection()
    }
    func updateUIforSelection() {
        if self.txtWorkExTitle.text != "" && self.txtWorkExCompany.text != "" && self.txtWorkExEmpType.text != ""  && self.txtWorkExLoc.text != "" && self.txtWorkStartDate.text != "" && (self.txtWorkEndDate.text != "" || currentWork == 1){
            self.btnContinue.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            self.btnContinue.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }else{
            self.btnContinue.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
            self.btnContinue.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }
        
    }
    @IBAction func showMyProfile(_ sender: Any) {
        
        if showMyProfile == 0 {
            showMyProfile = 1
            
            btn_showMyProfile.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }
        else {
            showMyProfile = 0
            
            btn_showMyProfile.backgroundColor = UIColor.white
            
            
        }
    }
    @IBAction func workExp(_ sender: Any) {
        
        if currentWork == 0 {
            currentWork = 1
            
            btn_currentlyWorking.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }
        else {
            currentWork = 0
            
            btn_currentlyWorking.backgroundColor = UIColor.white
            
            
        }
        updateUIforSelection()
    }
    func getLookUpData(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.getWorkExpURL
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
                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let lookup_job_data = data.value(forKey: "lookup_data") as? NSDictionary{
                                        self.dict_Loc = lookup_job_data.value(forKey: "locations") as! NSDictionary
                                        self.dict_EmpType = lookup_job_data.value(forKey: "employment_type") as! NSDictionary
                                         
                                        
                                    }
                                }
                            }
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
        }
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPostAJob(_ sender: Any) {
        if txtWorkExTitle.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter Title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkExCompany.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter Company Name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkExEmpType.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Employment Type.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkExLoc.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkStartDate.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter Start Date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkEndDate.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter End Date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.postOrSaveAsDraft(isPost: true)
        }
    }

    func postOrSaveAsDraft(isPost : Bool){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.saveCandidateJobExpURL
                    
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            
            let paramsDict = ["job_title": txtWorkExTitle.text ?? "",
                              "company_name": txtWorkExCompany.text ?? "" ,
                              "location_id": selectedLocID ,
                              "work_type": selectedEmpTypeID,
                              "experience_start": txtWorkStartDate.text ?? "",
                              "experience_end": txtWorkEndDate.text ?? "" ,
                              "currently_working_here": currentWork ,
                              "dont_show_profile_for_this_company": showMyProfile] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkExpListVC") as! HunterWorkExpListVC
                                vc.isFrom = self.isFromProfile
                                self.navigationController?.pushViewController(vc, animated: true)
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
            
        }
    }

     
    
    func showSelectionViewController(type : String)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
        
        switch type {
        case "Location":
            HunterSelectionViewController.passedDict = self.dict_Loc
            HunterSelectionViewController.isMultiSelect = false
            HunterSelectionViewController.headerText = "Select Location"

        

        default:
            break
        }
        
        HunterSelectionViewController.delegate = self
        HunterSelectionViewController.isFrom = type
        HunterSelectionViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterSelectionViewController, animated: true, completion: nil)
    }
    
    func showPickerViewController(type : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HunterPickerViewController = storyboard.instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
        HunterPickerViewController.delegate = self
        HunterPickerViewController.isFrom = type
 
        if type == "EmpType"{
        HunterPickerViewController.passedDict = self.dict_EmpType
        }
        HunterPickerViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterPickerViewController, animated: true, completion: nil)
    }
    
    
}
extension HunterWorkExpVC : hunterDelegate{
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        switch isFrom{
        case  "Location":
            
            
            self.selectedLoc = selectedDict["name"] as! String
            self.selectedLocID = Int(selectedDict["id"] as! String)!
            
            
            txtWorkExLoc.text = self.selectedLoc
            updateUIforSelection()
        case  "EmpType":
            
            guard selectedDict["name"]  != nil else {
                return
            }
            self.selectedEmpType = selectedDict["name"] as! String
            self.selectedEmpTypeID = Int( selectedDict["id"] as! String)!
            
            
            txtWorkExEmpType.text = self.selectedEmpType
            updateUIforSelection()
        case  "StartDate":
            
            
            self.selectedStartDate = selectedDict["selectedYear"] as! String
            
            
            txtWorkStartDate.text = self.selectedStartDate
            updateUIforSelection()
        case  "EndDate":
            
            
            self.selectedEndDate = selectedDict["selectedYear"] as! String
            
            
            txtWorkEndDate.text = self.selectedEndDate
            updateUIforSelection()
        default:
            break
            
            
        }
        
    }
}

extension HunterWorkExpVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        switch textField {
        case txtWorkExLoc:
            showSelectionViewController(type: "Location")
        case txtWorkExEmpType:
            showPickerViewController(type: "EmpType")
        case txtWorkStartDate:
            showPickerViewController(type: "StartDate")
        case txtWorkEndDate:
            showPickerViewController(type: "EndDate")
        default:
            break
        }
        return false
    }
    
}
