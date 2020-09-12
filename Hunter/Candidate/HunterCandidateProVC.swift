
//
//  HunterCandidateProVC.swift
//  Hunter
//
//  Created by Zubin Manak on 13/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SDWebImage
import iOSDropDown
import CropViewController


class HunterCandidateProVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate , CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tv_achievement: UITextView!
    @IBOutlet weak var tv_lang : UITextView!
    @IBOutlet weak var stack_share: UIStackView!
 
    @IBOutlet weak var tbl_lang: UITableView!
    @IBOutlet weak var tblEduation: UITableView!
    @IBOutlet weak var tblWorkExp: UITableView!
    
    @IBOutlet weak var addAchHt: NSLayoutConstraint!
    @IBOutlet weak var addLanHt: NSLayoutConstraint!
    @IBOutlet weak var view_education: UIView!
    
    @IBOutlet weak var vieweduHt: NSLayoutConstraint!
    @IBOutlet weak var viewLanHt: NSLayoutConstraint!
    @IBOutlet weak var viewAchHt: NSLayoutConstraint!
    
    
    @IBOutlet weak var collectionSkills: UICollectionView!
    @IBOutlet weak var heightCollectionSkills: NSLayoutConstraint!
    @IBOutlet weak var heightTableExperience: NSLayoutConstraint!

    @IBOutlet weak var heightTableEducation: NSLayoutConstraint!

    
    @IBOutlet weak var langHt: NSLayoutConstraint!
    let headerViewHeight: CGFloat = 198
    @IBOutlet weak var lab_profileName: UILabel!
 
    @IBOutlet weak var lab_skills: UILabel!
 
    @IBOutlet weak var txt_desc: UITextView!
 
    @IBOutlet weak var btn_uploadCover: UIButton!

    @IBOutlet weak var imgv_proPic: UIImageView!
     @IBOutlet weak var imgEditView: UIView!
    
    @IBOutlet weak var img_thumb: UIImageView!
    @IBOutlet weak var btn_uploadImg: UIButton!
    
 
    var editMode = true
    var isSQImage = false
    var isRGImage = false

    @IBOutlet weak var scrlCV: UIView!
    @IBOutlet weak var editView: UIView!
    var selectedSkillsArr = [String]()
    var selectedIDSkillsArr = [Int]()

    var skillsArr = [String]()
    var skillsIDArr = [Int]()

    var skillAdded = true
    var worked_in_uae = ""
 
    
    @IBOutlet weak var scrlV: UIScrollView!

    var ExpAdded = true

    var UAEExpArr = [String]()
    var UAEExpIDArr = [Int]()
    

    
    @IBOutlet weak var tblAchievementHt: NSLayoutConstraint!
    
    var EduAdded = true
 
    var LangAdded = true
 
    var achieveAdded = true
 
    var SMAdded = true
 

    var LocAdded = true


    var locationArr = [String]()
    var locationIDArr = [Int]()
 
    
    @IBOutlet weak var labelJobFunc: UILabel!

    var JobFuncAdded = true

    var jobFuncArr = [String]()
    var jobFuncIDArr = [Int]()
    

    var selectedWorkType = Int()

    
    var arrayJobTypes = [String]()

    var arrayExperienceNames = [String]()
    var arrayLocationNames = [String]()
    var locations = ""
    var experience = ""
    var jobs = ""

    @IBOutlet weak var stackName: UIStackView!

    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textLastName: UITextField!
    var isNameEdited = false
    var firstName = String()
    var lastName = String()
    var profileDesc = String()
    
    @IBOutlet weak var lab_country: UILabel!
    
    
    var skillsArrDict = [NSDictionary]()
    var jobArrDict = [NSDictionary]()
    var expArrDict  = [NSDictionary]()
    var locArrDict  = [NSDictionary]()
    var socArrDict  = [NSDictionary]()
    var langArrDict  = [NSDictionary]()
    var eduArrDict  = [NSDictionary]()
    var achieveArrDict  = [NSDictionary]()
    var socPNGArr  = [NSDictionary]()
    
    
 
    
    @IBOutlet weak var editV1: UIView!
    @IBOutlet weak var editV2: UIView!
    @IBOutlet weak var editV3: UIView!
    @IBOutlet weak var editV4: UIView!
    @IBOutlet weak var editV5: UIView!
    @IBOutlet weak var btn_editAdd: UIButton!
    @IBOutlet weak var btn_editAdd1: UIButton!
    
    @IBOutlet weak var btn_saveCan: UIStackView!
    var candidate_idPassed = Int()
    var job_id = Int()
    
    var isFrom = String()
    @IBOutlet weak var tblAchievement : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 

        lab_profileName.isHidden = false

        self.hideKeyboardWhenTappedAround()
 
  
        if isFrom == "recruiter" {
            stack_share.isHidden = false
        }
        else {
            stack_share.isHidden = true
        }
        
        hidenAndShowBtns(false)
        scrlCV.roundCorners([.topLeft, .topRight], radius: 20.0)
        scrlV.roundCorners([.topLeft, .topRight], radius: 20.0)

        let alignedFlowLayout = collectionSkills?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.minimumLineSpacing = 5.0
        alignedFlowLayout?.minimumInteritemSpacing = 5.0
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        
    }
    
    @IBAction func threeLine(_ sender: Any) {
        editView.isHidden = false;
    }
    
    @IBAction func closeEditView(_ sender: Any) {
        editView.isHidden = true;
        hidenAndShowBtns(false)

    }
    
     override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
//        connectToGetProfileData()

        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        connectToGetProfileData()

    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func autosizeCollectionView()  {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.collectionSkills.layoutIfNeeded()
            let height = self.collectionSkills.contentSize.height
            self.heightCollectionSkills.constant = height
            self.collectionSkills.needsUpdateConstraints()
            

        }
    }
    @IBOutlet weak var view_languages: UIView!
    @IBOutlet weak var view_achievement: UIView!
    func autosizeTableView()  {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.tblWorkExp.layoutIfNeeded()
            var height = CGFloat()
            
                height = CGFloat(self.expArrDict.count) * 70.0
            
            //let height = self.tblWorkExp.contentSize.height
            self.heightTableExperience.constant = height
            self.tblWorkExp.needsUpdateConstraints()
            
            
            var height1 = CGFloat()
            
            height1 = CGFloat(self.eduArrDict.count) * 97.0
            
            //let height1 = self.tblEduation.contentSize.height
            self.heightTableEducation.constant = height1
            self.tblEduation.needsUpdateConstraints()
            
            if (self.eduArrDict.count == 0) {
                self.view_education.isHidden = true
                self.vieweduHt.constant = 0.0
            }
            else {
                self.view_education.isHidden = false
                self.vieweduHt.constant = height1 + 72.0

            }
 
            self.tblEduation.layoutIfNeeded()

            
            
            var height2 = CGFloat()
            
            height2 = CGFloat(self.langArrDict.count) * 70.0
            
            //let height1 = self.tblEduation.contentSize.height
            self.langHt.constant = height2
            self.tbl_lang.needsUpdateConstraints()
            
            
            if (self.langArrDict.count == 0) {
                self.view_languages.isHidden = true
                self.viewLanHt.constant = 0.0
            }
            else {
                self.view_languages.isHidden = false
                self.viewLanHt.constant = height2 + 126.0

            }
            self.tbl_lang.layoutIfNeeded()

            
            
            var height3 = CGFloat()
            
            height3 = CGFloat(self.achieveArrDict.count) * 90.0
            
            //let height1 = self.tblEduation.contentSize.height
            self.tblAchievementHt.constant = height3
            self.tblAchievement.needsUpdateConstraints()
 
            if (self.achieveArrDict.count == 0) {
                self.view_achievement.isHidden = true
                self.viewAchHt.constant = 0.0
            }
            else {
                self.view_achievement.isHidden = false
                self.viewAchHt.constant = height3 + 126.0

            }
            self.tblAchievement.layoutIfNeeded()
//            self.scrlCV.needsUpdateConstraints()
//
//            self.scrlCV.layoutIfNeeded()
//
//            self.scrlV.needsUpdateConstraints()
//
//            self.scrlV.layoutIfNeeded()
//            let contentRect: CGRect = self.scrlV.subviews.reduce(into: .zero) { rect, view in
//                rect = rect.union(view.frame)
//            }
//            self.scrlV.contentSize = contentRect.size
        }
    }
    func hidenAndShowBtns(_ edit: Bool){
        btn_saveCan.isHidden = true
//        btn_saveCan.isHidden = !edit
        editView.isHidden = !edit
        editV1.isHidden = !edit
        editV2.isHidden = !edit
        editV3.isHidden = !edit
        editV4.isHidden = !edit
        editV5.isHidden = !edit
        btn_editAdd.isHidden = !edit
        btn_editAdd1.isHidden = !edit

        
        if edit == false {
            addLanHt.constant = 0.0
            addAchHt.constant = 0.0

        }
        else {
            addLanHt.constant = 46.0
            addAchHt.constant = 46.0

        }
        imgEditView.isHidden = !edit
        btn_uploadImg.isHidden = !edit
 
        
        btn_uploadCover.isHidden = !edit
         editMode = !edit
         
        
                    var height1 = CGFloat()
                   
                   height1 = CGFloat(self.eduArrDict.count) * 97.0
                   
                   //let height1 = self.tblEduation.contentSize.height
                   self.heightTableEducation.constant = height1
                   self.tblEduation.needsUpdateConstraints()
                   if edit == false {

                   if (self.eduArrDict.count == 0) {
                       self.view_education.isHidden = true
                       self.vieweduHt.constant = 0.0
                   }
                   else {
                       self.view_education.isHidden = false
                       self.vieweduHt.constant = height1 + 72.0

                   }
                    
                    }
                   else {
                    self.view_education.isHidden = false
                    self.vieweduHt.constant = height1 + 72.0
                    }
                   self.tblEduation.layoutIfNeeded()

                   
                   
                   var height2 = CGFloat()
                   
                   height2 = CGFloat(self.langArrDict.count) * 70.0
                   
                   //let height1 = self.tblEduation.contentSize.height
                   self.langHt.constant = height2
                   self.tbl_lang.needsUpdateConstraints()
                   
                   if edit == false {

                   if (self.langArrDict.count == 0) {
                       self.view_languages.isHidden = true
                       self.viewLanHt.constant = 0.0
                   }
                   else {
                       self.view_languages.isHidden = false
                       self.viewLanHt.constant = height2 + 126.0

                   }
        }
        else {
            self.view_languages.isHidden = false
            self.viewLanHt.constant = height2 + 126.0

        }
                   self.tbl_lang.layoutIfNeeded()

                   
                   
                   var height3 = CGFloat()
                   
                   height3 = CGFloat(self.achieveArrDict.count) * 90.0
                   
                   //let height1 = self.tblEduation.contentSize.height
                   self.tblAchievementHt.constant = height3
                   self.tblAchievement.needsUpdateConstraints()
        if edit == false {
                   if (self.achieveArrDict.count == 0) {
                       self.view_achievement.isHidden = true
                       self.viewAchHt.constant = 0.0
                   }
                   else {
                       self.view_achievement.isHidden = false
                       self.viewAchHt.constant = height3 + 126.0

                   }
        }
        else {
            self.view_achievement.isHidden = false
            self.viewAchHt.constant = height3 + 126.0

        }
                   self.tblAchievement.layoutIfNeeded()
        self.tblAchievement.needsUpdateConstraints()
        self.tblAchievement.layoutIfNeeded()
//        self.scrlCV.needsUpdateConstraints()
//
//        self.scrlCV.layoutIfNeeded()
//
//        self.scrlV.needsUpdateConstraints()
//
//        self.scrlV.layoutIfNeeded()
//        let contentRect: CGRect = self.scrlV.subviews.reduce(into: .zero) { rect, view in
//            rect = rect.union(view.frame)
//        }
//        self.scrlV.contentSize = contentRect.size
        
        
    }
    @IBAction func edit_Achievement(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterAchieveVC") as! HunterAchieveVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func upload_profile(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditProPicVC") as! HunterEditProPicVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func edit_lang(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterLanguage1VC") as! HunterLanguage1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func edit_edu(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterEducationStep2VC") as! HunterEducationStep2VC
        vc.isFrom = "Profile"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func edit_WE(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterWorkExpVC") as! HunterWorkExpVC
        vc.isFrom = "Profile"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func edit_profile(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterCandidateProVC") as! HunterCandidateProVC
        vc.isFrom = "Profile"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
    @IBAction func edit_About(_ sender: Any) {
        // about
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditBioVC") as! HunterEditBioVC
        vc.modalPresentationStyle = .overFullScreen
        vc.txt = txt_desc.text!
        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func edit_Skills(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterSkillSetVC") as! HunterSkillSetVC
        vc.isFrom = "Profile"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func uploadCover(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditCoverImVC") as! HunterEditCoverImVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func cancelProfile(_ sender: Any) {
        hidenAndShowBtns(false)
    }
    @IBAction func editProfile(_ sender: Any) {
        hidenAndShowBtns(true)
    }
    @IBAction func saveProfile(_ sender: Any) {
        hidenAndShowBtns(false)

    }
    @IBAction func addSkill(_ sender: Any) {

        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addExp(_ sender: Any) {

        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addLoc(_ sender: Any) {

        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addJobFunc(_ sender: Any) {

        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func closeSkill(_ sender: UIButton) {
        selectedSkillsArr.remove(at: sender.tag)
        selectedIDSkillsArr.remove(at: sender.tag)
        collectionSkills.reloadData()
        autosizeCollectionView()
    }
    @IBAction func buttonSettings(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterSettingsVC") as! HunterSettingsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    //MARK:- CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return selectedSkillsArr.count

        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if (collectionView == collectionSkills) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterProCollectionCell", for: indexPath) as! HunterProCollectionCell
            cell.titleLabel.text = selectedSkillsArr[indexPath.row].uppercased()
            cell.buttonDelete.tag = indexPath.item
            
            cell.buttonDelete.isHidden = editMode
            
            return cell
 
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
                let label = UILabel(frame: CGRect.zero)
                label.text = selectedSkillsArr[indexPath.row].uppercased()
                label.sizeToFit()
                return CGSize(width: label.frame.width + 18, height: 25)
 
        
    }
        //MARK:- Tableview Delegates
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (tableView == tblWorkExp) {
                return self.expArrDict.count
            }else if (tableView == tblEduation) {
                return self.eduArrDict.count
            }else if (tableView == tbl_lang) {
                return self.langArrDict.count
            }else if (tableView == tblAchievement) {
                return self.achieveArrDict.count
            }
            else {
                return 0
            }
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if (tableView == tblWorkExp) {
               
                return 70.0
                
            }else if (tableView == tblEduation) {
               
                return 97.0
               
           }else if (tableView == tbl_lang) {
               
                return 70.0
               
           }else if (tableView == tblAchievement) {
               
                return 90.0
               
           }else {
                return UITableView.automaticDimension
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            tableView.separatorStyle = .none

            if tableView == tblWorkExp {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterWorEXTableViewCell", for: indexPath) as! HunterWorEXTableViewCell
                cell.selectionStyle = .none
                 
                      
                cell.lab_TitleTxt.text = (self.expArrDict[indexPath.row]["job_title"] as! String).uppercased()
                cell.lab_companyNameTxt.text = (self.expArrDict[indexPath.row]["company_name"] as! String)
 
                 

                
                    cell.lab_StartDateTxt.text = "\(self.expArrDict[indexPath.row]["experience_start"] as! Int) - \(self.expArrDict[indexPath.row]["experience_end"] as! Int) \(self.expArrDict[indexPath.row]["location"] as! String)"
 
                     
                
                return cell
            }else  if tableView == tblEduation {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterEduTableViewCell", for: indexPath) as! HunterEduTableViewCell
            
                cell.selectionStyle = .none
                 
                  cell.lab_TitleTxt.text = (self.eduArrDict[indexPath.row]["school"] as! String).uppercased()
                
                
                
                cell.lab_StartDateTxt.text = "\(self.eduArrDict[indexPath.row]["start_date"] as! Int) - \(self.eduArrDict[indexPath.row]["end_date"] as! Int)"
                    
                cell.lab_MinorTxt.text = self.eduArrDict[indexPath.row]["level_of_study"] as? String
                    cell.lab_MajorTxt.text = self.eduArrDict[indexPath.row]["field_of_study"] as? String
                     
                
                return cell
            }
            else  if tableView == tbl_lang  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterLangTableViewCell", for: indexPath) as! HunterLangTableViewCell
            
                cell.selectionStyle = .none
                 
                cell.lab_TitleTxt.text = (self.langArrDict[indexPath.row]["language"] as! String).uppercased()
                
                
                
                cell.lab_prof.text =  self.langArrDict[indexPath.row]["proficiency"] as? String
                     
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterAchieveTableViewCell", for: indexPath) as! HunterAchieveTableViewCell
            
                cell.selectionStyle = .none
                 
                cell.lab_TitleTxt.text = (self.achieveArrDict[indexPath.row]["title"] as! String).uppercased()
                
                
                
                cell.lab_issuedBy.text =  self.achieveArrDict[indexPath.row]["issued_by"] as? String
                     
                cell.lab_issuedDate.text =  self.achieveArrDict[indexPath.row]["issued_date"] as? String

                return cell
            }
        }
    
    @IBAction func goToSettings(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterSettingsVC") as! HunterSettingsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- Webservice
    func connectToGetProfileData(){
        if HunterUtility.isConnectedToInternet(){
            
            var url = ""
            var parameters = [String : Any]()

            var loginType = String()
            if let type = UserDefaults.standard.object(forKey: "loginType") as? String{
                loginType = type
            }
            // Do any additional setup after loading the view.
            if loginType == "candidate" {
                url = API.candidateBaseURL + API.profileURL
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
                                                if let dataDictionary = responseDict.value(forKey: "data") as? NSDictionary{
                                                    
                                                    let dataDict = dataDictionary["candidate_details"] as! NSDictionary
                                                    print(dataDict)

                                                    self.lab_profileName.text = "\(dataDict["first_name"] as! String) ".uppercased() + "\(dataDict["last_name"] as! String)".uppercased()
                                                    self.firstName = dataDict["first_name"] as! String
                                                    self.lastName = dataDict["last_name"] as! String
                
                                                    
                                                    
                                                    self.skillsArrDict = dataDict["skills"] as! [NSDictionary]
                                                    self.jobArrDict = dataDict["job_functions"] as! [NSDictionary]
                                                    self.expArrDict = dataDict["work_experience"] as! [NSDictionary]
                                                    self.locArrDict = dataDict["preferred_location"] as! [NSDictionary]

                                                    self.langArrDict = dataDict["languages"] as! [NSDictionary]
                                                    self.eduArrDict = dataDict["education"] as! [NSDictionary]
                                                    self.achieveArrDict = dataDict["achievements"] as! [NSDictionary]
                
                                                    
                                                    
                                                    
                                                    
                                                    self.txt_desc.text = dataDict["about"] as? String
                                                    self.profileDesc = dataDict["about"] as? String ?? ""
                                                    
                                                    if self.txt_desc.text == "" {
                                                        self.txt_desc.text = "Type description here"
                                                    }
                                                    
                                                    if let url = dataDict["profile_image"] as? String{
                                                        self.imgv_proPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                                    }
                                                    if let url = dataDict["banner_image"] as? String{
                                                        self.img_thumb.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                                    }
                                                    //reload all tableviews and manage height dynamically
                                                    self.tblWorkExp.reloadData()
                                                    self.tblEduation.reloadData()
                                                    self.tbl_lang.reloadData()
                                                    self.tblAchievement.reloadData()

                                                    
                                                    self.autosizeTableView()

                
                                                    
                //
                                                    
                                                    self.selectedSkillsArr = [String]()
                                                    self.selectedIDSkillsArr = [Int]()
                                                    for skilldict in self.skillsArrDict {
                                                        self.selectedSkillsArr.append(skilldict["skill"] as! String)
                                                        let skillId =  skilldict["id"] as! Int
                                                        self.selectedIDSkillsArr.append(skillId)
                                                    }
                                                    
                                                    
                                                    self.collectionSkills.reloadData()
                                                    self.autosizeCollectionView()

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
            else {
                url = API.recruiterBaseURL + API.candidate_profileURL
                parameters = ["candidate_id": candidate_idPassed, "job_id":job_id]
                print(url)
                            HunterUtility.showProgressBar()
                            
                            let headers = [ "Authorization" : "Bearer " + accessToken]


                            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                                
                                switch response.result {
                                case .success:
                                    if let responseDict = response.result.value as? NSDictionary{
                                        print(responseDict)
                                        SVProgressHUD.dismiss()
                                        if let status = responseDict.value(forKey: "status"){
                                            if status as! Int == 1{
                                                if let dataDictionary = responseDict.value(forKey: "data") as? NSDictionary{
                                                    
                                                    let dataDict = dataDictionary["candidate_details"] as! NSDictionary
                                                    print(dataDict)

                                                    self.lab_profileName.text = "\(dataDict["first_name"] as! String) ".uppercased() + "\(dataDict["last_name"] as! String)".uppercased()
                                                    self.firstName = dataDict["first_name"] as! String
                                                    self.lastName = dataDict["last_name"] as! String
                //                                    self.textSalary.text = (dataDict["preferred_salary"] as! String)
                //                                    self.txt_workType.text = (dataDict["work_type"] as! String)

                //                                    self.lastName = dataDict["last_name"] as! String
                                                    
                                                    self.skillsArrDict = dataDict["skills"] as! [NSDictionary]
                                                    self.jobArrDict = dataDict["job_functions"] as! [NSDictionary]
                                                    self.expArrDict = dataDict["work_experience"] as! [NSDictionary]
                                                    self.locArrDict = dataDict["preferred_location"] as! [NSDictionary]
                //                                    self.socArrDict = dataDict["social_media"] as! [NSDictionary]
                                                    self.langArrDict = dataDict["languages"] as! [NSDictionary]
                                                    self.eduArrDict = dataDict["education"] as! [NSDictionary]
                                                    self.achieveArrDict = dataDict["achievements"] as! [NSDictionary]
                //                                    self.socPNGArr = dataDict["social_media_png"] as! [NSDictionary]

                //                                    self.worked_in_uae = (dataDict["worked_in_uae"] as? String)!
                                                    
                                                    
                                                    
                                                    self.txt_desc.text = dataDict["about"] as? String
                                                    self.profileDesc = dataDict["about"] as? String ?? ""
                                                    
                                                    if self.txt_desc.text == "" {
                                                        self.txt_desc.text = "Type description here"
                                                    }
                                                    
                                                    if let url = dataDict["profile_image"] as? String{
                                                        self.imgv_proPic.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                                    }
                                                    if let url = dataDict["banner_image"] as? String{
                                                        self.img_thumb.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
                                                    }
                                                    //reload all tableviews and manage height dynamically
                                                    self.tblWorkExp.reloadData()
                                                    self.tblEduation.reloadData()
                                                    self.tbl_lang.reloadData()
                                                    self.tblAchievement.reloadData()
                                                    self.autosizeTableView()

                //                                    let profile_completion = dataDict["profile_completion"] as! Int
                //                                    self.lab_perc.text = "\(profile_completion)%"
                //
                //                                    self.progV.progress = Float(profile_completion)/100.0
                //
                                                    
                                                    self.selectedSkillsArr = [String]()
                                                    self.selectedIDSkillsArr = [Int]()
                                                    for skilldict in self.skillsArrDict {
                                                        self.selectedSkillsArr.append(skilldict["skill"] as! String)
                                                        let skillId =  skilldict["id"] as! Int
                                                        self.selectedIDSkillsArr.append(skillId)
                                                    }
                                                    //reload all collectionviews and manage height dynamically
                //                                    self.collSocialM.reloadData()
//                                                    self.collectionLanguages.reloadData()
                //                                    self.collLoc.reloadData()
                //                                    self.coll_jobType.reloadData()
                                                    self.collectionSkills.reloadData()
                                                    self.autosizeCollectionView()

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
            }
            
        }else{
            print("no internet")
        }
    }
}

//MARK:- Tableview cells
class HunterEduTableViewCell: UITableViewCell {
    @IBOutlet weak var img_appIcon: UIImageView!
     
    @IBOutlet weak var lab_TitleTxt: UILabel!
     
    @IBOutlet weak var buttonDelete: UIButton!
     @IBOutlet weak var lab_StartDateTxt: UILabel!
     @IBOutlet weak var lab_MajorTxt: UILabel!
      @IBOutlet weak var lab_MinorTxt: UILabel!
 }
class HunterWorEXTableViewCell: UITableViewCell {
    @IBOutlet weak var img_appIcon: UIImageView!
     @IBOutlet weak var lab_TitleTxt: UILabel!
    @IBOutlet weak var lab_StartDateTxt: UILabel!
    @IBOutlet weak var lab_companyNameTxt: UILabel!

     
}

class HunterLangTableViewCell: UITableViewCell {
      @IBOutlet weak var lab_TitleTxt: UILabel!
    @IBOutlet weak var lab_prof: UILabel!

     
}
class HunterAchieveTableViewCell: UITableViewCell {
      @IBOutlet weak var lab_TitleTxt: UILabel!
    @IBOutlet weak var lab_issuedBy: UILabel!
    @IBOutlet weak var lab_issuedDate: UILabel!

     
}
//class HunterAchieveTableViewCell: UITableViewCell {
//    @IBOutlet weak var img_appIcon: UIImageView!
//    @IBOutlet weak var lab_Title: UILabel!
//    @IBOutlet weak var lab_TitleTxt: UILabel!
//    @IBOutlet weak var view_title: UIView!
//    @IBOutlet weak var buttonDelete: UIButton!
//    @IBOutlet weak var lab_StartDate: UILabel!
//    @IBOutlet weak var lab_StartDateTxt: UILabel!
//    @IBOutlet weak var view_Start: UIView!
//    @IBOutlet weak var lab_Desc: UILabel!
//    @IBOutlet weak var lab_DescTxt: UILabel!
//    @IBOutlet weak var txt_Desc: UITextView!
//    @IBOutlet weak var view_Desc: UIView!
//}
////MARK:- Collectionview cells
//class HunterLangCollectionCell: UICollectionViewCell {
//    @IBOutlet weak var buttonDelete: UIButton!
//    @IBOutlet weak var lab_language: UILabel!
//    @IBOutlet weak var lab_languageTxt: UILabel!
//    @IBOutlet weak var view_language: UIView!
//    @IBOutlet weak var lab_proficiency: UILabel!
//    @IBOutlet weak var lab_proficiencyTxt: UILabel!
//    @IBOutlet weak var view_proficiency: UIView!
//}
//class HunterJobTypeCollectionCell: UICollectionViewCell {
//    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var buttonDelete: UIButton!
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 25/2
//    }
//}
//class HunterLocCollectionCell: UICollectionViewCell {
//    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var buttonDelete: UIButton!
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 25/2
//    }
//}
//class HunterSocialMediaCollectionCell: UICollectionViewCell {
//    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var buttonDelete: UIButton!
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 25/2
//    }
//}
class HunterProCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25/2
    }
}

//extension UIViewController {
//    func showInputDialog1(title:String? = nil,
//                         subtitle:String? = nil,
//                         actionTitle:String? = "Add",
//                         cancelTitle:String? = "Cancel",
//                         inputPlaceholder:String? = nil,
//                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
//                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
//                         actionHandler: ((_ text: String?) -> Void)? = nil) {
//
//        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
//        alert.addTextField { (textField:UITextField) in
//            textField.placeholder = inputPlaceholder
//            textField.keyboardType = inputKeyboardType
//        }
//        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
//            guard let textField =  alert.textFields?.first else {
//                actionHandler?(nil)
//                return
//            }
//            actionHandler?(textField.text)
//        }))
//        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//}
