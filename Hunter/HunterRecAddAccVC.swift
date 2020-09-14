
//
//  HunterRecAddAccVC.swift
//  Hunter
//
//  Created by Zubin Manak on 08/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterRecAddAccVC: UIViewController {
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textLastName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPhone: UITextField!
    @IBOutlet weak var textPass: UITextField!
    @IBOutlet weak var textRePass: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
       // connectToGetBasicInfo()
    }
    @IBAction func buttonBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonSaveProfile(_ sender: UIButton) {
        guard let firstName = textFirstName.text, firstName.count > 0 else {
            self.view.makeToast("First name cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textFirstName.becomeFirstResponder()
            return
        }
        guard let lastName = textLastName.text, lastName.count > 0 else {
            self.view.makeToast("Last name cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textLastName.becomeFirstResponder()
            return
        }
        guard let email = textEmail.text, email.count > 0 else {
            self.view.makeToast("Email cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textEmail.becomeFirstResponder()
            return
        }
        guard let phone = textPhone.text, phone.count > 0 else {
            self.view.makeToast("Phone cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textPhone.becomeFirstResponder()
            return
        }
        guard let pass = textPass.text, pass.count > 0 else {
            self.view.makeToast("Password cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textPass.becomeFirstResponder()
            return
        }
        guard let repass = textRePass.text, repass.count > 0 else {
            self.view.makeToast("RePassword cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
            textRePass.becomeFirstResponder()
            return
        }
        connectToUpdateBasicInfo()
    }
    func connectToUpdateBasicInfo(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.createSubAccURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]

 
//            first_name
//            last_name
//            email
//            phone_number
//            password
//            password_confirmation
             
             
                    



             

            let parameters = [ "first_name" : textFirstName.text! , "last_name" : textLastName.text! , "email" : textEmail.text! , "phone_number" : textPhone.text! , "password" : textPass.text! , "password_confirmation" : textRePass.text!]

//            first_name
//            last_name
//            email
//            phone_number
//            password
//            password_confirmation
            
            
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                //   self.connectToGetSettingsData()
                                self.dismiss(animated: true, completion: nil)
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
                            else{
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
extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(hexString: "371F77").cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
