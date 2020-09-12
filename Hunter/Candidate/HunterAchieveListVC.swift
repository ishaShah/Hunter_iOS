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

class HunterAchieveListVC: UIViewController {

    @IBOutlet weak var collVAchievements: UICollectionView!
    
    var achievementArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
         
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
                                        self.collVAchievements.delegate = self
                                        self.collVAchievements.dataSource = self
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
    @IBAction func actionAddNewAchievement(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterAchieveVC") as! HunterAchieveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func actionSaveAchievement(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension HunterAchieveListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HunterAchievementsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterAchievementsCollectionViewCell", for: indexPath) as! HunterAchievementsCollectionViewCell
        if let dict : NSDictionary = achievementArray[indexPath.row] as? NSDictionary{
            cell.lblHeader.text = dict["title"] as? String ?? ""
            cell.lblSubHead1.text = "Issued by " + "\(dict["issued_by"] ?? "")"
            cell.lblSubHead2.text = "\(dict["issued_date"] as? Int ?? 1990)"
            cell.txtViewDesc.text = dict["description"] as? String ?? ""
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 480, height: 308)
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
