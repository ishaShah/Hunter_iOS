//
//  HunterLanguageListVC.swift
//  Hunter
//
//  Created by Zubin Manak on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterLanguageListVC: UIViewController {
    @IBOutlet weak var collViewLangs: UICollectionView!
    
    var langArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
 
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
         
        getAllLang()
        
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterLanguage1VC") as! HunterLanguage1VC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func actionSave(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getAllLang(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.getAllLangURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    self.langArray = []
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                if let data = responseDict.value(forKey: "data") as? NSDictionary{
                                    if let jobs = data.value(forKey: "languages") as? NSArray{
                                        self.langArray = jobs
                                         
                                        self.collViewLangs.reloadData()
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
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func postANewJob(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterLanguage1VC") as! HunterLanguage1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension HunterLanguageListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return langArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterLanguageCollectionViewCell", for: indexPath) as! HunterLanguageCollectionViewCell
        
        guard let dataDic = langArray[indexPath.row] as? [String:Any] else {
            return cell
        }
        if let job_title = dataDic["language"] as? String {
        cell.lbl_title.text = dataDic["language"] as? String ?? ""
        }
        if let work_type = dataDic["proficiency"] as? String {
        cell.lbl_prof.text = dataDic["proficiency"] as? String ?? ""
        }
          
        
        
        

        
        
//        cell.viewInner.layer.shadowPath = UIBezierPath(rect: cell.viewInner.bounds).cgPath
//        cell.viewInner.layer.shadowColor = UIColor(hex: "21042E21")?.cgColor
//        cell.viewInner.layer.shadowRadius = 3
//        cell.viewInner.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.viewInner.layer.shadowOpacity = 0.3
        

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: 125)
    }
    
    
}

class HunterLanguageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_prof: UILabel!
    
    @IBOutlet weak var viewInner: UIView!
}
