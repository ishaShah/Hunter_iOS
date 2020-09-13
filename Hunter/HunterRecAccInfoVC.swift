//
//  HunterRecAccInfoVC.swift
//  Hunter
//
//  Created by Zubin Manak on 07/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterRecAccInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableAccInfo: UITableView!

    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var sadView: UIView!
    @IBOutlet weak var disableAcc: UIView!
    
    var sub_accounts = [NSDictionary]()

    var notifyStatus = Int()
     override func viewDidLoad() {
        super.viewDidLoad()
        disableAcc.isHidden = true
        sadView.isHidden = true
        tableAccInfo.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    func autosizeTableView(){
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.tableAccInfo.layoutIfNeeded()
            self.tableAccInfo.needsUpdateConstraints()
        }
    }
    @IBAction func sendSadView(_ sender: Any) {
    }
    @IBAction func skipSadView(_ sender: Any) {
    }
    @IBAction func disableAccYes(_ sender: Any) {
    }
    @IBAction func disableAccNo(_ sender: Any) {
    }
    @IBAction func addAccount(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterRecAddAccVC") as! HunterRecAddAccVC
        self.present(vc, animated: true, completion: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        connectToGetSubAccounts()
    }
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sub_accounts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterRecAccInfoCollectionCell", for: indexPath) as! HunterRecAccInfoCollectionCell
        tableView.separatorStyle = .none
        cell.selectionStyle = .none
        cell.switchChange.tag = indexPath.row
        cell.switchChange.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        let firstName = sub_accounts[indexPath.row]["first_name"] as! String
        let lastName = sub_accounts[indexPath.row]["last_name"] as! String
        cell.labelTitle.text = firstName + lastName
        
        if let account_status = sub_accounts[indexPath.row]["account_status"] as? Int{
            if account_status == 1{
                cell.switchChange.isOn = true
            }else{
                cell.switchChange.isOn = false
            }
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterProfileVC") as! HunterProfileVC
            self.present(vc, animated: true, completion: nil)
        case 1:
            print("privacy information page here")
        case 2:
            print("Turn Notification On/Off here")
        case 3:
            print("Turn show me on hunter On/Off here")
        case 4:
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterHelpAndSupportVC") as! HunterHelpAndSupportVC
            self.present(vc, animated: true, completion: nil)
        case 5: break
            //            imageBGPopup.isHidden = false
            //            viewPopup.isHidden = false
            //            viewPopupAccDisabled.isHidden = true
            //            imagePopUpIcon.image = UIImage(named: "")
            //            labelPopUpTitle.text = "Disable Account"
            //            isLogout = false
        //            labelPopUpMessage.text = "Are you sure you would like to disable your Hunter Account"
        case 6: break
            //            imageBGPopup.isHidden = false
            //            viewPopup.isHidden = false
            //            viewPopupAccDisabled.isHidden = true
            //            imagePopUpIcon.image = UIImage(named: "")
            //            labelPopUpTitle.text = "Logout"
            //            isLogout = true
        //            labelPopUpMessage.text = "Are you sure you would like to Log Out?"
        default:
            print("default case")
        }
    }
    @IBAction func changeSwitch(_ sender: UISwitch) {
        if let status = sub_accounts[sender.tag].value(forKey: "account_status") as? Int{
            if status == 1{
                connectToDisAbleAccounts(0, sub_accounts[sender.tag].value(forKey: "id") as! Int)
            }else{
                connectToDisAbleAccounts(1, sub_accounts[sender.tag].value(forKey: "id") as! Int)
            }
        }
        
    }
    func connectToGetSubAccounts(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.recruiterBaseURL + API.getSettingsSubAccURL
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
                            
                            if status as! Int == 1{
                                let dataDict = responseDict.value(forKey: "data") as! NSDictionary
                                let sub_acc = dataDict.value(forKey: "sub_accounts") as? [NSDictionary]
                                
                                
                                if sub_acc!.count > 0 {
                                    self.sub_accounts = sub_acc!
                                    self.tableAccInfo.reloadData()
                                    self.autosizeTableView()
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
    func connectToDisAbleAccounts(_ change : Int, _ account: Int){
        if HunterUtility.isConnectedToInternet(){
            var url = ""
            url = API.recruiterBaseURL + API.getDisAbleSubAccURL
            
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["status": change, "account_id" : account ]
            print(paramsDict)
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                //   self.connectToGetSettingsData()
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
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
class HunterRecAccInfoCollectionCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var switchChange: UISwitch!
    
}
