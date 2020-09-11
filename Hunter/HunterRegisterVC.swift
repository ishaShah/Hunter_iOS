//
//  HunterRegisterVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/24/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterRegisterVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFirstname: UITextField!
    @IBOutlet weak var textLastname: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textRePassword: UITextField!
    var loginType = String()
    
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var phoneStcakHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        if loginType == "candidate" {
            phoneStackView.isHidden = true
//            phoneStcakHeight.constant = 0
        }
        else {
           phoneStackView.isHidden = false
//            phoneStcakHeight.constant = 67.5
        }
            setNeedsStatusBarAppearanceUpdate()
            
        }
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    //MARK:- Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
//    @IBAction func buttonRegister(_ sender: UIButton){
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterPrefWorkTypeVC") as! HunterPrefWorkTypeVC
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonRegister(_ sender: UIButton) {
        if textFirstname.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "First name should not be empty!!")
        }else if textLastname.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Last name cannot be empty!!")
        }else if textEmail.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Email ID cannot be empty!!")
        }
        else if (textEmail.text?.isValidEmail())! == false {
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Please enter valid Email ID!!")
        }
/*        else if textPhone.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Phone number cannot be empty!!")
        }*/
             
        else if isValidated(textPassword.text!) == false {
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password must contain at least 8 characters including Upper/lower case and number.")
        }
        else if textPassword.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password cannot be empty!!")
        }else if textRePassword.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Re-type password cannot be empty!!")
        }else if textRePassword.text != textPassword.text{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password do not macth!!")
        }else{
            self.connectToRegisterCandidate()
        }
    }
    @IBAction func backToLogin(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func isValidated(_ password: String) -> Bool {
        var lowerCaseLetter: Bool = false
        var upperCaseLetter: Bool = false
        var digit: Bool = false
        var specialCharacter: Bool = false

        if password.count  >= 8 {
            for char in password.unicodeScalars {
                if !lowerCaseLetter {
                    lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
                }
                if !upperCaseLetter {
                    upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
                }
                if !digit {
                    digit = CharacterSet.decimalDigits.contains(char)
                }
                if !specialCharacter {
                    specialCharacter = CharacterSet.punctuationCharacters.contains(char)
                }
            }
            if specialCharacter || (digit && lowerCaseLetter && upperCaseLetter) {
                //do what u want
                return true
            }
            else {
                return false
            }
        }
        return false
    }
   
//    public func isValidPassword(mypassword : String) -> Bool {
//        
//        
//        
//        
//        
//        
//        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
//        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//
//        return passwordtesting.evaluate(with: mypassword)
//    }
    //MARK:- Webservice
    func connectToRegisterCandidate(){
        if HunterUtility.isConnectedToInternet(){
            var paramsDict = ["first_name": textFirstname.text ?? "", "last_name": textLastname.text ?? "", "email": textEmail.text ?? "", "password": textPassword.text ?? "", "password_confirmation": textRePassword.text ?? ""]
            print(paramsDict)
            
            
//commented by ajith
//            let loginType = UserDefaults.standard.object(forKey: "loginType") as? String
            
            var url = String()
            
            if loginType == "candidate" {
                url = API.candidateBaseURL + API.registerCandidateURL
            }
            else {
                url = API.recruiterBaseURL + API.registerRecruiterURL
                paramsDict = ["first_name": textFirstname.text ?? "", "last_name": textLastname.text ?? "", "email": textEmail.text ?? "", "password": textPassword.text ?? "", "password_confirmation": textRePassword.text ?? "", "phone_number": textPhone.text ?? ""]
            }
            print(url)
            HunterUtility.showProgressBar()
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        let status = responseDict.value(forKey: "status") as! Int
                        if let token = responseDict.value(forKey: "access_token") as? String{
                            UserDefaults.standard.set(token, forKey: "accessToken")
                            UserDefaults.standard.set(self.loginType, forKey: "loginType")
                            accessToken = token
                            
                            if status == 1 {
                                if let val = responseDict["data"] {
                                    // now val is not nil and the Optional has been unwrapped, so use it
                                    let dictVal = val as! NSDictionary
                                    let registration_status = dictVal["registration_status"] as! Int
                                    let registration_step = dictVal["registration_step"] as! Int
                                    
                                    if registration_status == 1 {
                                        if self.loginType == "candidate" {
                                            if registration_step ==  1 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterPrefWorkTypeVC") as! HunterPrefWorkTypeVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 2 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkLocVC") as! HunterWorkLocVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 3 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterNativeLocVC") as! HunterNativeLocVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 4 {
                                               let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterJobFuncVC") as! HunterJobFuncVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 5 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterSkillSetVC") as! HunterSkillSetVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 6 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterUAEExpVC") as! HunterUAEExpVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 7 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterCurrentWorkStatusVC") as! HunterCurrentWorkStatusVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 8 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterEducationStep1VC") as! HunterEducationStep1VC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                            else if registration_step == 9 {
                                                let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditProPicVC") as! HunterEditProPicVC
                                                vc.isFrom = "candidateReg"
                                                self.navigationController?.pushViewController(vc, animated: true)
                                                
                                                
                                            }
                                            
                                            
                                           
                                        }
                                        else {
                                        if registration_step ==  1 {
                                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompVC") as! HunterRegisterCompVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else if registration_step == 2 {
                                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompOneVC") as! HunterRegisterCompOneVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else if registration_step == 3 {
                                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompTwoVC") as! HunterRegisterCompTwoVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else if registration_step == 4 {
                                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCodeVC") as! HunterRegisterCodeVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else {
                                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompTwoVC") as! HunterRegisterCompTwoVC
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        }
                                    }
                                }
                                else {
                                
                                    if self.loginType == "candidate" {
                                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterPrefWorkTypeVC") as! HunterPrefWorkTypeVC
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else {
                                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompVC") as! HunterRegisterCompVC
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                
                            
                            
                        }
                        }
                            else if status == 2 {
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
                        SVProgressHUD.dismiss()
                            HunterUtility.notifiyUser(viewController: self, title: "", message: responseDict.value(forKey: "message") as? String ?? "Something went wrong!!")
                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
                    }
                    }
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    HunterUtility.notifiyUser(viewController: self, title: "", message: error.localizedDescription)
                }
            }
        }else{
            print("no internet")
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

}
