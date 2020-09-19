//
//  HunterPostAJobNewViewController.swift
//  Hunter
//
//  Created by Shamzi on 15/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterPostAJobNewViewController: UIViewController {
    
    
    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    
    @IBOutlet weak var txtJobTitle: HunterTextField!
    @IBOutlet weak var txtJobFunction: HunterTextField!
    @IBOutlet weak var txtWorkType: HunterTextField!
    @IBOutlet weak var txtSkills: HunterTextField!
    @IBOutlet weak var txtSalaryRange: HunterTextField!
    @IBOutlet weak var txtYearsOfExp: HunterTextField!
    @IBOutlet weak var txtFieldOfEdu: HunterTextField!
    
    @IBOutlet weak var txtViewSummary: UITextView!
    
    @IBOutlet weak var lblNumbOfChars: UILabel!
    
    var dict_field_of_education = NSDictionary()
    var dict_salary_range = NSDictionary()
    var dict_skill = NSDictionary()
    var dict_work_type = NSDictionary()
    var dict_year_of_experience = NSDictionary()
    var dict_job_function = NSDictionary()
    
    var isEdit = String()
    var jobId = Int()

    struct selectionData{
        var field_of_education_IDs = [String]()
        var salary_range_ID = ""
        var skill_IDs = [String]()
        var work_type_ID = ""
        var year_of_experience_ID = ""
        var job_function_IDs = [String]()
        var job_function_Dict = [NSDictionary]()
        var skill_IDs_Dict = [NSDictionary]()
        var field_of_education_IDs_Dict = [NSDictionary]()

        
    }
    var selectedData = selectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyUIChanges()
        
        txtJobFunction.delegate = self
        txtWorkType.delegate = self
        txtSkills.delegate = self
        txtSalaryRange.delegate = self
        txtYearsOfExp.delegate = self
        txtFieldOfEdu.delegate = self
        
        txtViewSummary.delegate = self
        
        getLookUpData()
        
        if isEdit == "true" {
            getEditData()
            postBtn.setTitle("Update", for: UIControl.State.normal)
            saveBtn.isHidden = true
            lab_title.text = "Edit a Job"
        }
    }
    func applyUIChanges(){
        txtViewSummary.text = " Add a Job Summary "
        txtViewSummary.textColor = UIColor.officialApplePlaceholderGray
        txtViewSummary.font = UIFont(name:"GillSans-Italic", size:18)
        
    }
    func getEditData(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.recruiterBaseURL + API.getJobDetailsURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            let params    = [ "job_id" :  jobId]

            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let jobdata = responseDict.value(forKey: "data") as? NSDictionary{
                                    let data = jobdata.value(forKey: "job_details") as! NSDictionary
                                    self.txtJobTitle.text = data["title"] as! String
                                    let work_type = data["work_type"] as! NSDictionary
                                         let work_typeKey = work_type.allKeys
                                        self.selectedData.work_type_ID = "\(work_typeKey[0])"
                                        self.txtWorkType.text = work_type.allValues[0] as! String
                                        
                                    
                                    let salary_range = data["salary_range"] as! NSDictionary
                                         let salary_rangeKey = salary_range.allKeys
                                        self.selectedData.salary_range_ID = "\(salary_rangeKey[0])"
                                        self.txtSalaryRange.text = salary_range.allValues[0] as! String
                                        
                                    
                                    let experience = data["experience"] as! NSDictionary

                                    let experienceKey = experience.allKeys
                                        self.selectedData.year_of_experience_ID = "\(experienceKey[0])"
                                        self.txtYearsOfExp.text = experience.allValues[0] as! String
                                        
                                    
                                    let job_education = data["job_education"] as! NSDictionary
                                         let educationKey = job_education.allKeys
                                        let educationVal = job_education.allValues as! [String]
                                    
                                    self.selectedData.field_of_education_IDs_Dict = []
                                    for jobs in job_education {
                                        var dict = [String:Any]()
                                        dict["name"] = jobs.value
                                        dict["id"] = jobs.key
                                        self.selectedData.field_of_education_IDs_Dict.append(dict as NSDictionary)

                                    }
                                         
                                        self.selectedData.field_of_education_IDs = educationKey as! [String]
                                        self.txtFieldOfEdu.text = educationVal.joined(separator:",")
                                        
                                    
                                    let job_skill = data["job_skill"] as! NSDictionary

                                    let job_skillKey = job_skill.allKeys
                                        let job_skillVal = job_skill.allValues  as! [String]

                                    
                                    self.selectedData.skill_IDs_Dict = []
                                    for jobs in job_skill {
                                        var dict = [String:Any]()
                                        dict["name"] = jobs.value
                                        dict["id"] = jobs.key
                                        self.selectedData.skill_IDs_Dict.append(dict as NSDictionary)

                                    }
                                    
                                    
                                    
                                        self.selectedData.skill_IDs = job_skillKey as! [String]
                                        self.txtSkills.text = job_skillVal.joined(separator:",")
                                        
                                    
                                    let job_function = data["job_function"] as! NSDictionary

                                    let job_functionKey = job_function.allKeys
                                        let job_functionVal = job_function.allValues as! [String]
                                    
                                    self.selectedData.job_function_Dict = []
                                    for jobs in job_function {
                                        var dict = [String:Any]()
                                        dict["name"] = jobs.value
                                        dict["id"] = jobs.key
                                        self.selectedData.job_function_Dict.append(dict as NSDictionary)

                                    }
                                    

                                        self.selectedData.job_function_IDs = job_functionKey as! [String]
                                        self.txtJobFunction.text = job_functionVal.joined(separator:",")
                                        
                                    
                                    self.txtViewSummary.text  = (data["job_summary"] as! String)

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
    func getLookUpData(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.recruiterBaseURL + API.getLookUpData
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
                                    if let lookup_job_data = data.value(forKey: "lookup_job_data") as? NSDictionary{
                                        self.dict_job_function = lookup_job_data.value(forKey: "job_function") as! NSDictionary
                                        self.dict_field_of_education = lookup_job_data.value(forKey: "field_of_education") as! NSDictionary
                                        self.dict_salary_range = lookup_job_data.value(forKey: "salary_range") as! NSDictionary
                                        self.dict_skill = lookup_job_data.value(forKey: "skill") as! NSDictionary
                                        self.dict_work_type = lookup_job_data.value(forKey: "work_type") as! NSDictionary
                                        self.dict_year_of_experience = lookup_job_data.value(forKey: "year_of_experience") as! NSDictionary
                                        
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
        if txtJobTitle.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please enter Job Title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtJobFunction.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Job Function.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtWorkType.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Work Type.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtSkills.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Skills.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtSalaryRange.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Salary.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtYearsOfExp.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Year of Experience.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtFieldOfEdu.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Level of Study.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.postOrSaveAsDraft(isPost: true)
        }
    }

    func postOrSaveAsDraft(isPost : Bool){
        if isEdit == "true" {
            if HunterUtility.isConnectedToInternet(){
                let url = API.recruiterBaseURL + API.updateJobURL
                                
                print(url)
                HunterUtility.showProgressBar()
                
                let headers    = [ "Authorization" : "Bearer " + accessToken]
                

                let paramsDict = ["job_id" : jobId,
                                  "title": txtJobTitle.text ?? "",
                                  "work_type_id": selectedData.work_type_ID ,
                                  "salary_range_id": selectedData.salary_range_ID ,
                                  "experience_id": selectedData.work_type_ID ,
                                  "job_summary": txtViewSummary.text ?? "",
                                  "job_function_ids": selectedData.job_function_IDs ,
                                  "skill_ids": selectedData.skill_IDs ,
                                  "education_id": selectedData.field_of_education_IDs
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
        else {
        if HunterUtility.isConnectedToInternet(){
            var url = ""
            if(isPost){
                url = API.recruiterBaseURL + API.getPostJobURL
            }else{
                url = API.recruiterBaseURL + API.getPostJobAsDraftURL
            }
            
            
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            

            let paramsDict = [
                "title": txtJobTitle.text ?? "",
                              "work_type_id": selectedData.work_type_ID ,
                              "salary_range_id": selectedData.salary_range_ID ,
                              "experience_id": selectedData.work_type_ID ,
                              "job_summary": txtViewSummary.text ?? "",
                              "job_function_ids": selectedData.job_function_IDs ,
                              "skill_ids": selectedData.skill_IDs ,
                              "education_id": selectedData.field_of_education_IDs
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

    @IBAction func actionSaveAsDraft(_ sender: Any) {
        if txtJobTitle.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please enter Job Title.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else if txtJobFunction.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please select Job Function.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else if txtWorkType.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please select Work Type.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else if txtSkills.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please select Skills.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else if txtSalaryRange.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please select Salary.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else if txtYearsOfExp.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please select Year of Experience.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else if txtFieldOfEdu.text == ""{
                let alert = UIAlertController(title: "", message:
                    "Please select Level of Study.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.postOrSaveAsDraft(isPost: false)
            }
    }
    
    func showSelectionViewController(type : String)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
        
        switch type {
        case "JobFunction":
            HunterSelectionViewController.passedDict = self.dict_job_function
            HunterSelectionViewController.isMultiSelect = true
            HunterSelectionViewController.headerText = "Select Job Function"
            if isEdit == "true" {
                HunterSelectionViewController.selectedIDArray = selectedData.job_function_IDs
                HunterSelectionViewController.selectedData = selectedData.job_function_Dict
            }

        case "Skills":
            HunterSelectionViewController.passedDict = self.dict_skill
            HunterSelectionViewController.isMultiSelect = true
            HunterSelectionViewController.headerText = "Select Skills"
            if isEdit == "true" {
                HunterSelectionViewController.selectedIDArray = selectedData.skill_IDs
                HunterSelectionViewController.selectedData = selectedData.skill_IDs_Dict

            }

        case "FieldOfEdu":
            HunterSelectionViewController.passedDict = self.dict_field_of_education
            HunterSelectionViewController.isMultiSelect = true
            HunterSelectionViewController.headerText = "Select Field Of Education"
            if isEdit == "true" {
                HunterSelectionViewController.selectedIDArray = selectedData.field_of_education_IDs
                HunterSelectionViewController.selectedData = selectedData.field_of_education_IDs_Dict

            }

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
            HunterPickerViewController.passedDict = self.dict_work_type
        case "SalaryRange":
            HunterPickerViewController.passedDict = self.dict_salary_range
            
        case "YearsOfExp":
            HunterPickerViewController.passedDict = self.dict_year_of_experience
            
        default:
            break
        }
        
        HunterPickerViewController.delegate = self
        HunterPickerViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterPickerViewController, animated: true, completion: nil)
    }
    
    
}
extension HunterPostAJobNewViewController : hunterDelegate{
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        switch isFrom{
        case  "JobFunction":
            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
            var name = ""
            self.selectedData.job_function_IDs = []
            for dict in selectedData{
               if name != ""{
                   name = name + "," + "\(dict["name"] ?? "")"
               }else{
                   name = dict["name"] as! String
               }
                self.selectedData.job_function_IDs.append(dict["id"] as! String)
            }

            txtJobFunction.text = name
//            selectedData.job_function_ID = selectedDict["id"] as! String
            
        case  "Skills":
            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
            var name = ""
            self.selectedData.skill_IDs = []
            for dict in selectedData{
                if name != ""{
                    name = name + "," + "\(dict["name"] ?? "")"
                }else{
                    name = dict["name"] as! String
                }
                self.selectedData.skill_IDs.append(dict["id"] as! String)
            }
            
            txtSkills.text = name
//            selectedData.skill_ID = selectedDict["id"] as! String
            
        case  "FieldOfEdu":
            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
            var name = ""
            self.selectedData.field_of_education_IDs = []
            for dict in selectedData{
                if name != ""{
                    name = name + "," + "\(dict["name"] ?? "")"
                }else{
                    name = dict["name"] as! String
                }
                self.selectedData.field_of_education_IDs.append(dict["id"] as! String)
                
            }
            txtFieldOfEdu.text = name
//            selectedData.field_of_education_ID = selectedDict["id"] as! String
            
        case  "WorkType":
            txtWorkType.text = selectedDict["name"] as? String ?? ""
            selectedData.work_type_ID = selectedDict["id"] as! String
            
        case  "SalaryRange":
            txtSalaryRange.text = selectedDict["name"] as? String ?? ""
            selectedData.salary_range_ID = selectedDict["id"] as! String
            
        case  "YearsOfExp":
            txtYearsOfExp.text = selectedDict["name"] as? String ?? ""
            selectedData.year_of_experience_ID = selectedDict["id"] as! String
            
        default:
            break
            
            
        }
        
    }
}

extension HunterPostAJobNewViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        txtViewSummary.resignFirstResponder()
        switch textField {
        case txtJobFunction:
            showSelectionViewController(type: "JobFunction")
        case txtWorkType:
            showPickerViewController(type: "WorkType")
        case txtSkills:
            showSelectionViewController(type: "Skills")
        case txtSalaryRange:
            showPickerViewController(type: "SalaryRange")
        case txtYearsOfExp:
            showPickerViewController(type: "YearsOfExp")
        case txtFieldOfEdu:
            showSelectionViewController(type: "FieldOfEdu")
        default:
            break
        }
        return false
    }
    
}
extension HunterPostAJobNewViewController : UITextViewDelegate{
    
  
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.officialApplePlaceholderGray {
            textView.text = nil
            textView.font = UIFont(name:"GillSans-SemiBold", size:16)
            textView.textColor = UIColor.init(hexString: "530F8B")
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = " Add a Job Summary "
            textView.font = UIFont(name:"GillSans-Italic", size:18)
            textView.textColor = UIColor.officialApplePlaceholderGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.textColor == UIColor.officialApplePlaceholderGray {
            textView.text = nil
            textView.font = UIFont(name:"GillSans-SemiBold", size:16)
            textView.textColor = UIColor.init(hexString: "530F8B")
            
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let isUnRestrict = newText.count <= 100
        if(isUnRestrict){
            lblNumbOfChars.text = "\(newText.count)/100"
        }
        
        return isUnRestrict
    }
    
}
