//
//  HunterUAETwoExpVC.swift
//  Hunter
//
//  Created by Zubin Manak on 11/11/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import iOSDropDown
import Alamofire
import SVProgressHUD

class HunterUAETwoExpVC: UIViewController {
    @IBOutlet weak var contButton: UIButton!

    var UAEExpArr = [String]()
    var UAEExpIDArr = [Int]()
    @IBOutlet weak var lab_suggestions: UILabel!

    var selectedUAEExpArr = [String]()
    var selectedUAEExpIDArr = [Int]()
    

    @IBOutlet weak var locDropDown: DropDown!
    @IBOutlet weak var collView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locDropDown.leftViewEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        connectToRegisterPreferedCompanies()
    }
    override func viewWillAppear(_ animated: Bool) {
/*        let alignedFlowLayout = collView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.minimumLineSpacing = 5.0
        alignedFlowLayout?.minimumInteritemSpacing = 5.0
        alignedFlowLayout?.horizontalAlignment = .justified
        alignedFlowLayout?.verticalAlignment = .center*/
        collView.collectionViewLayout = CenterAlignedCollectionViewFlowLayout()
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonRemoveFromSuggestions(_ sender: UIButton) {
        //add removed element to main array
        self.UAEExpArr.append(self.selectedUAEExpArr[sender.tag])
        self.UAEExpIDArr.append(self.selectedUAEExpIDArr[sender.tag])
        //remove particular element from selected array
        self.selectedUAEExpArr.remove(at: sender.tag)
        self.selectedUAEExpIDArr.remove(at: sender.tag)
        
        if (self.selectedUAEExpArr.count == 0) {
        self.contButton.setTitleColor(UIColor.init(hexString:"6B3E99" ), for: UIControl.State.normal)
        
        self.contButton.backgroundColor = UIColor.init(hexString:"E9E4F2" )
        
        }
//        if self.selectedUAEExpArr.count > 0 {
//            self.lab_suggestions.isHidden = true
//        }
//        else {
//            self.lab_suggestions.isHidden = false
//        }
        
        self.collView.reloadData()
        
        // The list of array to display. Can be changed dynamically
        self.locDropDown.optionArray = self.UAEExpArr
        //Its Id Values and its optional
        self.locDropDown.optionIds = self.UAEExpIDArr
    }
    @IBAction func continueBtn(_ sender: Any) {
        if selectedUAEExpArr.count != 0{
            connectToRegisterSavePreferedCompanies()
        }else{
            let alert = UIAlertController(title: "", message:
                "Please select a company to proceed.", preferredStyle: .alert)
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
    func connectToRegisterPreferedCompanies(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.registerPreferedCompaniesURL
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
                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
                                print (data)
                                
                                for locData in data {
                                    
                                    print (locData)
                                    self.UAEExpArr.append(locData.value(forKey: "company_name") as! String)
                                    self.UAEExpIDArr.append(locData.value(forKey: "id") as! Int)
                                    
                                }
                                
                                self.locDropDown.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
                                self.locDropDown.selectedRowColor = UIColor.init(hexString: "E8E4F2")
                                self.locDropDown.textColor = UIColor.init(hexString: "531B93")
                                self.locDropDown.checkMarkEnabled = false
                                self.locDropDown.rowHeight = 40.0
                                
                                // The list of array to display. Can be changed dynamically
                                self.locDropDown.optionArray = self.UAEExpArr
                                //Its Id Values and its optional
                                self.locDropDown.optionIds = self.UAEExpIDArr
                                
                                // Image Array its optional
                                // The the Closure returns Selected Index and String
                                self.locDropDown.didSelect{(selectedText , index ,id) in
                                    print(String(selectedText))
                                    self.locDropDown.text = ""
                                    if (self.selectedUAEExpArr.count < 5){
                                        //add particular element to selected array
                                        self.selectedUAEExpArr.append(self.UAEExpArr[index])
                                        self.selectedUAEExpIDArr.append(self.UAEExpIDArr[index])
                                        //remove particular element from main array
                                        self.UAEExpArr.remove(at: index)
                                        self.UAEExpIDArr.remove(at: index)
                                    }else{
                                        let alert = UIAlertController(title: "", message:
                                            "You cannot select more than 5.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                        }))
                                        self.present(alert, animated: true, completion: nil)
                                        }
                                    self.contButton.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
                                    self.contButton.backgroundColor = UIColor.init(hexString:"6B3E99" )
                                        
                                    
//                                    if self.selectedUAEExpArr.count > 0 {
//                                        self.lab_suggestions.isHidden = true
//                                    }
//                                    else {
//                                        self.lab_suggestions.isHidden = false
//                                    }
                                    
                                    self.collView.reloadData()
                                    
                                    // The list of array to display. Can be changed dynamically
                                    self.locDropDown.optionArray = self.UAEExpArr
                                    //Its Id Values and its optional
                                    self.locDropDown.optionIds = self.UAEExpIDArr
                                }
                                
//                                if self.selectedUAEExpArr.count > 0 {
//                                    self.lab_suggestions.isHidden = true
//                                }
//                                else {
//                                    self.lab_suggestions.isHidden = false
//                                }
                                
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
    func connectToRegisterSavePreferedCompanies(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.registerSavePreferedCompaniesURL
            print(url)
            HunterUtility.showProgressBar()
            let paramsDict = ["company_name": selectedUAEExpArr ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterCurrentWorkStatusVC") as! HunterCurrentWorkStatusVC
                                self.navigationController?.pushViewController(vc, animated: true)
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
    
}
extension HunterUAETwoExpVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//         if self.selectedUAEExpArr.count == 0 {
//            return self.UAEExpArr.count
//        }
//        else {
            return self.selectedUAEExpArr.count
//        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterUAETwoExpCollectionCell", for: indexPath) as! HunterUAETwoExpCollectionCell
//        if self.selectedUAEExpArr.count == 0 {
//
//            cell.titleLabel.text = UAEExpArr[indexPath.item].uppercased()
//            cell.buttonRemove.isHidden = true
//            cell.titleLabel.textColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
//            cell.backgroundColor = UIColor.init(red: 232.0/255.0, green: 228.0/255.0, blue: 242.0/255.0, alpha: 1.0)
//
//        }
//        else {
            cell.buttonRemove.isHidden = false
            
            cell.titleLabel.text = selectedUAEExpArr[indexPath.item].capitalized
            cell.buttonRemove.tag = indexPath.item
            
            cell.backgroundColor = UIColor.init(red: 107.0/255.0, green: 62.0/255.0, blue: 153.0/255.0, alpha: 1.0)
            cell.titleLabel.textColor = UIColor.white
            cell.userImageView.image = UIImage.init(named: "close-icon-white")

//        }
        return cell
    }
}
extension HunterUAETwoExpVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.selectedUAEExpArr.count == 0 {
            let label = UILabel(frame: CGRect.zero)
            label.text = UAEExpArr[indexPath.row].uppercased()
            label.sizeToFit()
            return CGSize(width: label.frame.width+55, height: 30)
        }
        else {
            let label = UILabel(frame: CGRect.zero)
            label.text = selectedUAEExpArr[indexPath.row].uppercased()
            label.sizeToFit()
            return CGSize(width: label.frame.width+55, height: 30)
        }
    }
}
extension HunterUAETwoExpVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
class HunterUAETwoExpCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!
}

