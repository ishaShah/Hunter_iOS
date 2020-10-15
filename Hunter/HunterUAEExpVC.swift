//
//  HunterUAEExpVC.swift
//  Hunter
//
//  Created by Zubin Manak on 11/11/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterUAEExpVC: UIViewController {
    @IBOutlet weak var contButton: UIButton!

    var currentWorkStatus = -1
    @IBOutlet weak var btn_wrkExp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
     
    @IBAction func continueBtn(_ sender: Any) {
        if currentWorkStatus == -1 || currentWorkStatus == 0 {
            let alert = UIAlertController(title: "", message:
                "Please select an option to proceed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterEducationStep1VC") as! HunterEducationStep1VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func addWorkExp(_ sender: Any){
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkExpVC") as! HunterWorkExpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    @IBAction func workExp(_ sender: Any) {
        
        if currentWorkStatus == 1 {
            
            currentWorkStatus = 0
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
            btn_wrkExp.backgroundColor = UIColor.white
        
        }
        else {
            currentWorkStatus = 1
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
                btn_wrkExp.backgroundColor = UIColor.init(hexString:"6B3E99" )


        }
        updateUIforSelection()
    }
    
    
    func updateUIforSelection() {
        if currentWorkStatus == 1{
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }else{
            self.contButton.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }
        
    }
    func connectToSaveWorkedInUAE(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.saveWorkedInUAEURL
            print(url)
            HunterUtility.showProgressBar()
            let paramsDict = ["worked_in_uae": currentWorkStatus ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                if  self.currentWorkStatus == 0 {
                                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterCurrentWorkStatusVC") as! HunterCurrentWorkStatusVC
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else {
                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterUAETwoExpVC") as! HunterUAETwoExpVC
                                self.navigationController?.pushViewController(vc, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
