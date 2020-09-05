//
//  HunterForgotPassVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/24/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterForgotPassVC: UIViewController {

    var loginType = String()
    @IBOutlet weak var textUsername: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedBtn(_ sender: Any) {
        if textUsername.text == ""{
            HunterUtility.notifiyUser(viewController: self, title: "", message: "Email ID cannot be empty!!")
        }
        else {
        connectToForgotPasswrd()
        }
    }
    //MARK:- Webservice
    func connectToForgotPasswrd(){
        if HunterUtility.isConnectedToInternet(){
            let paramsDict = ["email": self.textUsername.text ?? ""]
            print(paramsDict)
            var url = String()
            if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                loginType = type
            }
            if loginType == "candidate"{
                url = API.candidateBaseURL + API.forgotPasswordURL
            }else{
                url = API.recruiterBaseURL + API.forgotPasswordURL
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
                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterSecrectCodeVC") as! HunterSecrectCodeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }else{
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
