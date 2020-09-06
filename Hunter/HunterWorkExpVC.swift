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
    
    
    
    @IBOutlet weak var txtWorkExTitle: HunterTextField!
    @IBOutlet weak var txtWorkExCompany: HunterTextField!
    @IBOutlet weak var txtWorkExEmpType: HunterTextField!
    @IBOutlet weak var txtWorkExLoc: HunterTextField!
    @IBOutlet weak var txtWorkStartDate: HunterTextField!
    @IBOutlet weak var txtWorkEndDate: HunterTextField!
    
 
 
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
//        txtWorkExEmpType.delegate = self
//        txtWorkExLoc.delegate = self
//        txtWorkStartDate.delegate = self
//        txtWorkEndDate.delegate = self
        
 
        //getLookUpData()
        
        
    }
     
//    func getLookUpData(){
//        if HunterUtility.isConnectedToInternet(){
//            let url = API.candidateBaseURL + API.getJobExpURL
//            print(url)
//            HunterUtility.showProgressBar()
//
//            let headers    = [ "Authorization" : "Bearer " + accessToken]
//
//            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1{
//                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
//                                    if let lookup_job_data = data.value(forKey: "lookup_job_data") as? NSDictionary{
//                                        self.dict_job_function = lookup_job_data.value(forKey: "job_function") as! NSDictionary
//                                        self.dict_field_of_education = lookup_job_data.value(forKey: "field_of_education") as! NSDictionary
//                                        self.dict_salary_range = lookup_job_data.value(forKey: "salary_range") as! NSDictionary
//                                        self.dict_skill = lookup_job_data.value(forKey: "skill") as! NSDictionary
//                                        self.dict_work_type = lookup_job_data.value(forKey: "work_type") as! NSDictionary
//                                        self.dict_year_of_experience = lookup_job_data.value(forKey: "year_of_experience") as! NSDictionary
//
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//    }
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
//            self.postOrSaveAsDraft(isPost: true)
        }
    }

//    func postOrSaveAsDraft(isPost : Bool){
//        if HunterUtility.isConnectedToInternet(){
//            var url = ""
//            if(isPost){
//                url = API.recruiterBaseURL + API.getPostJobURL
//            }else{
//                url = API.recruiterBaseURL + API.getPostJobAsDraftURL
//            }
//
//
//            print(url)
//            HunterUtility.showProgressBar()
//
//            let headers    = [ "Authorization" : "Bearer " + accessToken]
//
//
//            let paramsDict = ["title": txtJobTitle.text ?? "",
//                              "work_type_id": selectedData.work_type_ID ,
//                              "salary_range_id": selectedData.salary_range_ID ,
//                              "experience_id": selectedData.work_type_ID ,
//                              "job_summary": txtViewSummary.text ?? "",
//                              "job_function_ids": selectedData.job_function_IDs ,
//                              "skill_ids": selectedData.skill_IDs ,
//                              "education_id": selectedData.field_of_education_IDs
//                ] as [String : Any]
//
//            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1   {
//
//                                self.navigationController?.popViewController(animated: true)
//
//                            }else if status as! Int == 2 {
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//                                print("Logout api")
//
//                                UserDefaults.standard.removeObject(forKey: "accessToken")
//                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
//                                accessToken = String()
//
//                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
//                                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
//                                navigationController.viewControllers = [mainRootController]
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window?.rootViewController = navigationController
//                            }else{
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }else{
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }else{
//                        SVProgressHUD.dismiss()
//                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
//                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
//                        //                        self.present(alert, animated: true, completion: nil)
//                    }
//
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//
//        }
//    }

     
    
//    func showSelectionViewController(type : String)  {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
//
//        switch type {
//        case "JobFunction":
//            HunterSelectionViewController.passedDict = self.dict_job_function
//            HunterSelectionViewController.isMultiSelect = true
//        case "Skills":
//            HunterSelectionViewController.passedDict = self.dict_skill
//            HunterSelectionViewController.isMultiSelect = true
//
//        case "FieldOfEdu":
//            HunterSelectionViewController.passedDict = self.dict_field_of_education
//            HunterSelectionViewController.isMultiSelect = true
//        default:
//            break
//        }
//
//        HunterSelectionViewController.delegate = self
//        HunterSelectionViewController.isFrom = type
//        HunterSelectionViewController.modalPresentationStyle = .overFullScreen
//        self.present(HunterSelectionViewController, animated: true, completion: nil)
//    }
    
//    func showPickerViewController(type : String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let HunterPickerViewController = storyboard.instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
//        HunterPickerViewController.isFrom = type
//
//        switch type {
//        case "WorkType":
//            HunterPickerViewController.passedDict = self.dict_work_type
//        case "SalaryRange":
//            HunterPickerViewController.passedDict = self.dict_salary_range
//
//        case "YearsOfExp":
//            HunterPickerViewController.passedDict = self.dict_year_of_experience
//
//        default:
//            break
//        }
//
//        HunterPickerViewController.delegate = self
//        HunterPickerViewController.modalPresentationStyle = .overFullScreen
//        self.present(HunterPickerViewController, animated: true, completion: nil)
//    }
    
    
}
//extension HunterWorkExpVC : hunterDelegate{
//    func selectedData(selectedDict: NSDictionary, isFrom: String) {
//        switch isFrom{
//        case  "JobFunction":
//            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
//            var name = ""
//            self.selectedData.job_function_IDs = []
//            for dict in selectedData{
//               if name != ""{
//                   name = name + "," + "\(dict["name"] ?? "")"
//               }else{
//                   name = dict["name"] as! String
//               }
//                self.selectedData.job_function_IDs.append(dict["id"] as! String)
//            }
//
//            txtJobFunction.text = name
////            selectedData.job_function_ID = selectedDict["id"] as! String
//
//        case  "Skills":
//            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
//            var name = ""
//            self.selectedData.skill_IDs = []
//            for dict in selectedData{
//                if name != ""{
//                    name = name + "," + "\(dict["name"] ?? "")"
//                }else{
//                    name = dict["name"] as! String
//                }
//                self.selectedData.skill_IDs.append(dict["id"] as! String)
//            }
//
//            txtSkills.text = name
////            selectedData.skill_ID = selectedDict["id"] as! String
//
//        case  "FieldOfEdu":
//            let selectedData = selectedDict["selectedData"] as! [NSDictionary]
//            var name = ""
//            self.selectedData.field_of_education_IDs = []
//            for dict in selectedData{
//                if name != ""{
//                    name = name + "," + "\(dict["name"] ?? "")"
//                }else{
//                    name = dict["name"] as! String
//                }
//                self.selectedData.field_of_education_IDs.append(dict["id"] as! String)
//
//            }
//            txtFieldOfEdu.text = name
////            selectedData.field_of_education_ID = selectedDict["id"] as! String
//
//        case  "WorkType":
//            txtWorkType.text = selectedDict["name"] as? String ?? ""
//            selectedData.work_type_ID = selectedDict["id"] as! String
//
//        case  "SalaryRange":
//            txtSalaryRange.text = selectedDict["name"] as? String ?? ""
//            selectedData.salary_range_ID = selectedDict["id"] as! String
//
//        case  "YearsOfExp":
//            txtYearsOfExp.text = selectedDict["name"] as? String ?? ""
//            selectedData.year_of_experience_ID = selectedDict["id"] as! String
//
//        default:
//            break
//
//
//        }
//
//    }
//}

//extension HunterWorkExpVC : UITextFieldDelegate{
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        txtViewSummary.resignFirstResponder()
//        switch textField {
//        case txtJobFunction:
//            showSelectionViewController(type: "JobFunction")
//        case txtWorkType:
//            showPickerViewController(type: "WorkType")
//        case txtSkills:
//            showSelectionViewController(type: "Skills")
//        case txtSalaryRange:
//            showPickerViewController(type: "SalaryRange")
//        case txtYearsOfExp:
//            showPickerViewController(type: "YearsOfExp")
//        case txtFieldOfEdu:
//            showSelectionViewController(type: "FieldOfEdu")
//        default:
//            break
//        }
//        return false
//    }
//
//}
