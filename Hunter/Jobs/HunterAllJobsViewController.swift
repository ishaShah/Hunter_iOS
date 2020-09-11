//
//  HunterAllJobsViewController.swift
//  Hunter
//
//  Created by Shamzi on 19/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterAllJobsViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var collViewJobs: UICollectionView!
    
    var jobsArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        applyUIChanges()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
        collViewJobs.delegate = nil
        collViewJobs.dataSource = nil
        getAllJobs()
        
    }
    
    
    func applyUIChanges(){
        
        viewHeader.layer.masksToBounds =  true
        viewHeader.layer.cornerRadius = 20
        viewHeader.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        viewHeader.clipsToBounds = true
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = viewHeader.frame.size
        
        let color1 = UIColor(red: 55 / 255.0, green: 11.0 / 255.0, blue: 120.0 / 255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 128.0 / 255.0, green: 27.0 / 255.0, blue: 173.0 / 255.0, alpha: 1.0).cgColor
        let color3 = UIColor(red: 206.0 / 255.0, green: 56.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0).cgColor

        gradientLayer.colors = [color1,color2,color3]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        //Use diffrent colors
        viewHeader.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func getAllJobs(){
        if HunterUtility.isConnectedToInternet(){
            let url = API.recruiterBaseURL + API.getJobListURL
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
                                    if let jobs = data.value(forKey: "jobs") as? NSArray{
                                        self.jobsArray = jobs
                                        self.collViewJobs.delegate = self
                                        self.collViewJobs.dataSource = self
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
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterPostAJobNewViewController") as! HunterPostAJobNewViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension HunterAllJobsViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterAllJobsCollectionViewCell", for: indexPath) as! HunterAllJobsCollectionViewCell
        
        
        
        
        
        
        guard let dataDic = jobsArray[indexPath.row] as? [String:Any] else {
            return cell
        }
        if dataDic["status"] as! String  == "Draft"{
            cell.viewIsDraft.isHidden = false
            cell.constrTopToView.constant = 65
        }else{
            cell.viewIsDraft.isHidden = true
            cell.constrTopToView.constant = 20
        }
        cell.lblJobHeader.text = dataDic["title"] as? String ?? ""
        cell.lblJobType.text = dataDic["work_type"] as? String ?? ""
        cell.lblJobFunction.text = dataDic["job_functions"] as? String ?? ""
        cell.lblJobSalary.text = dataDic["salary_range"] as? String ?? ""
        cell.lblPosition.text = dataDic["education"] as? String ?? ""
        cell.lblExperience.text = dataDic["experience"] as? String ?? ""
        cell.lblDescription.text = dataDic["job_summary"] as? String ?? ""
        cell.lblMatches.text = "\(dataDic["matches"] as? Int ?? 0)" + " Matches"
        
        
        let publishedDate = (dataDic["posted_on"] as! String).toDate(withFormat: "MM-dd-yyyy HH:mm a")
        let publishedDateStr = publishedDate?.toString(withFormat: "MMMM d yyyy")
        cell.lblPostedDate.text =  "Posted: " + (publishedDateStr ?? "")
        
        
        

        
        
//        cell.viewInner.layer.shadowPath = UIBezierPath(rect: cell.viewInner.bounds).cgPath
//        cell.viewInner.layer.shadowColor = UIColor(hex: "21042E21")?.cgColor
//        cell.viewInner.layer.shadowRadius = 3
//        cell.viewInner.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.viewInner.layer.shadowOpacity = 0.3
        

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 308, height: 480)
    }
    
    
}

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {

    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
