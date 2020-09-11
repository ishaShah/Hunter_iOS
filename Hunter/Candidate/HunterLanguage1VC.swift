//
//  HunterLanguage1VC.swift
//  Hunter
//
//  Created by Zubin Manak on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterLanguage1VC: UIViewController {

    @IBOutlet weak var txtLang: HunterTextField!
    @IBOutlet weak var txtLevelOfProf: HunterTextField!
    @IBOutlet weak var btnAddLang: UIButton!
    
    var langDict = NSDictionary()
    var level_of_prof = NSDictionary()
 
    struct selectionData{
        var lang_ID = ""
        var level_of_prof_ID = ""
        var lang = ""
        var levelID = ""
        
    }
    var selectedData = selectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtLang.delegate = self
        txtLevelOfProf.delegate = self
         
        getLookUpData()
//        updateUI()
        // Do any additional setup after loading the view.
    }
    func updateUI() {
        if txtLevelOfProf.text != "" && txtLang.text != ""   {
            btnAddLang.backgroundColor = UIColor(hex: "#350B76")
            btnAddLang.setTitleColor(UIColor.white, for: .normal)
            
            
        }else{
            btnAddLang.backgroundColor = UIColor(hex: "#EDEDED")
            btnAddLang.setTitleColor(UIColor(hex: "#350B76"), for: .normal)
        }
    }

    @IBAction func actionAddEducation(_ sender: Any) {
        
        
        
        
               if HunterUtility.isConnectedToInternet(){
                   let url = API.candidateBaseURL + API.saveLangDataURL
                   print(url)
                   HunterUtility.showProgressBar()
                   
                   let headers    = [ "Authorization" : "Bearer " + accessToken]
                 let parameters = ["language_id" : selectedData.lang_ID , "proficiency_id" : selectedData.level_of_prof_ID ]
                   Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                       
                       switch response.result {
                       case .success:
                           if let responseDict = response.result.value as? NSDictionary{
                               print(responseDict)
                               SVProgressHUD.dismiss()
                               if let status = responseDict.value(forKey: "status"){
                                if status as! Int == 1{
                                    let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterLanguageListVC") as! HunterLanguageListVC
                                    self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func backToVC(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    func getLookUpData(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.getLookUpLangDataURL
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

                                    self.langDict = data.value(forKey: "languages") as! NSDictionary
                                        self.level_of_prof = data.value(forKey: "proficiency") as! NSDictionary
 
                                    
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
        case "language":
            HunterSelectionViewController.passedDict = self.langDict
            HunterSelectionViewController.headerText = "Select Language"

        case "level_of_prof":
            HunterSelectionViewController.passedDict = self.level_of_prof
            HunterSelectionViewController.headerText = "Select Level Of Proficiency"

            
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
extension HunterLanguage1VC : hunterDelegate{
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        switch isFrom{
            
        case  "language":
            txtLang.text = selectedDict["name"] as? String ?? ""
            selectedData.lang_ID = selectedDict["id"] as! String
            
        case  "level_of_prof":
            txtLevelOfProf.text = selectedDict["name"] as? String ?? ""
            selectedData.level_of_prof_ID = selectedDict["id"] as! String
            
        
            
        default:
            break
            
            
        }
//        updateUI()
        
    }
    func showPickerViewController(type : String) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let HunterPickerViewController = storyboard.instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
         HunterPickerViewController.isFrom = type
         HunterPickerViewController.delegate = self
         HunterPickerViewController.modalPresentationStyle = .overFullScreen
         self.present(HunterPickerViewController, animated: true, completion: nil)
     }
}
extension HunterLanguage1VC : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtLang:
            showSelectionViewController(type: "language")
        case txtLevelOfProf:
            showSelectionViewController(type: "level_of_prof")
        default:
            break
        }
        return false
    }
}
