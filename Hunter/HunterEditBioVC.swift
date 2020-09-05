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

class HunterEditBioVC: UIViewController {

    @IBOutlet weak var contBtn: UIButton!
    @IBOutlet weak var txt_view: UITextView!
    
    var txt = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_view.text = txt
        
        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        if txt_view.text.count != 0 {
            self.view.makeToast("Bio cannot be empty.")
        } else {
         connectToUpdateCompanyBio()
        }
    }
    func connectToUpdateCompanyBio(){
            if HunterUtility.isConnectedToInternet(){
                
                let url = API.recruiterBaseURL + API.updateCompanyBioURL
                print(url)
                HunterUtility.showProgressBar()
                
                
                let paramsDict = ["company_bio": txt_view.text! ] as [String : Any]
                
                let headers    = [ "Authorization" : "Bearer " + accessToken]
                
                Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        if let responseDict = response.result.value as? NSDictionary{
                            print(responseDict)
                            SVProgressHUD.dismiss()
                            if let status = responseDict.value(forKey: "status"){
                                if status as! Int == 1   {
                                    self.dismiss(animated: true, completion: nil)

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
