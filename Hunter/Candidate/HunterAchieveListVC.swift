//
//  HunterAchieveListVC.swift
//  Hunter
//
//  Created by Zubin Manak on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterAchieveListVC: UIViewController{

    @IBOutlet weak var collVAchievements: UICollectionView!
    
    var achievementArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        collVAchievements.isPagingEnabled = true
        getAllAchievements()
        
    }
    func getAllAchievements() {
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.getAllAchievementsURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    self.achievementArray = []
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let jobs = data.value(forKey: "achievements") as? NSArray{
                                        self.achievementArray = jobs
                                         
                                        self.collVAchievements.reloadData()
                                    }
                                }
                            }
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
        }
    }
    
   
                
                   @objc func btnDeleteClick(sender: UIButton) {
                       let dataDic = achievementArray[sender.tag] as? [String:Any]
                       self.delAchivement(dataDic!["id"] as! Int)
                   }
       
           func delAchivement(_ achievement_id : Int){
               if HunterUtility.isConnectedToInternet(){
                   let url = API.candidateBaseURL + API.delAchievementsURL
                   print(url)
                   HunterUtility.showProgressBar()
                   
                   let headers    = [ "Authorization" : "Bearer " + accessToken]
                   let params = ["achievement_id" : achievement_id
]
                   Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                       
                       switch response.result {
                       case .success:
                           self.achievementArray = []
                           if let responseDict = response.result.value as? NSDictionary{
                               print(responseDict)
                               SVProgressHUD.dismiss()
                               if let status = responseDict.value(forKey: "status"){
                                   if status as! Int == 1{
                                       self.getAllAchievements()

                                   }
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
               }
               
           }
    @IBAction func actionAddNewAchievement(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterAchieveVC") as! HunterAchieveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionSaveAchievement(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension HunterAchieveListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HunterAchievementsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterAchievementsCollectionViewCell", for: indexPath) as! HunterAchievementsCollectionViewCell
        let dict : NSDictionary = (achievementArray[indexPath.row] as? NSDictionary)!
            cell.lblHeader.text = dict["title"] as? String ?? ""
            cell.lblSubHead1.text = "Issued by " + "\(dict["issued_by"] ?? "")"
            cell.lblSubHead2.text = "\(dict["issued_date"] as? Int ?? 1990)"
            cell.txtViewDesc.text = dict["description"] as? String ?? ""
            
        cell.btnDelete.tag = indexPath.row
           cell.btnDelete.addTarget(self, action: #selector(btnDeleteClick(sender:)), for: .touchUpInside)

        
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        CGSize(width: 280, height: 200)
    }
    
  
    
    
}
class HunterAchievementsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblSubHead1: UILabel!
    @IBOutlet weak var lblSubHead2: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var txtViewDesc: UITextView!
    @IBOutlet weak var viewInner: UIView!
}
