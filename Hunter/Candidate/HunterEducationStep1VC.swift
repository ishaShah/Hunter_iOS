//
//  HunterEducationStep1VC.swift
//  Hunter
//
//  Created by Shamseer on 07/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterEducationStep1VC: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnContinue.setTitleColor(UIColor.init(hexString:"E9E4F2" ), for: UIControl.State.normal)
        self.btnContinue.backgroundColor = UIColor.init(hexString:"6B3E99" )
        // Do any additional setup after loading the view.
    }
    @IBAction func backToVC(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func actionAddEducation(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterEducationStep2VC") as! HunterEducationStep2VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func continueBtnClick(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "HunterEditProPicVC") as! HunterEditProPicVC
        vc.isFrom = "candidateReg"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
