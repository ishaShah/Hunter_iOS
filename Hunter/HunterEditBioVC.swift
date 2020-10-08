//
//  HunterEditBioVC.swift
//  Hunter
//
//  Created by Zubin Manak on 20/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterEditBioVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var lblCharacterCount: UILabel!
    @IBOutlet weak var contBtn: UIButton!
    @IBOutlet weak var txt_view: UITextView!
    var profileDelegate : refreshProfileDelegate!
    var txt = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_view.text = txt
        self.txt_view.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        if txt_view.text.count == 0 {
            self.view.makeToast("Bio cannot be empty.")
        } else {
            connectToUpdateCompanyBio()
        }
    }
    func connectToUpdateCompanyBio(){
        if HunterUtility.isConnectedToInternet(){
            var loginType = String()
            var url = ""
            var paramsDict = [String : Any]()
            
            if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                loginType = type
            }
            // Do any additional setup after loading the view.
            if loginType == "candidate" {
                url = API.candidateBaseURL + API.updateCandidateBioURL
                paramsDict = ["bio": txt_view.text! ]
                
            }
            else {
                url = API.recruiterBaseURL + API.updateCompanyBioURL
                paramsDict = ["company_bio": txt_view.text! ]
                
            }
            print(url)
            HunterUtility.showProgressBar()
            
            
            
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
                                    self.profileDelegate.refetchFromCloud()
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
     
    //MARK:- Textview delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add a bio to your profile"{
            textView.text = ""
            textView.textColor = Color.darkVioletColor
        }
    }
        
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            lblCharacterCount.text = "0/100"
            textView.text = "Add a bio to your profile"
            textView.textColor = UIColor.officialApplePlaceholderGray
            
            self.contBtn.setTitleColor(UIColor.init(hexString:"300471" ), for: UIControl.State.normal)
            self.contBtn.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }else{
            if self.txt_view.text != "" && self.txt_view.text != "Add a bio to your profile"{
                self.contBtn.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
                self.contBtn.backgroundColor = UIColor.init(hexString:"6B3E99" )
            }else{
                self.contBtn.setTitleColor(UIColor.init(hexString:"300471" ), for: UIControl.State.normal)
                self.contBtn.backgroundColor = UIColor.init(hexString:"E9E4F2" )
            }
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
            lblCharacterCount.text = "\(newText.count)/100"
        }
        return isUnRestrict
    }
 

}
