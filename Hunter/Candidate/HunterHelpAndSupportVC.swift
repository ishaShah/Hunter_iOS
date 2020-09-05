//
//  HunterHelpAndSupportVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 10/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterHelpAndSupportVC: UIViewController {
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var imageArrow1: UIImageView!
    @IBOutlet weak var imageArrow2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageArrow1.transform = CGAffineTransform(scaleX: -1, y: 1)
        imageArrow2.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true

        setNeedsStatusBarAppearanceUpdate()
            
        }
        
        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonHelpCentre(_ sender: UIButton) {
    }

    @IBAction func reportAProb(_ sender: Any) {
        // additional image/video
        let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterReportAProblemVC") as! HunterReportAProblemVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
