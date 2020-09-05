//
//  HunterReportAProblemVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 11/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterReportAProblemVC: UIViewController {
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    var arrayCategories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var loginType = String()
        if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
            loginType = type
        }
        // Do any additional setup after loading the view.
        if loginType == "candidate" {
        connectToGetCategories()
        }
        else {
            arrayCategories = ["Something Isn’t Working" , "Spam or Abuse" , "General Feedback" , "Review" ]
            self.button1.setTitle(self.arrayCategories[0], for: .normal)
            self.button2.setTitle(self.arrayCategories[1], for: .normal)
            self.button3.setTitle(self.arrayCategories[2], for: .normal)
            self.button4.setTitle(self.arrayCategories[3], for: .normal)
        }
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

        setNeedsStatusBarAppearanceUpdate()
            
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        if sender.tag == 1{
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterSomethingIsntWorkingVC") as! HunterSomethingIsntWorkingVC
            vc.categoryType = "0"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }else if sender.tag == 2{
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterSomethingIsntWorkingVC") as! HunterSomethingIsntWorkingVC
            vc.categoryType = "1"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }else if sender.tag == 3{
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterGeneralFeedbackVC") as! HunterGeneralFeedbackVC
            vc.categoryType = "2"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }else if sender.tag == 4{
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterSendReviewVC") as! HunterSendReviewVC
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    //MARK: Webservice
    func connectToGetCategories(){
        if HunterUtility.isConnectedToInternet(){
            var url = ""
            var loginType = String()
            if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                loginType = type
            }
            if loginType == "candidate" {
             url = API.candidateBaseURL + API.supportCategoriesURL
            }
            else {
//             url = API.recruiterBaseURL + API.reportErrorURL
            }
            
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                if let dataDict = responseDict.value(forKey: "data") as? [String]{
                                    self.arrayCategories = dataDict
                                    DispatchQueue.main.async {
                                        if self.arrayCategories.count == 4{
                                            self.button1.setTitle(self.arrayCategories[0], for: .normal)
                                            self.button2.setTitle(self.arrayCategories[1], for: .normal)
                                            self.button3.setTitle(self.arrayCategories[2], for: .normal)
                                            self.button4.setTitle(self.arrayCategories[3], for: .normal)
                                        }
                                    }
                                }
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
