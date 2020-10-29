
//
//  HunterSkillSetVC.swift
//  Hunter
//
//  Created by Zubin Manak on 11/11/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterSkillSetVC: UIViewController,hunterDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var contButton: UIButton!

    var skillsArr = [String]()
    var skillsIDArr = [Int]()
    @IBOutlet weak var lab_suggestions: UILabel!

    var selectedSkillsArr = [String]()
    var selectedSkillsIDArr = [Int]()
    
    @IBOutlet weak var txt_skill: HunterTextField!
    var isFrom = String()

    @IBOutlet weak var collView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        connectToRegisterPreferedSkills()
        updateUIforSelection()
    }
    override func viewWillAppear(_ animated: Bool) {
/*        let alignedFlowLayout = collView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.minimumLineSpacing = 5.0
        alignedFlowLayout?.minimumInteritemSpacing = 5.0
        alignedFlowLayout?.horizontalAlignment = .justified
        alignedFlowLayout?.verticalAlignment = .center*/
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left,
                                                                            verticalAlignment: .top)
                    alignedFlowLayout.minimumInteritemSpacing = 10
                    alignedFlowLayout.minimumLineSpacing = 10
                    collView.collectionViewLayout = alignedFlowLayout
//        collView.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
    }
    @IBAction func buttonRemoveFromSuggestions(_ sender: UIButton) {
        //add removed element to main array
        self.skillsArr.append(self.selectedSkillsArr[sender.tag])
        self.skillsIDArr.append(self.selectedSkillsIDArr[sender.tag])
        //remove particular element from selected array
        self.selectedSkillsArr.remove(at: sender.tag)
        self.selectedSkillsIDArr.remove(at: sender.tag)
        
        if (self.selectedSkillsArr.count == 0) {
            self.contButton.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
            
            self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }

        self.tblView.reloadData()

        self.collView.reloadData()
        
    }
    func updateUIforSelection() {
        if self.selectedSkillsArr.count != 0{
            self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
        }else{
            self.contButton.setTitleColor(UIColor.init(hexString:"350B76" ), for: UIControl.State.normal)
            self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        }
        
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func selectedData(selectedDict: NSDictionary, isFrom: String) {
        selectedSkillsArr = []
        selectedSkillsIDArr = []
        let selectedData = selectedDict["selectedData"] as! [NSDictionary]
        var name = ""
        
        for dict in selectedData{
            if name != ""{
                name = name + "," + "\(dict["name"] ?? "")"
            }else{
                name = dict["name"] as! String
            }
            
            
            selectedSkillsArr.append(dict["name"] as! String)
            
            let locID = Int(dict["id"] as! String)
            selectedSkillsIDArr.append(locID!)
            
        }
        
        
        self.txt_skill.text = ""
        self.tblView.reloadData()
        collView.reloadData()
        updateUIforSelection()
        print(selectedDict)
        
    }
               
           
       var dict_skill = NSDictionary()
       @IBAction func workLoc(_ sender: Any) {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let HunterSelectionViewController = storyboard.instantiateViewController(withIdentifier: "HunterSelectionViewController") as! HunterSelectionViewController
           HunterSelectionViewController.isMultiSelect = true
          HunterSelectionViewController.delegate = self
           HunterSelectionViewController.passedDict = dict_skill
           HunterSelectionViewController.isFrom = "location"
        HunterSelectionViewController.headerText = "Select Skills"

          HunterSelectionViewController.modalPresentationStyle = .overFullScreen
          self.present(HunterSelectionViewController, animated: true, completion: nil)
       }

    @IBAction func continueBtn(_ sender: Any) {
        if self.selectedSkillsIDArr.count != 0{
            self.connectToRegisterSavePreferedSkills()
        }else{
            let alert = UIAlertController(title: "", message:
                "Please select one or more skill sets to proceed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Webservice
    func connectToRegisterPreferedSkills(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.registerPreferedSkillsURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                let data = responseDict.value(forKey: "data") as! NSDictionary
                                print (data)
                                
                                self.dict_skill = data
                                
                                self.collView.reloadData()
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
                        }else{
                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
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
    func connectToRegisterSavePreferedSkills(){
        if HunterUtility.isConnectedToInternet(){
            
            var url = String()
            if isFrom == "Profile" {
                url =  API.candidateBaseURL + API.registerUpdateJobSkillsURL
            }
            else {
              url =  API.candidateBaseURL + API.registerSavePreferedSkillsURL
            }
            print(url)
            HunterUtility.showProgressBar()
            let paramsDict = ["job_skill_ids": selectedSkillsIDArr ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                if self.isFrom == "Profile" {
                                let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
                                self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else {
                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterUAEExpVC") as! HunterUAEExpVC
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
    // MARK: - Navigation
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return selectedSkillsArr.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 40
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HunterWorkLocTableViewCell", for: indexPath) as! HunterWorkLocTableViewCell
            tableView.separatorStyle = .none
            cell.selectionStyle = .none
            cell.titleLabel.text = selectedSkillsArr[indexPath.row].capitalized
            return cell
        }
}
extension HunterSkillSetVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.selectedSkillsArr.count == 0 {
//            return self.skillsArr.count
//        }
//        else {
            return self.selectedSkillsArr.count
//        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterWorkLocTwoCollectionCell", for: indexPath) as! HunterWorkLocTwoCollectionCell
//        if self.selectedSkillsArr.count == 0 {
//
//            cell.titleLabel.text = skillsArr[indexPath.item].uppercased()
//            cell.buttonRemove.isHidden = true
//
//            cell.titleLabel.textColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
//            cell.backgroundColor = UIColor.init(red: 232.0/255.0, green: 228.0/255.0, blue: 242.0/255.0, alpha: 1.0)
//
//
//        }
//        else {
            cell.buttonRemove.isHidden = false
            
            cell.titleLabel.text = selectedSkillsArr[indexPath.item].capitalized
            cell.buttonRemove.tag = indexPath.item
            
            cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            cell.titleLabel.textColor = UIColor.white
//            cell.userImageView.image = UIImage.init(named: "close-icon-white")

//        }
        
        return cell
    }
    
}
extension HunterSkillSetVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if self.selectedSkillsArr.count == 0 {
//            let label = UILabel(frame: CGRect.zero)
//            label.text = skillsArr[indexPath.row].uppercased()
//            label.sizeToFit()
//            return CGSize(width: label.frame.width+55, height: 30)
//        }
//        else {
         
                let width = (selectedSkillsArr[indexPath.row].uppercased()).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 17.0) ?? ""]).width
                let label = UILabel(frame: CGRect.zero)
                label.text = selectedSkillsArr[indexPath.row].capitalized
                label.sizeToFit()
                return CGSize(width: width + 40, height: 30)

    //            return CGSize(width: label.frame.width+55, height: 30)
             
//        }
    }
}
extension HunterSkillSetVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     }
}
class HunterWorkLocTwoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!
}

