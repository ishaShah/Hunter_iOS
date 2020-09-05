//
//  HunterRegisterCodeVC.swift
//  Hunter
//
//  Created by Zubin Manak on 10/3/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import SVProgressHUD

class HunterRegisterCodeVC: UIViewController, UITextFieldDelegate  {
    @IBOutlet var textFieldsOutletCollection: [UITextField]!
    @IBOutlet weak var contButton: UIButton!
    
    var textFieldsIndexes:[UITextField:Int] = [:]

    @IBOutlet weak var viewInvalid: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInvalid.isHidden = true
        
        viewInvalid.layer.shadowPath = UIBezierPath(rect: viewInvalid.bounds).cgPath
        viewInvalid.layer.shadowRadius = 12
        viewInvalid.layer.shadowOffset = CGSize(width: 0, height: 1)
        viewInvalid.layer.shadowOpacity = 0.3
        viewInvalid.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    
        for index in 0 ..< textFieldsOutletCollection.count {
            textFieldsIndexes[textFieldsOutletCollection[index]] = index
        }
    }
    
    enum Direction { case left, right }
    
    func setNextResponder(_ index:Int?, direction:Direction) {
        
        guard let index = index else { return }
        
        if direction == .left {
            index == 0 ?
                (_ = textFieldsOutletCollection.first?.resignFirstResponder()) :
                (_ = textFieldsOutletCollection[(index - 1)].becomeFirstResponder())
        } else {
            index == textFieldsOutletCollection.count - 1 ?
                (_ = textFieldsOutletCollection.last?.resignFirstResponder()) :
                (_ = textFieldsOutletCollection[(index + 1)].becomeFirstResponder())
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.length == 0 {
            textField.text = string
            setNextResponder(textFieldsIndexes[textField], direction: .right)
            return true
        } else if range.length == 1 {
            textField.text = ""
            setNextResponder(textFieldsIndexes[textField], direction: .left)
            return false
        }
        
        return false
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        code = ""
        for textF in textFieldsOutletCollection {
            code = code + textF.text!
        }
        if code.count == 4{
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }else{
            self.contButton.setTitleColor(UIColor.init(hexString:"300471" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
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
    var code = ""
    @IBAction func continueBtn(_ sender: Any) {
        code = ""
        for textF in textFieldsOutletCollection {
            code = code + textF.text!
        }
        if code.count == 4 {
            connectToRegisterVerifyCompanyURL()
        }else{
            self.view.makeToast("Please enter a valid code.")
        }
    
    }
    func connectToRegisterVerifyCompanyURL(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.registerVerifyCompanyURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            var code = ""
            for textF in textFieldsOutletCollection {
                code = code + textF.text!
            }
            let paramsDict = ["code": code ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pushToTabBar), userInfo: nil, repeats: false)

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
                                else if status as! Int == 0 {
                                    let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                    }))
                                    self.present(alert, animated: true, completion: nil)
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
    @objc func pushToTabBar() {
        
        
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterAllJobsViewController") as! HunterAllJobsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
//        let vc = UIStoryboard(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
//        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
