//
//  CustomView.swift
//  TinderSwipeView_Example
//
//  Created by Nick on 29/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage

class CustomView: UIView {
    var delegate: MyProtocol!
 
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

        if jobView == "jobView" {
            self.view_expand.isHidden = true
             self.backBtn.isHidden = false

        }
        else {
            self.backBtn.isHidden = true

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
    
    
}

extension UIView{
    
    func fixInView(_ container: UIView!) -> Void{
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        
        
        
        container.addSubview(self);
        
        let jobView = UserDefaults.standard.object(forKey: "jobView") as? String
        if jobView != "jobView" {

        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
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
