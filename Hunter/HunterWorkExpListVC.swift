//
//  HunterWorkExpListVC.swift
//  Hunter
//
//  Created by Zubin Manak on 06/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterWorkExpListVC: UIViewController {

    @IBOutlet weak var collViewJobs: UICollectionView!
    @IBOutlet var dots: UIPageControl!

    var jobsArray = NSArray()
    var isFrom = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
         
        getAllJobs()
        
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        if isFrom == "Profile" {
               let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
               self.navigationController?.pushViewController(vc, animated: true)
               }
               else {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterEducationStep1VC") as! HunterEducationStep1VC
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
 
    
    func getAllJobs(){
        if HunterUtility.isConnectedToInternet(){
            var url = API.candidateBaseURL + API.getJobExpURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    self.jobsArray = []
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let jobs = data.value(forKey: "experience") as? NSArray{
                                        self.jobsArray = jobs
                                         
                                        self.collViewJobs.reloadData()
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
    @IBAction func back(_ sender: Any) {
        if isFrom == "Profile" {
               let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
               self.navigationController?.pushViewController(vc, animated: true)
               }
        else {
        self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func postANewJob(_ sender: Any) {
         
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkExpVC") as! HunterWorkExpVC
        vc.isFromProfile = isFrom
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dots.currentPage = Int(
            (collViewJobs.contentOffset.x / collViewJobs.frame.width)
            .rounded(.toNearestOrAwayFromZero)
        )
    }

}

extension HunterWorkExpListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dots.numberOfPages = jobsArray.count

        return jobsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterWorkExpCollectionViewCell", for: indexPath) as! HunterWorkExpCollectionViewCell
        
        guard let dataDic = jobsArray[indexPath.row] as? [String:Any] else {
            return cell
        }
        if let job_title = dataDic["job_title"] as? String {
        cell.lbl_title.text = dataDic["job_title"] as? String ?? ""
        }
        if let work_type = dataDic["work_type"] as? String {
        cell.lbl_exp.text = dataDic["work_type"] as? String ?? ""
        }
         cell.lbl_loc.text = dataDic["location"] as? String ?? ""
        cell.lbl_compName.text = dataDic["company_name"] as? String ?? ""
         
        
         let experience_start = "\(dataDic["experience_start"] as? Int ?? 0)"
         let experience_end = "\(dataDic["experience_end"] as? Int ?? 0)"
        cell.lbl_date.text =  "\(experience_start) - \(experience_end)"
        
        
        

        cell.btnDelete.tag = indexPath.row
         cell.btnDelete.addTarget(self, action: #selector(btnDeleteClick(sender:)), for: .touchUpInside)

        
//        cell.viewInner.layer.shadowPath = UIBezierPath(rect: cell.viewInner.bounds).cgPath
//        cell.viewInner.layer.shadowColor = UIColor(hex: "21042E21")?.cgColor
//        cell.viewInner.layer.shadowRadius = 3
//        cell.viewInner.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.viewInner.layer.shadowOpacity = 0.3
        

        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewWidth = self.collViewJobs.frame.width
        let totalCellWidth = 250 * jobsArray.count
        let totalSpacingWidth = 10 * (jobsArray.count - 1)

        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
    @objc func btnDeleteClick(sender: UIButton) {

        
                           let dataDic = jobsArray[sender.tag] as? [String:Any]
                           self.delAchivement(dataDic!["id"] as! Int)
                       }
           
               func delAchivement(_ experience_id : Int){
                   if HunterUtility.isConnectedToInternet(){
                       let url = API.candidateBaseURL + API.delExperienceURL
                       print(url)
                       HunterUtility.showProgressBar()
                       
                       let headers    = [ "Authorization" : "Bearer " + accessToken]
                       let params = ["experience_id" : experience_id ]
                       Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                           
                           switch response.result {
                           case .success:
                               self.jobsArray = []
                               if let responseDict = response.result.value as? NSDictionary{
                                   print(responseDict)
                                   SVProgressHUD.dismiss()
                                   if let status = responseDict.value(forKey: "status"){
                                       if status as! Int == 1{
                                           self.getAllJobs()

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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: 250)
    }
    
    
}

class HunterWorkExpCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_compName: UILabel!
    @IBOutlet weak var lbl_loc: UILabel!
    @IBOutlet weak var lbl_exp: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    
    
    @IBOutlet weak var img_compImg: UIImageView!
    @IBOutlet weak var viewInner: UIView!
}
