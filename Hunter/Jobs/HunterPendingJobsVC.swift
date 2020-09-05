//
//  HunterPendingJobsVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 22/09/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterPendingJobsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var viewBG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewBG.layer.shadowPath = UIBezierPath(rect: viewBG.bounds).cgPath
        viewBG.layer.shadowRadius = 12
        viewBG.layer.shadowOffset = CGSize(width: 1, height: 0)
        viewBG.layer.shadowOpacity = 0.5
        viewBG.layer.masksToBounds = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterJobsCell", for: indexPath) as! HunterJobsCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Jobs", bundle: nil).instantiateViewController(withIdentifier: "HunterAllJobsViewController") as! HunterAllJobsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
