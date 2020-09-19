//
//  HunterLoginVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/24/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterLoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textUsername: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnIsSaveCredential: UIButton!
    var loginType = String()
    let rightButton  = UIButton(type: .custom)
    var isSaveCredential = false{
        didSet{
            if isSaveCredential{
                btnIsSaveCredential.setImage(UIImage(named: "CircleFill"), for: .normal)
                
            }else{
                btnIsSaveCredential.setImage(UIImage(named: "Circle"), for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        if UserDefaults.standard.object(forKey: "credential") != nil{
            let credentialDict = UserDefaults.standard.dictionary(forKey: "credential")!
            if loginType == credentialDict["loginType"] as! String{
                textUsername.text = credentialDict["Uname"] as? String ?? ""
                textPassword.text = credentialDict["password"] as? String ?? ""
                 isSaveCredential = true
            }else{
                isSaveCredential = false
                textUsername.text = ""
                textPassword.text = ""
            }
        }else{
            isSaveCredential = false
            textUsername.text = ""
            textPassword.text = ""
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:-20, y:0, width:40, height:30)

        textPassword.rightViewMode = .always
        textPassword.rightView = rightButton
        textPassword.isSecureTextEntry = true
    }
    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }

    func toggle() {
        textPassword.isSecureTextEntry = !textPassword.isSecureTextEntry
        if textPassword.isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password_show") , for: .normal)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func btnLoginClick(_ sender: Any) {
        if textUsername.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Username should not be empty!!")
        }else if textPassword.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password cannot be empty!!")
        }else{
            self.connectToLogin()
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnForgotPass(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterForgotPassVC") as! HunterForgotPassVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSignUpAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterVC") as! HunterRegisterVC
        vc.loginType = loginType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionRememberMe(_ sender: Any) {
        self.isSaveCredential = !isSaveCredential
    }
    
    
    //MARK:- Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //MARK:- Webservice
    func connectToLogin(){
        if HunterUtility.isConnectedToInternet(){
            let paramsDict = ["email": textUsername.text ?? "", "password": textPassword.text ?? ""]
            print(paramsDict)
            var url = String()
            if loginType == "candidate"{
                url = API.candidateBaseURL + API.loginURl
            }else{
                url = API.recruiterBaseURL + API.loginURl
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
                            if self.isSaveCredential{
                                let saveForType = ["Uname" : self.textUsername.text ?? "" ,"password" : self.textPassword.text ?? "", "loginType" : self.loginType]
                                UserDefaults.standard.set(saveForType, forKey: "credential")
                            }else{
                                UserDefaults.standard.set(nil, forKey: "credential")
                            }
                            
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
                                            }else if registration_step == 2 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkLocVC") as! HunterWorkLocVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 3 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterJobFuncVC") as! HunterJobFuncVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 4 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterSkillSetVC") as! HunterSkillSetVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 5 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterUAEExpVC") as! HunterUAEExpVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 6 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterUAETwoExpVC") as! HunterUAETwoExpVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 7 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterCurrentWorkStatusVC") as! HunterCurrentWorkStatusVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                        }else {
                                            if registration_step ==  1 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompVC") as! HunterRegisterCompVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 2 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompOneVC") as! HunterRegisterCompOneVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 3 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompTwoVC") as! HunterRegisterCompTwoVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else if registration_step == 4 {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCodeVC") as! HunterRegisterCodeVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }else {
                                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterRegisterCompTwoVC") as! HunterRegisterCompTwoVC
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
                                        }
                                    }else if registration_status == 0{
                                        if self.loginType == "candidate"{
                                            let vc = UIStoryboard(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
                                            vc.modalPresentationStyle = .overFullScreen
                                            
                                            self.present(vc, animated: true, completion: nil)
                                        }else{
                                            let vc = UIStoryboard(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
                                            vc.modalPresentationStyle = .overFullScreen
                                            
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                }else{
                                    if self.loginType == "candidate"{
                                        let vc = UIStoryboard(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
                                        vc.modalPresentationStyle = .overFullScreen
                                        
                                        self.present(vc, animated: true, completion: nil)
                                    }else{
                                        let vc = UIStoryboard(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
                                        vc.modalPresentationStyle = .overFullScreen
                                        
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }else{
                                HunterUtility.notifiyUser(viewController: self, title: "", message: responseDict.value(forKey: "message") as? String ?? "Something went wrong!!")
                            }
                        }
                        else{
                            HunterUtility.notifiyUser(viewController: self, title: "", message: responseDict.value(forKey: "message") as? String ?? "Something went wrong!!")
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
