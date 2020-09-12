//
//  HunterListAllEduVC.swift
//  Hunter
//
//  Created by Shamseer on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterListAllEduVC: UIViewController {

    var isFrom = String()

    var educationArray = NSArray()
    @IBOutlet weak var collEducation: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
         
        getAllEducation()
        
    }
    @IBAction func actionBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    func getAllEducation(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.getEducationQualification
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    self.educationArray = []
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let educations = data.value(forKey: "educations") as? NSArray{
                                        self.educationArray = educations
                                        self.collEducation.delegate = self
                                        self.collEducation.dataSource = self
                                        self.collEducation.reloadData()
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
    @IBAction func actionAddNewEducation(_ sender: Any)
        {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterEducationStep2VC") as! HunterEducationStep2VC
            self.navigationController?.pushViewController(vc, animated: true)
            
    }
    @IBAction func actionAddEducation(_ sender: Any) {
        // additional image/video
        if isFrom == "Profile" {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
        self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditProPicVC") as! HunterEditProPicVC
        vc.isFrom = "candidateReg"
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HunterListAllEduVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return educationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterWorkExpCollectionViewCell", for: indexPath) as! HunterWorkExpCollectionViewCell
        
        guard let dataDic = educationArray[indexPath.row] as? [String:Any] else {
            return cell
        }
        if let school = dataDic["school"] as? String {
            cell.lbl_title.text = dataDic["school"] as? String ?? ""
        }
        if let field_of_study = dataDic["field_of_study"] as? String {
            cell.lbl_exp.text = dataDic["field_of_study"] as? String ?? ""
        }
         cell.lbl_loc.text = dataDic["level_of_study"] as? String ?? ""
        cell.lbl_compName.text = dataDic["company_name"] as? String ?? ""
         
        
         let start_date = dataDic["start_date"] as? String ?? ""
         let end_date = dataDic["end_date"] as? String ?? ""
        cell.lbl_date.text =  "\(start_date) - \(end_date)"
        
        
        

        
        
//        cell.viewInner.layer.shadowPath = UIBezierPath(rect: cell.viewInner.bounds).cgPath
//        cell.viewInner.layer.shadowColor = UIColor(hex: "21042E21")?.cgColor
//        cell.viewInner.layer.shadowRadius = 3
//        cell.viewInner.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.viewInner.layer.shadowOpacity = 0.3
        

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: 250)
    }
    
    
    
}
