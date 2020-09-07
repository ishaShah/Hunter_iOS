
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
    
    @IBOutlet weak var addEducationView: UIView!
    @IBOutlet weak var addAchievementView: UIView!
    @IBOutlet weak var addExperienceView: UIView!
    @IBOutlet weak var addLanguageView: UIView!
//    @IBOutlet weak var collLoc: UICollectionView!
//    @IBOutlet weak var coll_jobType: UICollectionView!
//    @IBOutlet weak var collSocialM: UICollectionView!
    @IBOutlet weak var tblAchievement: UITableView!
    @IBOutlet weak var collectionLanguages: UICollectionView!
    @IBOutlet weak var tblEduation: UITableView!
    @IBOutlet weak var tblWorkExp: UITableView!
    
    
    @IBOutlet weak var collectionSkills: UICollectionView!
    @IBOutlet weak var heightCollectionSkills: NSLayoutConstraint!
    @IBOutlet weak var heightTableExperience: NSLayoutConstraint!
    @IBOutlet weak var heightTableAchievement: NSLayoutConstraint!
    @IBOutlet weak var heightTableEducation: NSLayoutConstraint!
    @IBOutlet weak var heightCollectionLang: NSLayoutConstraint!
//    @IBOutlet weak var heightCollectionJobType: NSLayoutConstraint!
//    @IBOutlet weak var heightCollectionLoc: NSLayoutConstraint!

    
//    @IBOutlet weak var constraintTopScrollV: NSLayoutConstraint!
    let headerViewHeight: CGFloat = 198
//    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var lab_profileName: UILabel!
//    @IBOutlet weak var saveBtn: UIButton!
//    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var lab_skills: UILabel!
//    @IBOutlet weak var btn_workExpEdit: UIButton!

    @IBOutlet weak var txt_desc: UITextView!
//    @IBOutlet weak var btn_skilldEdit: UIButton!
//    @IBOutlet weak var btn_proDetails: UIButton!
    
    @IBOutlet weak var btn_uploadCover: UIButton!

    @IBOutlet weak var imgv_proPic: UIImageView!
//    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var imgEditView: UIView!
    
    @IBOutlet weak var img_thumb: UIImageView!
    @IBOutlet weak var btn_uploadImg: UIButton!
    
//    @IBOutlet weak var progV: UIProgressView!
//
//    @IBOutlet weak var buttonAddSkill: UIButton!
//    @IBOutlet weak var heightButtonAddSkill: NSLayoutConstraint!
//    @IBOutlet weak var topButtonAddSkill: NSLayoutConstraint!
//    @IBOutlet weak var labelAddSkill: UILabel!
//
//    @IBOutlet weak var lab_proComp: UILabel!
//    @IBOutlet weak var lab_perc: UILabel!
    var editMode = true
    var isSQImage = false
    var isRGImage = false

    @IBOutlet weak var scrlCV: UIView!
    var selectedSkillsArr = [String]()
    var selectedIDSkillsArr = [Int]()

    var skillsArr = [String]()
    var skillsIDArr = [Int]()
//    @IBOutlet weak var txt_Skill: DropDown!
    var skillAdded = true
    var worked_in_uae = ""
//    @IBOutlet weak var txtSkillW: NSLayoutConstraint!
//    @IBOutlet weak var addSkillW: NSLayoutConstraint!
    
    @IBOutlet weak var scrlV: UIScrollView!
//    @IBOutlet weak var tableExperience: UITableView!
//    @IBOutlet weak var buttonAddExp: UIButton!
//    @IBOutlet weak var heightButtonAddExp: NSLayoutConstraint!
//    @IBOutlet weak var labelAddExp: UILabel!
    var ExpAdded = true

    var UAEExpArr = [String]()
    var UAEExpIDArr = [Int]()
    

    
//    @IBOutlet weak var buttonAddEdu: UIButton!
//    @IBOutlet weak var heightAddEdu: NSLayoutConstraint!
//    @IBOutlet weak var labelAddEdu: UILabel!
    var EduAdded = true
//    @IBOutlet weak var topButtonAddEdu: NSLayoutConstraint!
//
//
//    @IBOutlet weak var buttonAddLang: UIButton!
//    @IBOutlet weak var heightAddLang: NSLayoutConstraint!
//    @IBOutlet weak var labelAddLang: UILabel!
    var LangAdded = true
//    @IBOutlet weak var topButtonAddLang: NSLayoutConstraint!
//
//
//
//    @IBOutlet weak var buttonAddAchievement: UIButton!
//    @IBOutlet weak var heightAddAchievement: NSLayoutConstraint!
//    @IBOutlet weak var labelAddAchievement: UILabel!
    var achieveAdded = true
//    @IBOutlet weak var topButtonAddAchievement: NSLayoutConstraint!
//
//
//    @IBOutlet weak var buttonAddSM: UIButton!
//    @IBOutlet weak var heightAddSM: NSLayoutConstraint!
//    @IBOutlet weak var labelAddSM: UILabel!
    var SMAdded = true
//    @IBOutlet weak var topButtonAddSM: NSLayoutConstraint!
//
//
//    @IBOutlet weak var buttonAddJobType: UIButton!
//    @IBOutlet weak var heightAddJobType: NSLayoutConstraint!
//    @IBOutlet weak var labelAddJobType: UILabel!
//    @IBOutlet weak var topButtonAddJobType: NSLayoutConstraint!
//
//
//    @IBOutlet weak var txt_addloc: DropDown!
//    @IBOutlet weak var labelLoc: UILabel!
//    @IBOutlet weak var buttonAddLoc: UIButton!
//    @IBOutlet weak var heightButtonAddLoc: NSLayoutConstraint!
//    @IBOutlet weak var topButtonAddLoc: NSLayoutConstraint!
//    @IBOutlet weak var labelAddLoc: UILabel!

    var LocAdded = true


    var locationArr = [String]()
    var locationIDArr = [Int]()
    
//    @IBOutlet weak var buttonLocEdit: UIButton!
//    @IBOutlet weak var buttonJobTypeEdit: UIButton!
    
    @IBOutlet weak var labelJobFunc: UILabel!
//    @IBOutlet weak var buttonAddJobFunc: UIButton!
//    @IBOutlet weak var heightButtonAddJobFunc: NSLayoutConstraint!
//    @IBOutlet weak var topButtonAddJobFunc: NSLayoutConstraint!
//    @IBOutlet weak var labelAddJobFunc: UILabel!
//    @IBOutlet weak var txtJobFunc: DropDown!
    var JobFuncAdded = true
//    @IBOutlet weak var txtJobFuncW: NSLayoutConstraint!
//    @IBOutlet weak var addJobFuncW: NSLayoutConstraint!
    var jobFuncArr = [String]()
    var jobFuncIDArr = [Int]()
    
//    @IBOutlet weak var txt_jobType: DropDown!
//    @IBOutlet weak var txt_workType: DropDown!
    var selectedWorkType = Int()
//    @IBOutlet weak var textSalary: UITextField!

    var arrayJobTypes = [String]()

    var arrayExperienceNames = [String]()
    var arrayLocationNames = [String]()
    var locations = ""
    var experience = ""
    var jobs = ""

    @IBOutlet weak var stackName: UIStackView!
//    @IBOutlet weak var constraintHeightNameStack: NSLayoutConstraint!
    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textLastName: UITextField!
    var isNameEdited = false
    var firstName = String()
    var lastName = String()
    var profileDesc = String()
    
    
    
    var skillsArrDict = [NSDictionary]()
    var jobArrDict = [NSDictionary]()
    var expArrDict  = [NSDictionary]()
    var locArrDict  = [NSDictionary]()
    var socArrDict  = [NSDictionary]()
    var langArrDict  = [NSDictionary]()
    var eduArrDict  = [NSDictionary]()
    var achieveArrDict  = [NSDictionary]()
    var socPNGArr  = [NSDictionary]()
    
    
    
    // Exp Pop UP
    
    @IBOutlet weak var WEPopUp_Title: UITextField!
    @IBOutlet weak var WEPopUp_StartDate: UITextField!
    @IBOutlet weak var WEPopUp_EndDate: UITextField!
    @IBOutlet weak var WEPopUp_CompanyName: UITextField!
    @IBOutlet weak var WEPopUp_Loc: DropDown!
    @IBOutlet weak var WEPopUp_Desc: UITextView!
    @IBOutlet weak var WEPopUp_Btn: UIButton!
    var WEPopUp_locid = 0
    var currently_working_here = 0
    
    
    
    // Social Media Pop Up
    @IBOutlet weak var addSocialMediaView: UIView!
    @IBOutlet weak var txt_FB: UITextField!
    @IBOutlet weak var txt_insta: UITextField!
    @IBOutlet weak var txt_twitter: UITextField!
    @IBOutlet weak var txt_GPlus: UITextField!
    @IBOutlet weak var txt_linkdn: UITextField!
    @IBOutlet weak var txt_YT: UITextField!
    
    
    var candidate_idPassed = Int()
    var job_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
          // Do any additional setup after loading the view.
        languageSwitch.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
//        txt_Skill.isHidden = true
//        txt_addloc.isHidden = true
//        txt_jobType.isHidden = true
        
//        self.txtJobFunc.isHidden = true
        self.addSocialMediaView.isHidden = true

        lab_profileName.isHidden = false
//        stackName.isHidden = true
//        constraintHeightNameStack.constant = 20.0
        self.hideKeyboardWhenTappedAround()
 
        
        addEducationView.isHidden = true
        addLanguageView.isHidden = true
        addAchievementView.isHidden = true
        addExperienceView.isHidden = true

        
        hidenAndShowBtns(true)
        scrlCV.roundCorners([.topLeft, .topRight], radius: 20.0)
        scrlV.roundCorners([.topLeft, .topRight], radius: 20.0)

        let alignedFlowLayout = collectionSkills?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.minimumLineSpacing = 5.0
        alignedFlowLayout?.minimumInteritemSpacing = 5.0
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .center
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 53) / 2, height: 80)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionLanguages.collectionViewLayout = layout
        
//        txt_Skill.leftViewEnabled = false
//        WEPopUp_Loc.leftViewEnabled = false
//        txtJobFunc.leftViewEnabled = false
//        txt_workType.leftViewEnabled = false
        
        
        self.WEPopUp_Loc.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
        self.WEPopUp_Loc.selectedRowColor = UIColor.init(hexString: "E8E4F2")
        self.WEPopUp_Loc.textColor = UIColor.white//UIColor.init(hexString: "531B93")
//        self.WEPopUp_Loc.checkMarkEnabled = false
//        self.WEPopUp_Loc.rowHeight = 40.0
        
        // The list of array to display. Can be changed dynamically
        self.WEPopUp_Loc.optionArray = self.locationArr
        //Its Id Values and its optional
        self.WEPopUp_Loc.optionIds = self.locationIDArr
        
        // Image Array its optional
        // The the Closure returns Selected Index and String
        self.WEPopUp_Loc.didSelect{(selectedText , index ,id) in
            print(String(selectedText))
            self.WEPopUp_Loc.text = selectedText
            self.WEPopUp_locid = self.locationIDArr[index]
              
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        connectToGetProfileData()
//        connectToRegisterPreferedSkills()
//        connectToRegisterPreferedCompanies()
//        connectToRegisterPreferedWorkLocations()
//        connectToRegisterPreferedJobs()
//        connectToRegisterPreferedWorkType()

        setNeedsStatusBarAppearanceUpdate()
    }
        
    @IBAction func setSocialMediaLink(_ sender: UIButton) {
        showInputDialog1(title: "Add Link",
                        subtitle: "Please enter the Link below.",
                        actionTitle: "Add",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Link",
                        inputKeyboardType: .default)
        { (input:String?) in
            if sender.tag == 1 {
                self.txt_FB.text = input
            }
            else if sender.tag == 2 {
                self.txt_GPlus.text = input
            }
            else if sender.tag == 3 {
                self.txt_insta.text = input
            }
            else if sender.tag == 4 {
                self.txt_YT.text = input
            }
            else if sender.tag == 5 {
                self.txt_linkdn.text = input
            }
            else if sender.tag == 6 {
                self.txt_twitter.text = input
            }
            self.connectToRegisterSocialMediaFinal(sender.tag, input!)
        }
    }
    func connectToRegisterSocialMediaFinal(_ social_media_id : Int , _ link : String){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.addSocialMediaURL
            print(url)
            HunterUtility.showProgressBar()
            
            
            let paramsDict = ["social_media_id": social_media_id  , "link" : link ] as [String : Any]
            
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                
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
    @IBAction func addCVClick(_ sender: Any) {
    }
    @IBAction func saveSocialMedia(_ sender: Any) {
        self.addSocialMediaView.isHidden = true
        self.connectToGetProfileData()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func addSocialMedia(_ sender: Any) {
        self.addSocialMediaView.isHidden = false
    }
    @IBAction func cancelViews(_ sender: UIButton) {
         addEducationView.isHidden = true
         addLanguageView.isHidden = true
         addAchievementView.isHidden = true
         addExperienceView.isHidden = true
    }
    @IBAction func addExperienceView(_ sender: UIButton) {
         addExperienceView.isHidden = false
    }
    func autosizeCollectionView()  {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.collectionSkills.layoutIfNeeded()
            let height = self.collectionSkills.contentSize.height
            self.heightCollectionSkills.constant = height
            self.collectionSkills.needsUpdateConstraints()
            
            self.collectionLanguages.layoutIfNeeded()
            let height1 = self.collectionLanguages.contentSize.height
            print("height of collectionview language = \(height1)")
            self.heightCollectionLang.constant = height1
            self.collectionLanguages.needsUpdateConstraints()
            
//            self.coll_jobType.layoutIfNeeded()
//            let height2 = self.coll_jobType.contentSize.height
//            self.heightCollectionJobType.constant = height2
//            self.coll_jobType.needsUpdateConstraints()
//
//            self.collLoc.layoutIfNeeded()
//            let height3 = self.collLoc.contentSize.height
//            self.heightCollectionLoc.constant = height3
//            self.collLoc.needsUpdateConstraints()
        }
    }
    func autosizeTableView()  {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.tblWorkExp.layoutIfNeeded()
            var height = CGFloat()
            if (self.editMode){
                height = CGFloat(self.expArrDict.count) * 140.0
            }else {
                height = CGFloat(self.expArrDict.count) * 177.0
            }
            //let height = self.tblWorkExp.contentSize.height
            self.heightTableExperience.constant = height
            self.tblWorkExp.needsUpdateConstraints()
            
            
            self.tblEduation.layoutIfNeeded()
            var height1 = CGFloat()
            if (self.editMode){
                height1 = CGFloat(self.eduArrDict.count) * 120.0
            }else {
                height1 = CGFloat(self.eduArrDict.count) * 150.0
            }
            //let height1 = self.tblEduation.contentSize.height
            self.heightTableEducation.constant = height1
            self.tblEduation.needsUpdateConstraints()
            
            
            self.tblAchievement.layoutIfNeeded()
            var height2 = CGFloat()
            if (self.editMode){
                height2 = CGFloat(self.achieveArrDict.count) * 120.0
            }else {
                height2 = CGFloat(self.achieveArrDict.count) * 152.0
            }
            //let height2 = self.tblAchievement.contentSize.height
            self.heightTableAchievement.constant = height2
            self.tblAchievement.needsUpdateConstraints()
            
        }
    }
    func hidenAndShowBtns(_ edit: Bool){
 
//        editBtn.isHidden = !edit
//        lab_perc.isHidden = edit
//        lab_proComp.isHidden = edit
//        btn_proDetails.isHidden = edit
//        btn_skilldEdit.isHidden = edit
//        cancelBtn.isHidden = edit
//        saveBtn.isHidden = edit
        imgEditView.isHidden = edit
        btn_uploadImg.isHidden = edit
//        btn_workExpEdit.isHidden = edit
//        txt_workType.isHidden = edit
//
//        textSalary.isEnabled = !edit
//        txt_workType.isEnabled = !edit
        
        // Job Func
//        if edit{
//           // self.buttonAddJobFunc.setTitle("+", for: UIControl.State.normal)
//            self.buttonAddJobFunc.setTitleColor(UIColor.white, for: UIControl.State.normal)
//            self.addJobFuncW.constant = 30
//            self.txtJobFuncW.constant = 0
//        }
//        else {
//
//     //   buttonAddJobFunc.setTitle("", for: UIControl.State.normal)
//        self.addJobFuncW.constant = 30
//        self.txtJobFuncW.constant = 0
//
//        }
        // Skill
        
//        buttonAddSkill.isHidden = edit
//        if edit{
//            heightButtonAddSkill.constant = 0.0
//            topButtonAddSkill.constant = 0.0
//        }else{
//            heightButtonAddSkill.constant = 30.0
//            topButtonAddSkill.constant = 10.0
//        }
//        labelAddSkill.isHidden = edit
//
//        // Work Experience
//
//        buttonAddExp.isHidden = edit
//        if edit{
//            heightButtonAddExp.constant = 0.0
////            topButtonAddExp.constant = 0.0
//        }else{
//            heightButtonAddExp.constant = 30.0
////            topButtonAddExp.constant = 10.0
//        }
//        labelAddExp.isHidden = edit
//
//        // Location
//
//        buttonAddLoc.isHidden = edit
//        if edit{
//            heightButtonAddLoc.constant = 0.0
//            topButtonAddLoc.constant = 0.0
//        }else{
//            heightButtonAddLoc.constant = 30.0
//            topButtonAddLoc.constant = 10.0
//        }
//        labelAddLoc.isHidden = edit
//
//        // Job Type
//
//        buttonAddJobFunc.isHidden = edit
//        if edit{
//            heightButtonAddJobFunc.constant = 0.0
//            topButtonAddJobFunc.constant = 0.0
//        }else{
//            heightButtonAddJobFunc.constant = 30.0
//            topButtonAddJobFunc.constant = 10.0
//        }
//        labelAddJobFunc.isHidden = edit
//
//
//        // Job Type
//
//        buttonAddJobType.isHidden = edit
//        if edit{
//            heightAddJobType.constant = 0.0
//            topButtonAddJobType.constant = 0.0
//        }else{
//            heightAddJobType.constant = 30.0
//            topButtonAddJobType.constant = 10.0
//        }
//        labelAddJobType.isHidden = edit
//
//        // Social Media
//
//        buttonAddSM.isHidden = edit
//        if edit{
//            heightAddSM.constant = 0.0
//            topButtonAddSM.constant = 0.0
//        }else{
//            heightAddSM.constant = 30.0
//            topButtonAddSM.constant = 10.0
//        }
//        labelAddSM.isHidden = edit
//
//        // Education
//
//        buttonAddEdu.isHidden = edit
//        if edit{
//            heightAddEdu.constant = 0.0
//            topButtonAddEdu.constant = 0.0
//        }else{
//            heightAddEdu.constant = 30.0
//            topButtonAddEdu.constant = 10.0
//        }
//        labelAddEdu.isHidden = edit
//
//
//        // Language
//
//        buttonAddLang.isHidden = edit
//        if edit{
//            heightAddLang.constant = 0.0
//            topButtonAddLang.constant = 0.0
//        }else{
//            heightAddLang.constant = 30.0
//            topButtonAddLang.constant = 10.0
//        }
//        labelAddLang.isHidden = edit
//
//
//        // Achievement
//
//        buttonAddAchievement.isHidden = edit
//        if edit{
//            heightAddAchievement.constant = 0.0
//            topButtonAddAchievement.constant = 0.0
//        }else{
//            heightAddAchievement.constant = 30.0
//            topButtonAddAchievement.constant = 10.0
//        }
//        labelAddAchievement.isHidden = edit
//
        
        btn_uploadCover.isHidden = edit
         txt_desc.isEditable = !edit
        editMode = edit
        collectionSkills.reloadData()
         
        collectionLanguages.reloadData()
 
        autosizeCollectionView()
        
        tblWorkExp.reloadData()
        tblEduation.reloadData()
        tblAchievement.reloadData()

        autosizeTableView()
        
    }
    @IBAction func buttonEditProfileName(_ sender: UIButton) {
        textFirstName.text = firstName
        textLastName.text = lastName
        isNameEdited = true
        lab_profileName.isHidden = true
        stackName.isHidden = false
//        constraintHeightNameStack.constant = 40.0
    }
    @IBAction func squarePicsBtnClick(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.ratioPreset =  "square"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.ratioPreset =  "square"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func uploadCover(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.ratioPreset =  "rect"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.ratioPreset =  "rect"
            
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        
        let presentationController = alertController.popoverPresentationController
        presentationController?.barButtonItem = (sender as! UIBarButtonItem)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func cancelProfile(_ sender: Any) {
        lab_profileName.isHidden = false
//        stackName.isHidden = true
//        constraintHeightNameStack.constant = 20.0
//        txt_Skill.resignFirstResponder()
 
        self.txt_desc.text = self.profileDesc
        hidenAndShowBtns(true)
    }
    @IBAction func editProfile(_ sender: Any) {
        hidenAndShowBtns(false)
    }
    @IBAction func saveProfile(_ sender: Any) {
        hidenAndShowBtns(true)
        connectToUpdateProfileDetails()
    }
    @IBAction func addSkill(_ sender: Any) {
//        buttonAddSkill.setTitle("", for: UIControl.State.normal)
//        addSkillW.constant = 150
//        txtSkillW.constant = 150
//        txt_Skill.isHidden = false
//        txt_Skill.becomeFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addExp(_ sender: Any) {
//        buttonAddExp.setTitle("", for: UIControl.State.normal)
         
        //        txt_Skill.becomeFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addLoc(_ sender: Any) {
//        buttonAddLoc.setTitle("", for: UIControl.State.normal)
         
        //        txt_Skill.becomeFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func addJobFunc(_ sender: Any) {
//        buttonAddJobFunc.setTitle("", for: UIControl.State.normal)
//        addJobFuncW.constant = 150
//        txtJobFuncW.constant = 150
//        txtJobFunc.isHidden = false
        //        txt_Skill.becomeFirstResponder()
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
    @objc func closeWE(sender: UIButton){
         let tag = sender.tag
         let expId = (self.expArrDict[tag]["id"] as! Int)
         self.connectToCloseWE(experience_id: expId)
     }
     @IBAction func WEPopUp_save(_ sender: Any) {
         if WEPopUp_Title.text!.isEmpty {
             self.view.makeToast("Please enter Title")
         }else if WEPopUp_CompanyName.text!.isEmpty {
                 self.view.makeToast("Please enter Company Name")
         }else if WEPopUp_Loc.text!.isEmpty {
             self.view.makeToast("Please enter Location")
         }else if WEPopUp_StartDate.text!.isEmpty {
             self.view.makeToast("Please enter Start Date")
         }else if WEPopUp_EndDate.text!.isEmpty {
             self.view.makeToast("Please enter End Date")
         }else if WEPopUp_StartDate.text!.isEmpty {
             self.view.makeToast("Please enter Start Date")
         }else {
            connectToAddWE()
         }
     }
    //MARK:- Image picker delegate
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    var ratioPreset = ""
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        //cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
        
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
        
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        if self.ratioPreset == "square" {
            cropController.aspectRatioPreset = .presetSquare;
        }
        else if self.ratioPreset == "min4" {
            cropController.aspectRatioPreset = .presetSquare;
        }
        else {
            cropController.aspectRatioPreset = .preset16x9;
        }
        //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        cropController.aspectRatioPickerButtonHidden = true
        
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
        
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        // self.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
    //MARK:- Cropview delegates
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        if self.ratioPreset == "square" {
            imgv_proPic.image = image
            isSQImage = true
        }else {
            img_thumb.image = image
            isRGImage = true
        }
        
        //        layoutImageView()
        cropViewController.dismiss(animated: true, completion: nil)
    }
    //MARK:- CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionSkills){
            return selectedSkillsArr.count
        }
//        else if (collectionView == coll_jobType ) {
//            return self.jobArrDict.count
//        }else if (collectionView == collLoc ) {
//            return self.locArrDict.count
//        }
        else if (collectionView == collectionLanguages ) {
            return self.langArrDict.count
        }else {
            return self.socPNGArr.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == collectionSkills) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterProCollectionCell", for: indexPath) as! HunterProCollectionCell
            cell.titleLabel.text = selectedSkillsArr[indexPath.row].uppercased()
            cell.buttonDelete.tag = indexPath.item
            
            cell.buttonDelete.isHidden = editMode
            
            return cell
        }else if (collectionView == collectionLanguages) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterLangCollectionCell", for: indexPath) as! HunterLangCollectionCell
            
            cell.buttonDelete.tag = indexPath.item
          
            cell.lab_languageTxt.text = (self.langArrDict[indexPath.row]["language"] as! String).uppercased()
            if let proviciency = self.langArrDict[indexPath.row]["proficiency"] as? Int{
                if proviciency == 0{
                    cell.lab_proficiencyTxt.text = "Native Proficiency"
                }else{
                    cell.lab_proficiencyTxt.text = "Elementary Proficiency"
                }
            }
            cell.buttonDelete.isHidden = editMode
                 
            return cell
        }
//        else if (collectionView == coll_jobType) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterJobTypeCollectionCell", for: indexPath) as! HunterJobTypeCollectionCell
//
//            let job_type = jobArrDict[indexPath.row]["job_function"] as! String
//
//            cell.titleLabel.text = job_type.uppercased()
//            cell.buttonDelete.tag = indexPath.item
//
//            cell.buttonDelete.isHidden = editMode
//
//            return cell
//        }
//        else if (collectionView == collSocialM) {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterSocialMediaCollectionCell", for: indexPath) as! HunterSocialMediaCollectionCell
//            let url = socPNGArr[indexPath.item]["icon"] as! String
//            cell.userImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app-icon"))
////            cell.userImageView.contentMode = .scaleAspectFit
//            cell.buttonDelete.tag = indexPath.item
//
//            cell.buttonDelete.isHidden = editMode
//
//            return cell
//        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterLocCollectionCell", for: indexPath) as! HunterLocCollectionCell
            let location = locArrDict[indexPath.row]["location"] as! String

            cell.titleLabel.text = location.uppercased()
            cell.buttonDelete.tag = indexPath.item
            
            cell.buttonDelete.isHidden = editMode
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionLanguages) {
            return CGSize(width: (UIScreen.main.bounds.width - 53) / 2, height: 80.0)
        }else if (collectionView == collectionSkills){
            if editMode == true {
                let label = UILabel(frame: CGRect.zero)
                label.text = selectedSkillsArr[indexPath.row].uppercased()
                label.sizeToFit()
                return CGSize(width: label.frame.width, height: 25)
            }else {
                let label = UILabel(frame: CGRect.zero)
                label.text = selectedSkillsArr[indexPath.row].uppercased()
                label.sizeToFit()
                return CGSize(width: label.frame.width + 18, height: 25)
            }
        }
//        else if (collectionView == coll_jobType){
//            if editMode == true {
//                let label = UILabel(frame: CGRect.zero)
//                let job_type = jobArrDict[indexPath.row]["job_function"] as! String
//                label.text = job_type.uppercased()
//                label.sizeToFit()
//                return CGSize(width: label.frame.width, height: 25)
//            }else {
//                let label = UILabel(frame: CGRect.zero)
//                let job_type = jobArrDict[indexPath.row]["job_function"] as! String
//                label.text = job_type.uppercased()
//                label.sizeToFit()
//                return CGSize(width: label.frame.width + 18, height: 25)
//            }
//        }
//       else if (collectionView == collLoc){
//            if editMode == true {
//                let label = UILabel(frame: CGRect.zero)
//                let job_type = locArrDict[indexPath.row]["location"] as! String
//                label.text = job_type.uppercased()
//                label.sizeToFit()
//                return CGSize(width: label.frame.width, height: 25)
//            }else {
//                let label = UILabel(frame: CGRect.zero)
//                let job_type = locArrDict[indexPath.row]["location"] as! String
//                label.text = job_type.uppercased()
//                label.sizeToFit()
//                return CGSize(width: label.frame.width + 18, height: 25)
//            }
//        }
        else {
            return CGSize(width: 35, height: 35)
        }
    }
        //MARK:- Tableview Delegates
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (tableView == tblWorkExp) {
                return self.expArrDict.count
            }else if (tableView == tblEduation) {
                return self.eduArrDict.count
            }else if (tableView == tblAchievement) {
                return self.achieveArrDict.count
            }else {
                return 0
            }
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if (tableView == tblWorkExp) {
                if (editMode){
                    return 140.0
                }else {
                    return 177.0
                }
            }else if (tableView == tblEduation) {
               if (editMode){
                   return 120.0
               }else {
                   return 150.0
               }
           }else {
                return UITableView.automaticDimension
                /*if (editMode){
                    return 120.0
                }else {
                    return 152.0
                }*/
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == tblWorkExp {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterWorEXTableViewCell", for: indexPath) as! HunterWorEXTableViewCell
                cell.selectionStyle = .none
                cell.buttonDelete.tag = indexPath.item
                cell.buttonDelete.addTarget(target, action: #selector(closeWE(sender:)), for: .touchUpInside)
                      
                cell.lab_TitleTxt.text = (self.expArrDict[indexPath.row]["job_title"] as! String).uppercased()
                cell.lab_companyNameTxt.text = (self.expArrDict[indexPath.row]["company_name"] as! String)
                cell.lab_locationTxt.text = (self.expArrDict[indexPath.row]["location"] as! String)

                cell.buttonDelete.isHidden = editMode
                cell.lab_Title.isHidden = editMode
                cell.lab_EndDate.isHidden = editMode
                cell.lab_StartDate.isHidden = editMode
                cell.lab_location.isHidden = editMode
                cell.lab_companyName.isHidden = editMode
                cell.view_title.isHidden = editMode
                cell.view_End.isHidden = editMode
                cell.view_Start.isHidden = editMode
                cell.view_Location.isHidden = editMode
                cell.view_comoanyName.isHidden = editMode

                if (editMode){
                    cell.lab_Title.text = ""
                    cell.lab_EndDate.text = ""
                    cell.lab_StartDate.text = ""
                    cell.lab_location.text = ""
                    cell.lab_companyName.text = ""
                    
                    cell.lab_StartDateTxt.text = "\(self.expArrDict[indexPath.row]["experience_start"] as! Int) - \(self.expArrDict[indexPath.row]["experience_end"] as! Int)"
                    cell.lab_EndDateTxt.text = ""
                }else {
                    cell.lab_StartDateTxt.text = "\(self.expArrDict[indexPath.row]["experience_start"] as! Int)"
                    cell.lab_EndDateTxt.text = "\(self.expArrDict[indexPath.row]["experience_end"] as! Int)"

                    cell.lab_Title.text = "Title"
                    cell.lab_EndDate.text = "End Date"
                    cell.lab_StartDate.text = "Start Date"
                    cell.lab_location.text = "Location"
                    cell.lab_companyName.text = "Company Name"
                }
                return cell
            }else if tableView == tblEduation {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterEduTableViewCell", for: indexPath) as! HunterEduTableViewCell
            
                cell.selectionStyle = .none
                cell.buttonDelete.tag = indexPath.item
                cell.buttonDelete.isHidden = editMode
                 
                cell.lab_TitleTxt.text = (self.eduArrDict[indexPath.row]["school"] as! String).uppercased()
                
                cell.lab_Title.isHidden = editMode
                cell.lab_EndDate.isHidden = editMode
                cell.lab_StartDate.isHidden = editMode
                cell.lab_Major.isHidden = editMode
                cell.lab_Minor.isHidden = editMode
                
                
                cell.view_title.isHidden = editMode
                cell.view_End.isHidden = editMode
                cell.view_Start.isHidden = editMode
                cell.view_Major.isHidden = editMode
                cell.view_Minor.isHidden = editMode
                
                if (editMode){
                    cell.lab_Title.text = ""
                    cell.lab_EndDate.text = ""
                    cell.lab_StartDate.text = ""
                    cell.lab_Major.text = ""
                    cell.lab_Minor.text = ""
                   
                    cell.lab_StartDateTxt.text = "\(self.eduArrDict[indexPath.row]["start_date"] as! Int) - \(self.eduArrDict[indexPath.row]["end_date"] as! Int)"
                    cell.lab_MajorTxt.text = "Major: \(self.eduArrDict[indexPath.row]["field_of_study"] as! String)"
                    cell.lab_MinorTxt.text = ""
                    //"Minor: \(self.eduArrDict[indexPath.row]["field_of_study_minor"] as! String)"
                    cell.lab_EndDateTxt.text = ""
                }else {
                    cell.lab_StartDateTxt.text = "\(self.eduArrDict[indexPath.row]["start_date"] as! Int)"
//                    cell.lab_MinorTxt.text = self.eduArrDict[indexPath.row]["field_of_study_minor"] as? String
                    cell.lab_MajorTxt.text = self.eduArrDict[indexPath.row]["field_of_study"] as? String
                    cell.lab_EndDateTxt.text = "\(self.eduArrDict[indexPath.row]["end_date"] as! Int)"
                    cell.lab_Title.text = "Title"
                    cell.lab_EndDate.text = "End Date"
                    cell.lab_StartDate.text = "Start Date"
                    cell.lab_Major.text = "Field of study (Major)"
                    cell.lab_Minor.text = "Field of study (Minor)"
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HunterAchieveTableViewCell", for: indexPath) as! HunterAchieveTableViewCell
                
                cell.lab_TitleTxt.text = (self.achieveArrDict[indexPath.row]["title"] as! String).uppercased()
                cell.lab_StartDateTxt.text = self.achieveArrDict[indexPath.row]["honor_date"] as? String
                cell.lab_DescTxt.text = self.achieveArrDict[indexPath.row]["description"] as? String

                cell.selectionStyle = .none
                cell.buttonDelete.tag = indexPath.item
                cell.buttonDelete.isHidden = editMode
//                cell.lab_Title.isHidden = editMode
//                cell.lab_StartDate.isHidden = editMode
//                cell.lab_Desc.isHidden = editMode
//                cell.view_title.isHidden = editMode
//                cell.view_Start.isHidden = editMode
//                cell.view_Desc.isHidden = editMode
            
                if (editMode){
                    cell.lab_Title.text = ""
                    cell.lab_StartDate.text = ""
                    cell.lab_Desc.text = ""
                }else {
                    cell.lab_Title.text = "Title"
                    cell.lab_StartDate.text = "Honor Date"
                    cell.lab_Desc.text = "Description"
                }
                return cell
            }
        }
    //MARK:- Textfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //MARK:- Textview Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txt_desc{
            if textView.text == "Type description here"{
                textView.text = ""
            }
        }else if textView == txt_descAchievement{
            if textView.text == "Description"{
                textView.text = ""
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txt_desc{
            if textView.text == ""{
                textView.text = "Type description here"
            }
        }else if textView == txt_descAchievement{
            if textView.text == ""{
                textView.text = "Description"
            }
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
                                                    self.collectionLanguages.reloadData()
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
                                                    self.collectionLanguages.reloadData()
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
    func connectToUpdateProfileDetails(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.profileUpdateURL
            print(url)
            HunterUtility.showProgressBar()
            
            var parameters = [String : Any]()
            
            var desc = String()
            if txt_desc.text == "Type description here"{
                desc = ""
            }else{
                desc = txt_desc.text
            }
            
            parameters = ["description": desc, "job_skils": self.selectedIDSkillsArr]
            if isNameEdited{
                parameters["first_name"] = textFirstName.text!
                parameters["last_name"] = textLastName.text!
            }
            
            if LocAdded{
                parameters["job_locations"] = locationIDArr
            }
            
            if ExpAdded{
                parameters["work_experience"] = UAEExpArr
            }
            
            if JobFuncAdded{
                parameters["job_types"] = jobFuncIDArr
            }
            
//            parameters["preferred_salary"] = textSalary.text!
            parameters["preferred_work_type"] = selectedWorkType

            print(parameters)
            
            let headers    = [ "Authorization" : "Bearer " + accessToken, "Content-type": "multipart/form-data"]
            print(headers)
            
            let imageData = imgv_proPic.image!.pngData()
            let imageDataRect = img_thumb.image!.pngData()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                if self.isSQImage == true {
                    if let data = imageData{
                        multipartFormData.append(data, withName: "profile_image", fileName: "image.png", mimeType: "image/png")
                    }
                }
                
                if self.isRGImage == true {
                    if let data = imageDataRect{
                        multipartFormData.append(data, withName: "rectangle_logo", fileName: "image.png", mimeType: "image/png")
                    }
                }
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
                switch result{
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        print(response.result.value!)
                        SVProgressHUD.dismiss()
                        let dict = (response.result.value!) as! NSDictionary
                        if self.isSQImage == true {
                            self.isSQImage = false
                        }
                        if self.isRGImage == true {
                            self.isRGImage = false
                        }
                        
                        if dict.value(forKey: "status") as! Bool == true{
                            DispatchQueue.main.async {
                                self.lab_profileName.isHidden = false
//                                self.stackName.isHidden = true
//                                self.constraintHeightNameStack.constant = 20.0
                                self.lab_profileName.text = self.firstName.uppercased() + " " + self.lastName.uppercased()
                            }
                            self.view.makeToast(dict["message"] as? String, duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
                        }
                        else if dict.value(forKey: "status") as! Int == 2 {
                            let alert = UIAlertController(title: "", message: dict.value(forKey: "message") as? String, preferredStyle: .alert)
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
                            let alert = UIAlertController(title: "", message: dict.value(forKey: "error") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    SVProgressHUD.dismiss()
                    
                }
            }
        }else{
            self.view.makeToast("Please check your internet connection.", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
        }
    }
//    func connectToRegisterPreferedWorkType(){
//        if HunterUtility.isConnectedToInternet(){
//
//            let url = API.candidateBaseURL + API.registerPreferedWorkTypeURL
//            print(url)
//            HunterUtility.showProgressBar()
//
//            let headers = ["Authorization" : "Bearer " + accessToken]
//
//            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1{
//                                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
//                                    self.arrayJobTypes = dataDict.allValues as! [String]
//                                    print(dataDict.allValues)
//
//
//                                    self.txt_workType.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
//                                    self.txt_workType.selectedRowColor = UIColor.init(hexString: "E8E4F2")
//                                 //   self.txt_workType.textColor = UIColor.white//UIColor.init(hexString: "531B93")
//                                    self.txt_workType.checkMarkEnabled = false
//                                    self.txt_workType.rowHeight = 40.0
//
//                                    // The list of array to display. Can be changed dynamically
//                                    self.txt_workType.optionArray = self.arrayJobTypes
//                                    //Its Id Values and its optional
//                                    self.txt_workType.optionIds =  dataDict.allKeys as? [Int]
//
//                                    // Image Array its optional
//                                    // The the Closure returns Selected Index and String
//                                    self.txt_workType.didSelect{(selectedText , index ,id) in
//                                        print(String(selectedText))
//                                        self.txt_workType.text = selectedText
//
//                                        self.selectedWorkType = index
//                                    }
//
//
//                                }
//                            }else if status as! Int == 2 {
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//                                print("Logout api")
//
//                                UserDefaults.standard.removeObject(forKey: "accessToken")
//                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
//                                accessToken = String()
//
//                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
//                                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
//                                navigationController.viewControllers = [mainRootController]
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window?.rootViewController = navigationController
//                            }
//                            else{
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                        else{
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }else{
//                        SVProgressHUD.dismiss()
//                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
//                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
//                        //                        self.present(alert, animated: true, completion: nil)
//                    }
//
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//            print("no internet")
//        }
//    }
//    func connectToRegisterPreferedSkills(){
//        if HunterUtility.isConnectedToInternet(){
//            let url = API.candidateBaseURL + API.registerPreferedSkillsURL
//            print(url)
//            HunterUtility.showProgressBar()
//
//            let headers    = [ "Authorization" : "Bearer " + accessToken]
//
//            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1 {
//                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
//                                print (data)
//                                for locData in data {
//                                    print (locData)
//                                    self.skillsArr.append(locData.value(forKey: "skill") as! String)
//                                    self.skillsIDArr.append(locData.value(forKey: "id") as! Int)
//                                }
//                                self.txt_Skill.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
//                                self.txt_Skill.selectedRowColor = UIColor.init(hexString: "E8E4F2")
//                                self.txt_Skill.textColor = UIColor.white//UIColor.init(hexString: "531B93")
//                                self.txt_Skill.checkMarkEnabled = false
//                                self.txt_Skill.rowHeight = 40.0
//
//                                // The list of array to display. Can be changed dynamically
//                                self.txt_Skill.optionArray = self.skillsArr
//                                //Its Id Values and its optional
//                                self.txt_Skill.optionIds = self.skillsIDArr
//
//                                // Image Array its optional
//                                // The the Closure returns Selected Index and String
//                                self.txt_Skill.didSelect{(selectedText , index ,id) in
//                                print(String(selectedText))
//                                self.txt_Skill.text = selectedText
//
//                                self.selectedSkillsArr.append(self.skillsArr[index])
//                                self.selectedIDSkillsArr.append(self.skillsIDArr[index])
//
//                                // The list of array to display. Can be changed dynamically
//                                self.txt_Skill.optionArray = self.skillsArr
//                                //Its Id Values and its optional
//                                self.txt_Skill.optionIds = self.skillsIDArr
//
//                                self.buttonAddSkill.setTitle("+", for: UIControl.State.normal)
//                                self.addSkillW.constant = 30
//                                self.txtSkillW.constant = 0
//                                self.txt_Skill.isHidden = true
//
//                                self.collectionSkills.reloadData()
//                                self.autosizeCollectionView()
//
//                                UIView.animate(withDuration: 0.5) {
//                                    self.view.layoutIfNeeded()
//                                }
//                            }
//                        }else if status as! Int == 2 {
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//
//                            print("Logout api")
//
//                            UserDefaults.standard.removeObject(forKey: "accessToken")
//                            UserDefaults.standard.removeObject(forKey: "loggedInStat")
//                            accessToken = String()
//
//                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                            let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
//                            let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
//                            navigationController.viewControllers = [mainRootController]
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.window?.rootViewController = navigationController
//                        }else{
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }else{
//                        let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                        }))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//            print("no internet")
//        }
//    }
//    func connectToRegisterPreferedCompanies(){
//        if HunterUtility.isConnectedToInternet(){
//
//            let url = API.candidateBaseURL + API.registerPreferedCompaniesURL
//            print(url)
//            HunterUtility.showProgressBar()
//
//
//            let headers    = [ "Authorization" : "Bearer " + accessToken]
//
//            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1{
//                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
//                                print (data)
//                                var UAEExpArrNew = [String]()
//                                var UAEExpIDArrNew = [Int]()
//                                for locData in data {
//                                    print (locData)
//                                    UAEExpArrNew.append(locData.value(forKey: "company_name") as! String)
//                                    UAEExpIDArrNew.append(locData.value(forKey: "id") as! Int)
//                                }
//                            }else if status as! Int == 2 {
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//                                print("Logout api")
//
//                                UserDefaults.standard.removeObject(forKey: "accessToken")
//                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
//                                accessToken = String()
//
//                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
//                                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
//                                navigationController.viewControllers = [mainRootController]
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window?.rootViewController = navigationController
//                            }
//                            else{
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }else{
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//            print("no internet")
//        }
//    }
//    func connectToRegisterPreferedWorkLocations(){
//        if HunterUtility.isConnectedToInternet(){
//
//            let url = API.candidateBaseURL + API.registerPreferedLocationsURL
//            print(url)
//            HunterUtility.showProgressBar()
//
//
//            let headers    = [ "Authorization" : "Bearer " + accessToken]
//
//            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1{
//                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
//                                print (data)
//                                var locationArrNew = [String]()
//                                var locationIDArrNew = [Int]()
//                                for locData in data {
//                                    print (locData)
//                                    locationArrNew.append(locData.value(forKey: "location") as! String)
//                                    locationIDArrNew.append(locData.value(forKey: "id") as! Int)
//                                }
//                            }else if status as! Int == 2 {
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//                                print("Logout api")
//
//                                UserDefaults.standard.removeObject(forKey: "accessToken")
//                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
//                                accessToken = String()
//
//                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
//                                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
//                                navigationController.viewControllers = [mainRootController]
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window?.rootViewController = navigationController
//                            }
//                            else{
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }else{
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//            print("no internet")
//        }
//    }
//    func connectToRegisterPreferedJobs(){
//        if HunterUtility.isConnectedToInternet(){
//
//            let url = API.candidateBaseURL + API.registerPreferedJobsURL
//            print(url)
//            HunterUtility.showProgressBar()
//
//
//            let headers    = [ "Authorization" : "Bearer " + accessToken]
//
//            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//
//                switch response.result {
//                case .success:
//                    if let responseDict = response.result.value as? NSDictionary{
//                        print(responseDict)
//                        SVProgressHUD.dismiss()
//                        if let status = responseDict.value(forKey: "status"){
//                            if status as! Int == 1{
//                                let data = responseDict.value(forKey: "data") as! [NSDictionary]
//                                print (data)
//                                var jobFuncArrNew = [String]()
//                                var jobFuncIDArrNew = [Int]()
//                                for locData in data {
//                                    print (locData)
//                                    jobFuncArrNew.append(locData.value(forKey: "job_function") as! String)
//                                    jobFuncIDArrNew.append(locData.value(forKey: "id") as! Int)
//                                }
//                                self.txtJobFunc.rowBackgroundColor = UIColor.init(hexString: "E8E4F2")
//                                self.txtJobFunc.selectedRowColor = UIColor.init(hexString: "E8E4F2")
//                                self.txtJobFunc.textColor = UIColor.init(hexString: "531B93")
//
//                                self.txtJobFunc.checkMarkEnabled = false
//                                self.txtJobFunc.rowHeight = 40.0
//
//                                // The list of array to display. Can be changed dynamically
//                                self.txtJobFunc.optionArray = jobFuncArrNew
//                                //Its Id Values and its optional
//                                self.txtJobFunc.optionIds = jobFuncIDArrNew
//
//                                // Image Array its optional
//                                // The the Closure returns Selected Index and String
//                                self.txtJobFunc.didSelect{(selectedText , index ,id) in
//
//                                self.jobFuncArr.append(jobFuncArrNew[index])
//                                self.jobFuncIDArr.append(jobFuncIDArrNew[index])
//
//                                self.txtJobFunc.text = ""
//
//
////                                if self.selectedjobFuncArr.count > 0 {
////                                    self.lab_suggestions.isHidden = true
////                                }
////                                else {
////                                    self.lab_suggestions.isHidden = false
////                                }
//
//                                if self.jobs == "" {
//                                    self.jobs = self.jobs + selectedText
//                                }else {
//                                    self.jobs = self.jobs + ", " + selectedText
//                                }
//                                self.labelJobFunc.text = self.jobs
//                                    self.buttonAddJobFunc.setTitle("+", for: UIControl.State.normal)
//                                    self.addJobFuncW.constant = 30
//                                    self.txtJobFuncW.constant = 0
//                                    self.txtJobFunc.isHidden = true
//                                    self.JobFuncAdded = true
//                                }
//                            }else if status as! Int == 2 {
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//                                print("Logout api")
//
//                                UserDefaults.standard.removeObject(forKey: "accessToken")
//                                UserDefaults.standard.removeObject(forKey: "loggedInStat")
//                                accessToken = String()
//
//                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
//                                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
//                                navigationController.viewControllers = [mainRootController]
//                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.window?.rootViewController = navigationController
//                            }
//                            else{
//                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }else{
//                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    print(error)
//                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            }
//        }else{
//            print("no internet")
//        }
//    }
    func connectToAddWE(){
        if HunterUtility.isConnectedToInternet(){
            
            let url = API.candidateBaseURL + API.addWorkExpURL
            print(url)
            HunterUtility.showProgressBar()
            

//            job_title
//            company_name
//            location_id
//            experience_start
//            experience_end
//            description
//            currently_working_here (0: not working 1 : working)

            let headers    = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["job_title": WEPopUp_Title.text! , "company_name": WEPopUp_CompanyName.text! , "location_id": self.WEPopUp_locid , "experience_start": WEPopUp_StartDate.text! , "experience_end": WEPopUp_EndDate.text! , "description": WEPopUp_Desc.text!, "currently_working_here" : Int(currently_working_here) ] as [String : Any]

            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        self.connectToGetProfileData()
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
    func connectToCloseWE(experience_id : Int){
           if HunterUtility.isConnectedToInternet(){
               let url = API.candidateBaseURL + API.deleteWorkExpURL
               print(url)
               HunterUtility.showProgressBar()
               
               let headers    = [ "Authorization" : "Bearer " + accessToken]
                let paramsDict = ["experience_id": experience_id] as [String : Any]

               Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                   
                   switch response.result {
                   case .success:
                       if let responseDict = response.result.value as? NSDictionary{
                           print(responseDict)
                           SVProgressHUD.dismiss()
                        self.connectToGetProfileData()
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
    func connectToSaveNewEducation(){
       if HunterUtility.isConnectedToInternet(){
            let url = API.candidateBaseURL + API.addEduQualificationURL
            print(url)
            HunterUtility.showProgressBar()
           
            let headers = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["school": txt_school.text!,
                              "field_of_study_major": txt_major.text!,
                              "field_of_study_minor": txt_minor.text!,
                              "start_date": txt_startDateEdu.text!,
                              "end_date": txt_endDateEdu.text!,
                              "currenly_studying_here": currentlyStudying] as [String : Any]

           Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
               
               switch response.result {
               case .success:
                   if let responseDict = response.result.value as? NSDictionary{
                       print(responseDict)
                       SVProgressHUD.dismiss()
                       if let status = responseDict.value(forKey: "status"){
                        if status as! Int == 1{
                            DispatchQueue.main.async {
                                self.txt_school.text = ""
                                self.txt_major.text = ""
                                self.txt_minor.text = ""
                                self.txt_startDateEdu.text = ""
                                self.txt_endDateEdu.text = ""
                                self.buttonCurrentlyStudyHere.setImage(UIImage(named: "checkmark.seal"), for: .normal)
                                self.currentlyStudying = 0
                                self.addEducationView.isHidden = true
                                self.connectToGetProfileData()
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
                           }else{
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
    func connectToSaveNewLanguage(){
           if HunterUtility.isConnectedToInternet(){
                let url = API.candidateBaseURL + API.saveLangURL
                print(url)
                HunterUtility.showProgressBar()
               
                let headers    = [ "Authorization" : "Bearer " + accessToken]
                let paramsDict = ["language": txt_lang.text!,
                                  "proficiency": proficiency] as [String : Any]

               Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                   
                   switch response.result {
                   case .success:
                       if let responseDict = response.result.value as? NSDictionary{
                           print(responseDict)
                           SVProgressHUD.dismiss()
                           if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1{
                                DispatchQueue.main.async {
                                    self.txt_lang.text = ""
                                    self.languageSwitch.isOn = true
                                    self.proficiency = 1
                                    self.addLanguageView.isHidden = true
                                }
                                self.connectToGetProfileData()
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
    func connectToSaveAchievement(){
       if HunterUtility.isConnectedToInternet(){
           
           let url = API.candidateBaseURL + API.addAchievementURL
           print(url)
           HunterUtility.showProgressBar()

            var desc = String()
            if txt_descAchievement.text == "Description"{
                desc = ""
            }else{
                desc = txt_descAchievement.text
            }
            let headers    = [ "Authorization" : "Bearer " + accessToken]
            let paramsDict = ["title": txt_title.text!,
                              "honor_date": txt_honorDate.text!,
                              "description" : desc ] as [String : Any]

           Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
               
               switch response.result {
               case .success:
                   if let responseDict = response.result.value as? NSDictionary{
                       print(responseDict)
                       SVProgressHUD.dismiss()
                       if let status = responseDict.value(forKey: "status"){
                        if status as! Int == 1{
                            DispatchQueue.main.async {
                                self.txt_title.text = ""
                                self.txt_honorDate.text = ""
                                self.addAchievementView.isHidden = true
                            }
                            self.connectToGetProfileData()
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
    func connectToDelete(deleteURL: String, paramKey: String, paramID: Int){
        if HunterUtility.isConnectedToInternet(){
             let url = API.candidateBaseURL + deleteURL
             print(url)
             HunterUtility.showProgressBar()
            
             let headers = [ "Authorization" : "Bearer " + accessToken]
             let paramsDict = [paramKey: paramID]
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                         if status as! Int == 1{
                            self.connectToGetProfileData()
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
                            }else{
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
 //MARK:- Education view functions and outlets
    @IBOutlet weak var txt_school: UITextField!
    @IBOutlet weak var txt_major: UITextField!
    @IBOutlet weak var txt_minor: UITextField!
    @IBOutlet weak var txt_startDateEdu: UITextField!
    @IBOutlet weak var txt_endDateEdu: UITextField!
    @IBOutlet weak var buttonCurrentlyStudyHere: UIButton!
    var currentlyStudying = 0
    
    @IBAction func addEducationView(_ sender: UIButton) {
         addEducationView.isHidden = false
    }
    @IBAction func cancelEducationPopUpView(_ sender: UIButton) {
         self.txt_school.text = ""
         self.txt_major.text = ""
         self.txt_minor.text = ""
         self.txt_startDateEdu.text = ""
         self.txt_endDateEdu.text = ""
         self.buttonCurrentlyStudyHere.setImage(UIImage(named: "checkmark.seal"), for: .normal)
         self.currentlyStudying = 0
         self.addEducationView.isHidden = true
    }
    @IBAction func buttonDeleteEducation(_ sender: UIButton) {
        if let schoolID = self.eduArrDict[sender.tag]["id"] as? Int{
            connectToDelete(deleteURL: API.deleteEduQualificationURL, paramKey: "education_id", paramID: schoolID)
        }
    }
    @IBAction func buttonCurrentlyStudyHere(_ sender: UIButton) {
//        currentlyStudying = (0:not studying 1 :studying)
        if currentlyStudying == 0{
            if #available(iOS 13.0, *) {
                buttonCurrentlyStudyHere.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
//                buttonCurrentlyStudyHere.setImage(UIImage(named: "checkmark.seal.fill"), for: .normal)
            }
            currentlyStudying = 1
        }else{
            if #available(iOS 13.0, *) {
                buttonCurrentlyStudyHere.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
            } else {
                // Fallback on earlier versions
//                buttonCurrentlyStudyHere.setImage(UIImage(named: "checkmark.seal"), for: .normal)
            }
            currentlyStudying = 0
        }
    }
    @IBAction func saveEducation(_ sender: Any) {
        if txt_school.text!.isEmpty {
            self.view.makeToast("Please enter School")
        }else if txt_major.text!.isEmpty {
            self.view.makeToast("Please enter Mojor")
        }else if txt_minor.text!.isEmpty {
            self.view.makeToast("Please enter Minor")
        }else if txt_startDateEdu.text!.isEmpty {
            self.view.makeToast("Please enter Start date")
        }else if txt_endDateEdu.text!.isEmpty {
            self.view.makeToast("Please enter Minor")
        }else {
             connectToSaveNewEducation()
        }
    }
    //MARK:- Language view functions and outlets
    @IBOutlet weak var txt_lang: UITextField!
    @IBOutlet weak var languageSwitch: UISwitch!
    var proficiency = 1
    
    @IBAction func addLanguageView(_ sender: UIButton) {
          addLanguageView.isHidden = false
    }
    @IBAction func cancelLanguage(_ sender: Any) {
        DispatchQueue.main.async {
            self.txt_lang.text = ""
            self.languageSwitch.isOn = true
            self.proficiency = 1
            self.addLanguageView.isHidden = true
        }
    }
    @IBAction func buttonDeleteLanguage(_ sender: UIButton) {
        if let langID = self.langArrDict[sender.tag]["id"] as? Int{
            connectToDelete(deleteURL: API.deleteLangURL, paramKey: "language_id", paramID: langID)
        }
    }
    @IBAction func langSwicthChange(_ sender: UISwitch) {
//        proficiency = (0:native 1 :elementary)
        if languageSwitch.isOn {
            proficiency = 1
        } else {
            proficiency = 0
        }
    }
    @IBAction func saveNewLanguage(_ sender: Any) {
        if txt_lang.text!.isEmpty {
            self.view.makeToast("Please enter language")
        }else {
            connectToSaveNewLanguage()
        }
    }
    //MARK:- Achievement view functions and outlets
    @IBOutlet weak var txt_title: UITextField!
    @IBOutlet weak var txt_honorDate: UITextField!
    @IBOutlet weak var txt_descAchievement: UITextView!
    
    @IBAction func addAchievementView(_ sender: UIButton) {
         addAchievementView.isHidden = false
    }
    @IBAction func cancelAcheivement(_ sender: Any) {
        DispatchQueue.main.async {
            self.txt_title.text = ""
            self.txt_honorDate.text = ""
            self.addAchievementView.isHidden = true
        }
    }
    @IBAction func deleteAcheivement(_ sender: UIButton) {
        if let acheivementID = self.achieveArrDict[sender.tag]["id"] as? Int{
            connectToDelete(deleteURL: API.deleteAchievementURL, paramKey: "achievement_id", paramID: acheivementID)
        }
    }
    @IBAction func saveAchievement(_ sender: UIButton) {
        if txt_title.text!.isEmpty {
            self.view.makeToast("Please enter Title")
        }else if txt_honorDate.text!.isEmpty {
                self.view.makeToast("Please enter Honor Date")
        }else if txt_descAchievement.text!.isEmpty {
            self.view.makeToast("Please enter Description")
        }else {
            connectToSaveAchievement()
        }
    }
}
//MARK:- Tableview cells
class HunterEduTableViewCell: UITableViewCell {
    @IBOutlet weak var img_appIcon: UIImageView!
    @IBOutlet weak var lab_Title: UILabel!
    @IBOutlet weak var lab_TitleTxt: UILabel!
    @IBOutlet weak var view_title: UIView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var lab_StartDate: UILabel!
    @IBOutlet weak var lab_StartDateTxt: UILabel!
    @IBOutlet weak var view_Start: UIView!
    @IBOutlet weak var lab_EndDate: UILabel!
    @IBOutlet weak var lab_EndDateTxt: UILabel!
    @IBOutlet weak var view_End: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var lab_Major: UILabel!
    @IBOutlet weak var lab_MajorTxt: UILabel!
    @IBOutlet weak var view_Major: UIView!
    @IBOutlet weak var lab_Minor: UILabel!
    @IBOutlet weak var lab_MinorTxt: UILabel!
    @IBOutlet weak var view_Minor: UIView!
}
class HunterWorEXTableViewCell: UITableViewCell {
    @IBOutlet weak var img_appIcon: UIImageView!
    @IBOutlet weak var lab_Title: UILabel!
    @IBOutlet weak var lab_TitleTxt: UILabel!
    @IBOutlet weak var view_title: UIView!
    @IBOutlet weak var lab_companyName: UILabel!
    @IBOutlet weak var lab_location: UILabel!
    @IBOutlet weak var view_comoanyName: UIView!
    @IBOutlet weak var view_Location: UIView!
    @IBOutlet weak var lab_locationTxt: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var lab_companyNameTxt: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var lab_StartDate: UILabel!
    @IBOutlet weak var lab_StartDateTxt: UILabel!
    @IBOutlet weak var view_Start: UIView!
    @IBOutlet weak var lab_EndDate: UILabel!
    @IBOutlet weak var lab_EndDateTxt: UILabel!
    @IBOutlet weak var view_End: UIView!
}
class HunterAchieveTableViewCell: UITableViewCell {
    @IBOutlet weak var img_appIcon: UIImageView!
    @IBOutlet weak var lab_Title: UILabel!
    @IBOutlet weak var lab_TitleTxt: UILabel!
    @IBOutlet weak var view_title: UIView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var lab_StartDate: UILabel!
    @IBOutlet weak var lab_StartDateTxt: UILabel!
    @IBOutlet weak var view_Start: UIView!
    @IBOutlet weak var lab_Desc: UILabel!
    @IBOutlet weak var lab_DescTxt: UILabel!
    @IBOutlet weak var txt_Desc: UITextView!
    @IBOutlet weak var view_Desc: UIView!
}
//MARK:- Collectionview cells
class HunterLangCollectionCell: UICollectionViewCell {
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var lab_language: UILabel!
    @IBOutlet weak var lab_languageTxt: UILabel!
    @IBOutlet weak var view_language: UIView!
    @IBOutlet weak var lab_proficiency: UILabel!
    @IBOutlet weak var lab_proficiencyTxt: UILabel!
    @IBOutlet weak var view_proficiency: UIView!
}
class HunterJobTypeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25/2
    }
}
class HunterLocCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25/2
    }
}
class HunterSocialMediaCollectionCell: UICollectionViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25/2
    }
}
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
extension UIViewController {
    func showInputDialog1(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
