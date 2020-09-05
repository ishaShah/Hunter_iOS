//
//  HunterChangePassVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/24/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterChangePassVC: UIViewController {
var code = String()
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textRePassword: UITextField!
    var loginType = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedBtn(_ sender: Any) {
        
        if isValidated(textPassword.text!) == false {
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password must contain at least 8 characters including Upper/lower case and number.")
        }
        else if textPassword.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password cannot be empty!!")
        }else if textRePassword.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Re-type password cannot be empty!!")
        }else if textRePassword.text != textPassword.text{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Password do not macth!!")
        }else{
            self.connectToCreateNewPassword()
        }
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
    func connectToCreateNewPassword(){
        if HunterUtility.isConnectedToInternet(){
            let paramsDict = [ "password": textPassword.text ?? "", "password_confirmation": textRePassword.text ?? "", "code": code]
            print(paramsDict)
            
            
            //commented by ajith
            let loginType = UserDefaults.standard.object(forKey: "loginType") as? String
            
            var url = String()
            
            if loginType == "candidate" {
                url = API.candidateBaseURL + API.createNewPassURL
            }
            else {
                url = API.recruiterBaseURL + API.createNewPassURL
                
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
                             if status == 1 {
                                SVProgressHUD.dismiss()
                                HunterUtility.notifiyUser(viewController: self, title: "", message: responseDict.value(forKey: "message") as? String ?? "Something went wrong!!")
                                
                                UserDefaults.standard.removeObject(forKey: "accessToken")
                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
                                
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
                                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
                                navigationController.viewControllers = [mainRootController]
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController = navigationController
                            }
                            else if status == 2 {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                                print("Logout api")
                                
                                UserDefaults.standard.removeObject(forKey: "accessToken")
                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
 
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
