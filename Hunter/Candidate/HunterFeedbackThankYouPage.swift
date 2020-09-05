//
//  HunterFeedbackThankYouPage.swift
//  Hunter
//
//  Created by Ajith Kumar on 11/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterFeedbackThankYouPage: UIViewController {
    @IBOutlet weak var viewHeader: GradientView!
    var delegate: FeebackSendProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.dismissView), userInfo: nil, repeats: false)
    }
    @objc func dismissView() {
        self.delegate.getStatus()
        self.navigationController?.popViewController(animated: false)
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
        self.navigationController?.popViewController(animated: true)
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
