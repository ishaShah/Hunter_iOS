//
//  CustomView.swift
//  TinderSwipeView_Example
//
//  Created by Nick on 29/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SVProgressHUD
class CustomView: UIView {
    var delegate: MyProtocol!
 
    @IBOutlet weak var txt_view: UITextView!
    @IBOutlet weak var view_txt: CardViewNew!
    @IBOutlet weak var lab_otherDetails: UILabel!
    @IBOutlet weak var lab_designer: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profImg: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var profNameLab: UILabel!
    @IBOutlet weak var desigNameLab: UILabel!
    @IBOutlet weak var jobDesc: UITextView!
    @IBOutlet weak var coll_industry: UICollectionView!
    @IBOutlet weak var lab_loc: UILabel!
    @IBOutlet weak var view_expand: UIView!
    @IBOutlet weak var btn_profile: UIButton!
    @IBOutlet weak var stack_share: UIStackView!
    var recruiter_id = Int()
    @IBOutlet weak var backBtn: UIButton!
    //    @IBOutlet weak var labelText: UILabel!
//    @IBOutlet weak var imageViewProfile: UIImageView!
//    @IBOutlet weak var imageViewBackground: UIImageView!
//    @IBOutlet weak var buttonAction: UIButton!
    
    
    var isFrom = String()

    var userModel : UserModel! {
        didSet{
             self.desigNameLab.text = "@\(userModel.name!)"
            
            self.profNameLab.text = "\(userModel.job_details["title"] as! String)"
            self.jobDesc.text = (userModel.job_details["job_summary"] as! String)
            
            if let url = userModel.recruiter["rectangle_logo"] as? String{
                print(url)
                self.profImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))

            }
            self.logoImg.sd_setImage(with: URL(string: userModel.recruiter["square_logo"] as! String), placeholderImage: UIImage(named: "placeholder.png"))

            self.lab_loc.text = (userModel.job_details["location"] as! String)
            self.lab_designer.text = (userModel.job_details["work_type"] as! String)
            
            let education = (userModel.job_details["education"] as! [String])
            let edu_string = education.joined(separator: ", ")
            self.lab_otherDetails.text = "\(userModel.job_details["experience"] as! String) Experience\nEducation: \(edu_string.capitalized)\nSalary: \(userModel.job_details["salary_range"] as! String)"
            self.recruiter_id = userModel.job_details["recruiter_id"] as! Int
//            self.imageViewBackground.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(CustomView.className, owner: self, options: nil)
         
        let jobView = UserDefaults.standard.object(forKey: "jobView") as? String
        contentView.fixInView(self)
        self.view_txt.isHidden = true

        if jobView == "jobView" {
            self.view_expand.isHidden = true
             self.backBtn.isHidden = false
            self.stack_share.isHidden = false

        }
        else {
            self.backBtn.isHidden = true
            self.stack_share.isHidden = true


        }
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
//        imageViewProfile.contentMode = .scaleAspectFill
//        imageViewProfile.layer.cornerRadius = 30
//        imageViewProfile.clipsToBounds = true
        let alignedFlowLayout = coll_industry?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.minimumLineSpacing = 5.0
        alignedFlowLayout?.minimumInteritemSpacing = 5.0
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        
 
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.delegate?.backBtnClick()
    }
    @IBAction func profileView(_ sender: Any) {
        
        self.delegate?.instantiateNewSecondView(tagged: self.recruiter_id)
        
    }
    
    @IBAction func fullView(sender:UIButton) {
        self.delegate?.jobViewClick()
    }
    
    @IBAction func btn_dislike(_ sender: Any) {
            connectToLikeDislike(1)
        }
        @IBAction func btn_like(_ sender: Any) {
            connectToLikeDislike(0)

        }
        
        func connectToLikeDislike(_ decision : Int){
             
            
                    if HunterUtility.isConnectedToInternet(){
                        
                        var url = ""
     
                             url = API.candidateBaseURL + API.jobViewMatchOrDeclineURL
                            print(url)
                                        HunterUtility.showProgressBar()
                                        
                                        let headers = [ "Authorization" : "Bearer " + accessToken]
                        var parameters = [String : Any]()

                         

    //                    decision (0 for match and 1 declined)
                       
                         
                        parameters = ["decision" : decision , "recruiter_id" : self.recruiter_id , "job_id" : userModel.job_details["job_id"] as! Int]

                                        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                                            
                                            switch response.result {
                                            case .success:
                                                if let responseDict = response.result.value as? NSDictionary{
                                                    print(responseDict)
                                                    SVProgressHUD.dismiss()
                                                    if let status = responseDict.value(forKey: "status"){
                                                        if status as! Int == 1{
                                                            UserDefaults.standard.set("swiped", forKey: "swiped")

                                                            if (decision == 0) {
//                                                                self.makeToast("Matched")
                                                            }
                                                            else if (decision == 1) {
//                                                                self.makeToast("Declined")
                                                            }
                                                            
                                                            let data = responseDict.value(forKey: "data") as! NSDictionary

                                                            let elevator_pitch = (data["elevator_pitch"] as! Int)
                                                            if elevator_pitch == 0 {
                                                                UserDefaults.standard.set("swiped", forKey: "swiped")

                                                                 self.view_txt.isHidden = true
                                                                self.delegate?.backBtnClick()

                                                             }
                                                            else {
                                                            self.txt_view.text = "Type your message here ..."
                                                            self.view_txt.isHidden = false
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        } else if status as! Int == 2 {
//                                                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                                            }))
//                                                            self.present(alert, animated: true, completion: nil)
                                                            
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
//                                                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                                            }))
//                                                            self.present(alert, animated: true, completion: nil)
                                                        }
                                                    }
                                                    else{
//                                                        let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                                        }))
//                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                }else{
                                                    SVProgressHUD.dismiss()
                                                    
                                                    
                                                }
                                                
                                            case .failure(let error):
                                                SVProgressHUD.dismiss()
//                                                print(error)
//                                                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
     
                        
                    
                
        }
        }
    
    
    @IBAction func cancelMsg(_ sender: Any) {
               
               view_txt.isHidden = true
    
           }
           @IBAction func sendMsg(_ sender: Any) {
               connectToSendIntroMsgs()
           }
           
            
           func connectToSendIntroMsgs(){
               let loginType = UserDefaults.standard.object(forKey: "loginType") as? String
               
                
               if HunterUtility.isConnectedToInternet(){
                   
                   let url = API.candidateBaseURL + API.elevatorPitchURL

                   
 
                   print(url)
                   HunterUtility.showProgressBar()
                   
                   
                   let headers    = [ "Authorization" : "Bearer " + accessToken]
                   print(headers)
                   
                   
        
                let parameters    = [ "recruiter_id" : self.recruiter_id , "job_id" : userModel.job_details["job_id"]! , "message" : txt_view.text!] as [String : Any]
                   print(parameters)

       //            job_id
       //            candidate_id
       //            job_message
                   
                   
                   
                   Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                       
                       switch response.result {
                       case .success:
                           if let responseDict = response.result.value as? NSDictionary{
                               print(responseDict)
                               SVProgressHUD.dismiss()
                               if let status = responseDict.value(forKey: "status"){
                                   if status as! Int == 1{
                                      UserDefaults.standard.set("swiped", forKey: "swiped")

                                       self.view_txt.isHidden = true
                                      self.delegate?.backBtnClick()

                                   }
                               else if status as! Int == 2 {
//                                   let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                   alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                   }))
//                                   self.present(alert, animated: true, completion: nil)
//
//                                   print("Logout api")
                                   
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
//                                   self.present(alert, animated: true, completion: nil)
                                   }}
                           }
                           
                           
                           
                           
                       case .failure(let error):
                           SVProgressHUD.dismiss()
                           print(error)
                           let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                           self.present(alert, animated: true, completion: nil)
                       }
                   }
               }else{
                   print("no internet")
               }
               
           }
}

extension UIView{
    
    func fixInView(_ container: UIView!) -> Void{
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        
        
        
        container.addSubview(self);
        
        let jobView = UserDefaults.standard.object(forKey: "jobView") as? String
        
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        if jobView != "jobView" {

        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
        

    }
}

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
extension CustomView : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userModel.skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterRegisterDashBoardCollectionCell", for: indexPath) as! HunterRegisterDashBoardCollectionCell
        let skills = userModel.skills[indexPath.row] as! String
        cell.titleLabel.text = skills.uppercased()
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
    
}
extension CustomView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var label = UILabel(frame: CGRect.zero)
        let skills = userModel.skills[indexPath.row] as! String
        label.text = skills.uppercased()
        label.sizeToFit()
        return CGSize(width: label.frame.width + 3, height: 20)
    }
}
extension CustomView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}

class HunterRegisterDashBoardCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20/2
        
    }
    
}
