//
//  HunterCreateAccountVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/24/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func blackHighlight(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
class HunterCreateAccountVC: UIViewController {
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreateAcc: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lab_info: UILabel!
    let nameArr = ["CANDIDATE", "RECRUITER"]
    var loginType = "candidate"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }


    override func viewWillAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func actionCandidateLogin(_ sender: Any) {
        self.loginType = "candidate"
        UserDefaults.standard.set(self.loginType, forKey: "loginType")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterLoginVC") as! HunterLoginVC
        vc.loginType = self.loginType
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func actionRecruiterLogin(_ sender: Any) {
        self.loginType = "recruiter"
        UserDefaults.standard.set(self.loginType, forKey: "loginType")
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterLoginVC") as! HunterLoginVC
        vc.loginType = self.loginType
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
