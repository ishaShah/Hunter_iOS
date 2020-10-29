//
//  HunterAchieveVC.swift
//  Hunter
//
//  Created by Zubin Manak on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterAchieveVC: UIViewController {

    @IBOutlet weak var txtTitle: HunterTextField!
    @IBOutlet weak var txtIssueDate: HunterTextField!
    @IBOutlet weak var txtIssueBy: HunterTextField!
    @IBOutlet weak var tv_desc: UITextView!
    @IBOutlet weak var btnAddAcheive: UIButton!

    var langDict = NSDictionary()
        var level_of_prof = NSDictionary()
     
        struct selectionData{
            var issueDate = ""
             
            
        }
        var selectedData = selectionData()
        @IBAction func addAcheive(_ sender: Any) {
            
            
            
            
                   if HunterUtility.isConnectedToInternet(){
                       let url = API.candidateBaseURL + API.saveAchievementsURL
                       print(url)
                       HunterUtility.showProgressBar()
//                       title
//                       issued_by
//                       issued_date
//                       description
                       let headers    = [ "Authorization" : "Bearer " + accessToken]
                    let parameters = ["title" : txtTitle.text! , "issued_by" : txtIssueBy.text! , "description" : tv_desc.text! , "issued_date" : Int(txtIssueDate.text!)! ] as [String : Any]
                       Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                           
                           switch response.result {
                           case .success:
                               if let responseDict = response.result.value as? NSDictionary{
                                   print(responseDict)
                                   SVProgressHUD.dismiss()
                                   if let status = responseDict.value(forKey: "status"){
                                    if status as! Int == 1{
                                        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterAchieveListVC") as! HunterAchieveListVC
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
        @IBAction func back(_ sender: Any) {
            _ = navigationController?.popViewController(animated: true)
            
            
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            txtIssueDate.delegate = self
 
             updateUI()
            // Do any additional setup after loading the view.
        }
        func updateUI() {
            if txtTitle.text != "" && txtIssueDate.text != ""  && txtIssueBy.text != ""  && tv_desc.text != ""   {
                          self.btnAddAcheive.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
                        self.btnAddAcheive.backgroundColor = UIColor.init(hexString:"6B3E99" )
                    }else{
                        self.btnAddAcheive.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
                        self.btnAddAcheive.backgroundColor = UIColor.init(hexString:"E9E4F2" )
                    }
                }
        

 
 
 
        func showSelectionViewController(type : String)  {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
            
            switch type {
            case "language":
                HunterSelectionViewController.passedDict = self.langDict
                HunterSelectionViewController.headerText = "Select Level Of Language"

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
    extension HunterAchieveVC : hunterDelegate{
        func selectedData(selectedDict: NSDictionary, isFrom: String) {
            switch isFrom{
                
            case  "IssueDate":
                txtIssueDate.text = selectedDict["selectedYear"] as? String ?? ""
                selectedData.issueDate = selectedDict["selectedYear"] as! String
                
             
                
            default:
                break
                
                
            }
            updateUI()
            
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
    extension HunterAchieveVC : UITextFieldDelegate{
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            updateUI()

            switch textField {
            case txtIssueDate:
                showPickerViewController(type: "IssueDate")
                
            default:
                break
            }
            return false
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


