//
//  HunterEducationStep2VC.swift
//  Hunter
//
//  Created by Shamseer on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterEducationStep2VC: UIViewController {

    @IBOutlet weak var txtSchool: HunterTextField!
    @IBOutlet weak var txtLevelOfStudy: HunterTextField!
    @IBOutlet weak var txtFieldOfStudy: HunterTextField!
    @IBOutlet weak var txtStartDate: HunterTextField!
    @IBOutlet weak var txtEndDate: HunterTextField!
    @IBOutlet weak var btnAddEdu: UIButton!
    
    var field_of_study = NSDictionary()
    var level_of_study = NSDictionary()
    var school = NSDictionary()
    
    struct selectionData{
        var field_of_study_ID = ""
        var level_of_study_ID = ""
        var school_ID = ""
        var startDate = ""
        var endDate = ""
        
    }
    var isFrom = String()
    var selectedData = selectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtSchool.delegate = self
        txtLevelOfStudy.delegate = self
        txtFieldOfStudy.delegate = self
        txtStartDate.delegate = self
        txtEndDate.delegate = self
        getLookUpData()
//        updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        if txtSchool.text != "" && txtLevelOfStudy.text != "" && txtFieldOfStudy.text != "" && txtStartDate.text != "" && txtEndDate.text != "" {
            btnAddEdu.backgroundColor = UIColor(hex: "#350B76")
            btnAddEdu.setTitleColor(UIColor.white, for: .normal)
            
            
        }else{
            btnAddEdu.backgroundColor = UIColor(hex: "#EDEDED")
            btnAddEdu.setTitleColor(UIColor(hex: "#350B76"), for: .normal)
        }
    }

    @IBAction func actionAddEducation(_ sender: Any) {
        // save action
        if txtSchool.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select your school.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtFieldOfStudy.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Field of Study.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtLevelOfStudy.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Level of Study.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtStartDate.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select Start Date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else if txtEndDate.text == ""{
            let alert = UIAlertController(title: "", message:
                "Please select End Date.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            connectToSaveEduQualicficationURL()
        }
         
    }
    
    func connectToSaveEduQualicficationURL(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.saveEduQualificationURL
            print(url)
            HunterUtility.showProgressBar()
            
            let paramsDict = ["school": selectedData.school_ID , "level_of_study" : selectedData.level_of_study_ID, "field_of_study" : selectedData.field_of_study_ID, "start_date":selectedData.startDate , "end_date": selectedData.endDate ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                
                                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.goToListEducationVC), userInfo: nil, repeats: false)
                                
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
    
    @objc func goToListEducationVC() {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterListAllEduVC") as! HunterListAllEduVC
        vc.isFrom = isFrom
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backToVC(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    func getLookUpData(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.registerEduLookUpDataURL
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
                                    if let lookup_data = data.value(forKey: "lookup_data") as? NSDictionary{
                                       self.field_of_study = lookup_data.value(forKey: "field_of_study") as! NSDictionary
                                        self.level_of_study = lookup_data.value(forKey: "level_of_study") as! NSDictionary
                                        self.school = lookup_data.value(forKey: "school") as! NSDictionary
                                        
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
        case "field_of_study":
            HunterSelectionViewController.passedDict = self.field_of_study
            HunterSelectionViewController.headerText = "Select Field Of Study"
        case "school":
            HunterSelectionViewController.passedDict = self.school
            HunterSelectionViewController.headerText = "Select School"
        default:
            break
        }
        HunterSelectionViewController.isMultiSelect = false
        HunterSelectionViewController.delegate = self
        HunterSelectionViewController.isFrom = type
        HunterSelectionViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterSelectionViewController, animated: true, completion: nil)
    }
}
extension HunterEducationStep2VC : hunterDelegate{
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        switch isFrom{
            
        case  "school":
            txtSchool.text = selectedDict["name"] as? String ?? ""
            selectedData.school_ID = selectedDict["id"] as! String
            
        case  "level_of_study":
            txtLevelOfStudy.text = selectedDict["name"] as? String ?? ""
            selectedData.level_of_study_ID = selectedDict["id"] as! String
            
        case  "field_of_study":
            txtFieldOfStudy.text = selectedDict["name"] as? String ?? ""
            selectedData.field_of_study_ID = selectedDict["id"] as! String
            
        case  "startDate":
            txtStartDate.text = selectedDict["selectedYear"] as? String ?? ""
            selectedData.startDate = selectedDict["selectedYear"] as! String
            
        case  "endDate":
            txtEndDate.text = selectedDict["selectedYear"] as? String ?? ""
            selectedData.endDate = selectedDict["selectedYear"] as! String
            
        default:
            break
            
            
        }
//        updateUI()
        
    }
    func showPickerViewController(type : String) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let HunterPickerViewController = storyboard.instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
         HunterPickerViewController.isFrom = type
        if type == "level_of_study" {
            HunterPickerViewController.isFrom = type
            HunterPickerViewController.passedDict = self.level_of_study

        }
         HunterPickerViewController.delegate = self
         HunterPickerViewController.modalPresentationStyle = .overFullScreen
         self.present(HunterPickerViewController, animated: true, completion: nil)
     }
}
extension HunterEducationStep2VC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtSchool:
            showSelectionViewController(type: "school")
        case txtLevelOfStudy:
            showPickerViewController(type: "level_of_study")
        case txtFieldOfStudy:
            showSelectionViewController(type: "field_of_study")
        case txtStartDate:
            showPickerViewController(type: "startDate")
        case txtEndDate:
            showPickerViewController(type: "endDate")
        default:
            break
        }
        return false
    }
}

