//
//  HunterResetPasswordVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 10/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Toast_Swift

class HunterResetPasswordVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var textCurrentPassword: UITextField!
    @IBOutlet weak var textNewPassword: UITextField!
    @IBOutlet weak var textRepeatPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCancel(_ sender: UIButton) {
        textCurrentPassword.text = ""
        textNewPassword.text = ""
        textRepeatPassword.text = ""
    }
    @IBAction func buttonSave(_ sender: UIButton) {
        guard let currentPass = textCurrentPassword.text, currentPass.count > 0 else {
            self.view.makeToast("Current Password cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textCurrentPassword.becomeFirstResponder()
            return
        }
        guard let newPass = textNewPassword.text, newPass.count > 0 else {
            self.view.makeToast("New password cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textNewPassword.becomeFirstResponder()
            return
        }
        guard let confirmPass = textRepeatPassword.text, confirmPass.count > 0 else {
            self.view.makeToast("Repeat Password cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textRepeatPassword.becomeFirstResponder()
            return
        }
        if newPass != confirmPass{
            self.view.makeToast("New password and repeat password fields does not match", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            return
        }else{
            self.connectToResetPassword()
        }
    }
    //MARK:- Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //MARK: Webservice
    func connectToResetPassword(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.resetPasswordURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            
            let paramsDict = ["old_password": textCurrentPassword.text ?? "",
                              "password": textNewPassword.text ?? "",
                              "password_confirmation": textRepeatPassword.text ?? ""]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
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
                            }
                            else {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
