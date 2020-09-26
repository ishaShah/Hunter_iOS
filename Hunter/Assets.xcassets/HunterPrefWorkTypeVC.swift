//
//  HunterPrefWorkTypeVC.swift
//  Hunter
//
//  Created by Zubin Manak on 11/11/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterPrefWorkTypeVC: UIViewController {
    @IBOutlet weak var contButton: UIButton!

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var labelPreferredSalary: UILabel!
    @IBOutlet weak var labelPreferedSalary1: UILabel!
    @IBOutlet weak var labelPreferedSalary2: UILabel!
    @IBOutlet weak var labelPreferedSalary3: UILabel!

    
//    @IBOutlet weak var sliderSalary: UISlider!
//    @IBOutlet weak var sliderSalary1: UISlider!
//    @IBOutlet weak var sliderSalary2: UISlider!
//    @IBOutlet weak var sliderSalary3: UISlider!

    @IBOutlet weak var slider1: UIStackView!
    @IBOutlet weak var slider2: UIStackView!
    @IBOutlet weak var slider3: UIStackView!
    @IBOutlet weak var slider4: UIStackView!
    
    @IBOutlet weak var slider1Ht: NSLayoutConstraint!
    @IBOutlet weak var slider2Ht: NSLayoutConstraint!
    @IBOutlet weak var slider3Ht: NSLayoutConstraint!
    @IBOutlet weak var slider4Ht: NSLayoutConstraint!

    
    
    var selectedWorkType = -1
    var preferredSalary = Int()
    var arrayJobTypes = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectToRegisterPreferedWorkType()
        
 
         
        slider1.isHidden = true
        slider2.isHidden = true
        slider3.isHidden = true
        slider4.isHidden = true
        
        slider1Ht.constant = 0
        slider2Ht.constant = 0
        slider3Ht.constant = 0
        slider4Ht.constant = 0
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
 
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func showPickerViewController(index : Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HunterPickerViewController = storyboard.instantiateViewController(withIdentifier: "HunterPickerViewController") as! HunterPickerViewController
        HunterPickerViewController.isFrom =  "PrefWorkType"
        HunterPickerViewController.index =  index
        
        
        var anyDict = [String: String?]()

          for (key, value) in self.salary_rangeDict {
              anyDict[key as! String] = value as! String
          }
           
           
          
           let sortedYourArray = anyDict.sorted( by: { $0.0 < $1.0 })
           print(sortedYourArray)
          
          var jsonError : NSError?
          let jsonData = try? JSONSerialization.data(withJSONObject: anyDict, options: .prettyPrinted)
          // Verifying it worked:
        self.salary_rangeDict = try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSDictionary
        
        
        
        
        HunterPickerViewController.passedDict = self.salary_rangeDict
        HunterPickerViewController.delegate = self
        HunterPickerViewController.modalPresentationStyle = .overFullScreen
        self.present(HunterPickerViewController, animated: true, completion: nil)
    }
    @IBAction func selectWorkType(_ sender: UIButton) {
        
        
        
        
        selectedWorkType = sender.tag
         showPickerViewController(index: selectedWorkType)
    }
    
    @IBAction func continueBtn(_ sender: Any) {
        if selectedWorkType != -1{
            self.connectToRegisterSavePreferedWorkType()
        }else{
            let alert = UIAlertController(title: "", message:
                "Please select your preferred work type to proceed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Webservice
    var salary_rangeDict = NSDictionary()
    func connectToRegisterPreferedWorkType(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.registerPreferedWorkTypeURL
            print(url)
            HunterUtility.showProgressBar()

            let headers = ["Authorization" : "Bearer " + accessToken]

            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                                  let lookup_data = dataDict.value(forKey: "lookup_data") as? NSDictionary
                                    let work_type = lookup_data!.value(forKey: "work_type") as? NSDictionary
                                    self.arrayJobTypes = work_type!.allValues as! [String]
                                    print(dataDict.allValues)
                                        if self.arrayJobTypes.count == 4{
                                            self.button1.setTitle((work_type!.value(forKey: "1") as! String), for: .normal)
                                            self.button1.tag = 1
                                            self.button2.setTitle((work_type!.value(forKey: "2") as! String), for: .normal)
                                            self.button2.tag = 2

                                            self.button3.setTitle((work_type!.value(forKey: "3") as! String), for: .normal)
                                            self.button3.tag = 3

                                            self.button4.setTitle((work_type!.value(forKey: "4") as! String), for: .normal)
                                            self.button4.tag = 4

                                        }
//
 
                                    
                                    self.salary_rangeDict = (lookup_data!.value(forKey: "salary_range") as? NSDictionary)!
                                     
                                    
                                    print(dataDict.allValues)
                                        
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
    func connectToRegisterSavePreferedWorkType(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.registerSavePreferedWorkTypeURL
            print(url)
            HunterUtility.showProgressBar()
            let paramsDict = ["preferred_work_type": selectedWorkType , "salary_range_id": preferredSalary ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1    {
                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkLocVC") as! HunterWorkLocVC
                                self.navigationController?.pushViewController(vc, animated: true)
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
extension HunterPrefWorkTypeVC : hunterDelegate{
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        if !selectedDict.allKeys.isEmpty {
            
        
            let txtSalaryRange = selectedDict["name"] as? String ?? ""
            let salary_range_ID = Int(selectedDict["id"] as! String)
            let index = selectedDict["index"] as! Int
        if index == 1 {
        self.labelPreferredSalary.text = "\(txtSalaryRange)"
            self.preferredSalary = salary_range_ID!
        }
        else if index == 2 {
            self.labelPreferedSalary1.text = "\(txtSalaryRange)"
            self.preferredSalary = salary_range_ID!
        }
        else if index == 3 {
            self.labelPreferedSalary2.text = "\(txtSalaryRange)"
            self.preferredSalary = salary_range_ID!
        }
        else if index == 4 {
            self.labelPreferedSalary3.text = "\(txtSalaryRange)"
            self.preferredSalary = salary_range_ID!
        }
        
            selectedWorkType = index
            contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            
            contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
            if selectedWorkType == 1 {
            
                button1.setTitleColor(UIColor.init(hexString:"FFFFFF" ), for: UIControl.State.normal)
                button2.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button3.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button4.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                
                button1.backgroundColor = UIColor.init(hexString:"6B3E99" )
                button2.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button3.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button4.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                
                slider1.isHidden = false
                slider2.isHidden = true
                slider3.isHidden = true
                slider4.isHidden = true
                
                slider1Ht.constant = 30
                slider2Ht.constant = 0
                slider3Ht.constant = 0
                slider4Ht.constant = 0

                

            }
            else if selectedWorkType == 2 {
                button2.setTitleColor(UIColor.init(hexString:"FFFFFF" ), for: UIControl.State.normal)
                button1.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button3.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button4.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                
                button2.backgroundColor = UIColor.init(hexString:"6B3E99" )
                button1.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button3.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button4.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                
                slider1.isHidden = true
                slider2.isHidden = false
                slider3.isHidden = true
                slider4.isHidden = true
                
                slider1Ht.constant = 0
                slider2Ht.constant = 30
                slider3Ht.constant = 0
                slider4Ht.constant = 0
            }
            else if selectedWorkType == 3 {
                button3.setTitleColor(UIColor.init(hexString:"FFFFFF" ), for: UIControl.State.normal)
                button1.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button2.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button4.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                
                button3.backgroundColor = UIColor.init(hexString:"6B3E99" )
                button1.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button2.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button4.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                
                slider1.isHidden = true
                slider2.isHidden = true
                slider3.isHidden = false
                slider4.isHidden = true
                
                slider1Ht.constant = 0
                slider2Ht.constant = 0
                slider3Ht.constant = 30
                slider4Ht.constant = 0
            }
            else if selectedWorkType == 4 {
                button4.setTitleColor(UIColor.init(hexString:"FFFFFF" ), for: UIControl.State.normal)
                button1.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button2.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
                button3.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)

                button4.backgroundColor = UIColor.init(hexString:"6B3E99" )
                button1.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button2.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                button3.backgroundColor = UIColor.init(hexString:"FFFFFF" )
                
                slider1.isHidden = true
                slider2.isHidden = true
                slider3.isHidden = true
                slider4.isHidden = false
                
                slider1Ht.constant = 0
                slider2Ht.constant = 0
                slider3Ht.constant = 0
                slider4Ht.constant = 30
            }
        }
    }
        
    }

