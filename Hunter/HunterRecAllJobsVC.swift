//
//  HunterRecAllJobsVC.swift
//  Hunter
//
//  Created by Zubin Manak on 08/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterRecAllJobsVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl_jobs: UITableView!
    var arrayMenuNames = [String]()
    var arrayStatus = [String]()
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var view_del: UIView!
    @IBOutlet weak var view_revive: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayMenuNames = ["UX Designer", "IT Manager", "HR Manager", "UX Designer"]
        arrayStatus = ["Matched", "Unmatched", "Matched", "Matched"]
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        view_del.isHidden = true
        view_revive.isHidden = true
    }
    // MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuNames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterRecAllJobsTableViewCell", for: indexPath) as! HunterRecAllJobsTableViewCell
        tableView.separatorStyle = .none
        cell.selectionStyle = .none
        cell.switchChange.tag = indexPath.row
        cell.labelTitle.text = arrayMenuNames[indexPath.row]
        cell.labelStatus.text = arrayStatus[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterProfileVC") as! HunterProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("privacy information page here")
        case 2:
            print("Turn Notification On/Off here")
        case 3:
            print("Turn show me on hunter On/Off here")
        case 4:
            let vc = UIStoryboard.init(name: "Jobs", bundle: nil).instantiateViewController(withIdentifier: "HunterHelpAndSupportVC") as! HunterHelpAndSupportVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 5: break
            //            imageBGPopup.isHidden = false
            //            viewPopup.isHidden = false
            //            viewPopupAccDisabled.isHidden = true
            //            imagePopUpIcon.image = UIImage(named: "")
            //            labelPopUpTitle.text = "Disable Account"
            //            isLogout = false
        //            labelPopUpMessage.text = "Are you sure you would like to disable your Hunter Account"
        case 6: break
            //            imageBGPopup.isHidden = false
            //            viewPopup.isHidden = false
            //            viewPopupAccDisabled.isHidden = true
            //            imagePopUpIcon.image = UIImage(named: "")
            //            labelPopUpTitle.text = "Logout"
            //            isLogout = true
        //            labelPopUpMessage.text = "Are you sure you would like to Log Out?"
        default:
            print("default case")
        }
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
class HunterRecAllJobsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var switchChange: UISwitch!
    @IBOutlet weak var btn_edit: UIStackView!
    @IBOutlet weak var btn_applied: UIStackView!
    @IBOutlet weak var btn_delete: UIStackView!
}
