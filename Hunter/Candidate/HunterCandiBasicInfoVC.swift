//
//  HunterCandiBasicInfoVC.swift
//  Hunter
//
//  Created by Shamseer on 12/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterCandiBasicInfoVC: UIViewController {
    
    
    // UI Elements
    
    @IBOutlet weak var txtFirstName: HunterTextField!
    @IBOutlet weak var txtLastName: HunterTextField!
    @IBOutlet weak var txtWorkType: HunterTextField!
    @IBOutlet weak var txtSalary: HunterTextField!
    @IBOutlet weak var btnShowSalary: UIButton!
    
    @IBOutlet weak var collViewJobFunction: UICollectionView!
    @IBOutlet weak var htJobFunction: NSLayoutConstraint!
    
    @IBOutlet weak var txtCurrentLocation: HunterTextField!
    
    @IBOutlet weak var collViewSerchingLoc: UICollectionView!
    @IBOutlet weak var htSearchingLoc: NSLayoutConstraint!
    @IBOutlet weak var lblJobFunctionTitle: UILabel!
    
 
    
    
    var jobFunctionArray = [[String : Any]]()
    var locaionArray = [[String : Any]]()
    
    
    var lookup_salary_range = NSDictionary()
    var lookup_work_type = NSDictionary()
    var lookup_job_functions = NSDictionary()
    var lookup_locations = NSDictionary()
    
    //preferences
    var salary_range_id = Int()
    var preferred_work_type_id = Int()
    var preferred_location_ids = [Int]()
    var job_function_ids = [Int]()
    var current_location_id = Int()
    
    var show_salary_on_profile = 0{
         didSet{
             if show_salary_on_profile == 1{
                 if #available(iOS 13.0, *) {
                     btnShowSalary.setImage(UIImage(systemName: "smallcircle.fill.circle.fill"), for: .normal)
                 } else {
                     // Fallback on earlier versions
                 }
             }else{
                 if #available(iOS 13.0, *) {
                     btnShowSalary.setImage(UIImage(systemName: "circle"), for: .normal)
                 } else {
                     // Fallback on earlier versions
                 }
             }
         }
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSalary.delegate = self
        txtWorkType.delegate = self
        txtCurrentLocation.delegate = self
        
        
        collViewJobFunction.delegate = self
        collViewJobFunction.dataSource = self
        
        collViewSerchingLoc.delegate = self
        collViewSerchingLoc.dataSource = self
        
     
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
        collViewSerchingLoc.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
        collViewJobFunction.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
        
        getBasicInformation()
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func updatePreferences(){
        jobFunctionArray = []
        locaionArray = []
        for jobID : Int in job_function_ids{
            let jobIDStr = "\(jobID)"
            if let jobName : String = lookup_job_functions[jobIDStr] as? String{
                print(jobName )
                let dict : [String : Any] = ["name" : jobName,"id" : jobIDStr]
                jobFunctionArray.append(dict)
            }
            
        }
        
        for locID : Int in preferred_location_ids{
            let locIDStr = "\(locID)"
            if let locName : String = lookup_locations[locIDStr] as? String{
                print(locName )
                let dict : [String : Any] = ["name" : locName,"id" : locIDStr]
                locaionArray.append(dict)
            }
            
        }
        
        if let salaryName = lookup_salary_range["\(salary_range_id)"]{
            txtSalary.text = salaryName as? String
        }
        if let locName = lookup_locations["\(current_location_id)"]{
            txtCurrentLocation.text = locName as? String
        }
        if let workTypeName = lookup_work_type["\(preferred_work_type_id)"]{
            txtWorkType.text = workTypeName as? String
        }
        
        
        
        htJobFunction.constant = collViewJobFunction.contentSize.height
        htSearchingLoc.constant = collViewSerchingLoc.contentSize.height
        
        collViewJobFunction.reloadData()
        collViewSerchingLoc.reloadData()
        
    }
    @IBAction func actionSwitchSalaryShow(_ sender: Any) {
        if show_salary_on_profile == 0{
            show_salary_on_profile = 1
        }else{
            show_salary_on_profile = 0
        }
        
    }
    
    
    
    func getBasicInformation() {
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.getBasicInfoURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    self.job_function_ids = []
                    self.preferred_location_ids = []
                    self.lookup_job_functions = [:]
                    self.lookup_locations = [:]
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let candidate_details = data.value(forKey: "Candidate_details") as? NSDictionary{
                                        self.txtFirstName.text = candidate_details["first_name"] as? String ?? ""
                                        self.txtLastName.text = candidate_details["last_name"] as? String ?? ""
                                        self.lookup_job_functions = candidate_details["lookup_job_functions"] as! NSDictionary
                                        self.lookup_locations = candidate_details["lookup_locations"] as! NSDictionary
                                        self.lookup_salary_range = candidate_details["lookup_salary_range"] as! NSDictionary
                                        self.lookup_work_type = candidate_details["lookup_work_type"] as! NSDictionary
                                        self.job_function_ids = candidate_details["job_function_ids"] as! [Int]
                                        self.preferred_location_ids = candidate_details["preferred_location_ids"] as! [Int]
                                        
                                        self.current_location_id = candidate_details["current_location_id"] as! Int
                                        self.preferred_work_type_id = candidate_details["preferred_work_type_id"] as! Int
                                        self.salary_range_id = candidate_details["salary_range_id"] as! Int
                                        self.show_salary_on_profile = candidate_details["show_salary_on_profile"] as! Int
                                        self.show_salary_on_profile = candidate_details["show_salary_on_profile"] as! Int
                                        self.updatePreferences()
                                        
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
    
    
    
    func showSelectionViewController(type : String)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
        
        switch type {
        case "JobFunction":
            HunterSelectionViewController.passedDict = self.lookup_job_functions
            HunterSelectionViewController.isMultiSelect = true
            HunterSelectionViewController.headerText = "Select Job Function"

        case "Location":
            HunterSelectionViewController.passedDict = self.lookup_locations
            HunterSelectionViewController.isMultiSelect = true
            HunterSelectionViewController.headerText = "Select Searching Location"

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
        HunterPickerViewController.isFrom = type
        
        switch type {
        case "WorkType":
            HunterPickerViewController.passedDict = self.lookup_work_type
        case "SalaryRange":
            HunterPickerViewController.passedDict = self.lookup_salary_range
            
        case "CurrentLoc":
            HunterPickerViewController.passedDict = self.lookup_locations
            
        default:
            break
        }
        HunterPickerViewController.delegate = self
        HunterPickerViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterPickerViewController, animated: true, completion: nil)
    }
    @IBAction func actionAddJobFunction(_ sender: Any) {
        showSelectionViewController(type: "JobFunction")
    }
    @IBAction func actionAddSearchingLoc(_ sender: Any) {
        showSelectionViewController(type: "Location")
    }
    
    @IBAction func actionSave(_ sender: Any) {
        if txtFirstName.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter First Name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtLastName.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter Last Name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkType.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Work Type.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtSalary.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Salary.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtCurrentLocation.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Current Location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if self.locaionArray.count == 0{
            let alert = UIAlertController(title: "", message:
                "Please select Searching Location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if self.jobFunctionArray.count == 0{
            let alert = UIAlertController(title: "", message:
                "Please select Job Function.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.updateCandidateBasicInfo()
        }
        
    }
    func updateCandidateBasicInfo() {
        
        if HunterUtility.isConnectedToInternet(){
            
            let  url = API.candidateBaseURL + API.updateBasicInformationURL
            
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["first_name": txtFirstName.text ?? "",
                              "last_name": txtLastName.text ?? "" ,
                              "preferred_work_type_id": "\(preferred_work_type_id)",
                              "salary_range_id": "\(salary_range_id)" ,
                              "show_salary_on_profile": "\(show_salary_on_profile)",
                              "location_id": "\(current_location_id)" ,
                              "preferred_location_ids": preferred_location_ids,
                              "job_function_ids": job_function_ids
                
                ] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                
                                self.navigationController?.popViewController(animated: true)
                                
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
    

}
extension HunterCandiBasicInfoVC : hunterDelegate{
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        switch isFrom{
        case  "JobFunction":
            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
            self.job_function_ids = []
            for dict in selectedData{
                let idStr = dict["id"] as? String ?? "0"
                self.job_function_ids.append(Int(idStr) ?? 0)
            }
            
        case  "Location":
            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
            self.preferred_location_ids = []
            for dict in selectedData{
              
                let idStr = dict["id"] as? String ?? "0"
                self.preferred_location_ids.append(Int(idStr) ?? 0)
            }
        case  "WorkType":
            let idStr = selectedDict["id"] as? String ?? "0"
            self.preferred_work_type_id = Int(idStr) ?? 0
            
        case  "SalaryRange":
            let idStr = selectedDict["id"] as? String ?? "0"
            self.salary_range_id = Int(idStr) ?? 0
        case  "CurrentLoc":
           let idStr = selectedDict["id"] as? String ?? "0"
           self.current_location_id = Int(idStr) ?? 0
        default:
            break
        }
        self.updatePreferences()
    }
    
    
    
}
extension HunterCandiBasicInfoVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collViewJobFunction{
            return jobFunctionArray.count
        }else{
            return locaionArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collViewJobFunction{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterWorkLocTwoCollectionCell", for: indexPath) as! HunterWorkLocTwoCollectionCell
            
            let dict = jobFunctionArray[indexPath.row]
            cell.buttonRemove.isHidden = false
            
            cell.titleLabel.text = dict["name"] as? String
            cell.buttonRemove.tag = indexPath.item
            
            cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            cell.titleLabel.textColor = UIColor.white
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterWorkLocTwoCollectionCell", for: indexPath) as! HunterWorkLocTwoCollectionCell
            
            let dict = locaionArray[indexPath.row]
            
            cell.buttonRemove.isHidden = false
            
            cell.titleLabel.text = dict["name"] as? String
            cell.buttonRemove.tag = indexPath.item
            
            cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            cell.titleLabel.textColor = UIColor.white
            
            
            return cell
        }
        
        
        
    }
    
    
    
    
    
}
extension HunterCandiBasicInfoVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var dict = [String:Any]()
        if collectionView == collViewJobFunction{
            dict = jobFunctionArray[indexPath.row]
        }else{
            dict = locaionArray[indexPath.row]
        }
        
        let label = UILabel(frame: CGRect.zero)
        
        label.text = dict["name"] as? String
        label.sizeToFit()
        return CGSize(width: label.frame.width+55, height: 30)
    }
}

extension HunterCandiBasicInfoVC : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtSalary {
            self.showPickerViewController(type: "SalaryRange")
        }else if textField == txtWorkType{
            self.showPickerViewController(type: "WorkType")
        }else if textField == txtCurrentLocation{
            self.showPickerViewController(type: "CurrentLoc")
        }else{
            return true
        }
        return false
    }
}
