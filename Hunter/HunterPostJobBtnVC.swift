//
//  HunterPostJobBtnVC.swift
//  Hunter
//
//  Created by Zubin Manak on 10/12/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterPostJobBtnVC: UIViewController {

    @IBOutlet weak var postAJobV: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postAJobV.layer.shadowPath = UIBezierPath(rect: postAJobV.bounds).cgPath
        postAJobV.layer.shadowRadius = 12
        postAJobV.layer.shadowOffset = CGSize(width: 0, height: 1)
        postAJobV.layer.shadowOpacity = 0.8
        postAJobV.layer.masksToBounds = false
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
