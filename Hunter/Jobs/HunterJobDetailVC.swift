//
//  HunterJobDetailVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 25/09/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class HunterJobDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionSkills: UICollectionView!
    @IBOutlet weak var collectionSkillsHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var buttonSeeMore: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewTableBgHeight: NSLayoutConstraint!
    @IBOutlet weak var tableJobs: UITableView!
    @IBOutlet weak var viewMatchingJobs: UIView!
    var isTableVisible = false
    var isSeeMore = false
    var arraySkills = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewMatchingJobs.isHidden = true
        tableJobs.isHidden = true
        viewTableBgHeight.constant = 0.0
        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left,
                                                                verticalAlignment: .top)
        alignedFlowLayout.minimumInteritemSpacing = 5.0
        alignedFlowLayout.minimumLineSpacing = 5.0
        collectionSkills.collectionViewLayout = alignedFlowLayout
        arraySkills = ["jhdsjfbsdjh", "ydyd", "sdvtvsaca", "dvtasftya", "jhdsjfbsdjh", "ydyd", "sdvtvsaca", "dvtasftya", "sdvtvsaca", "dvtasftya", "rgf", "eeeeee"]
        autosizeCollectionView()
//        viewHeader.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
//        tableJobs.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
//        let path = UIBezierPath(roundedRect:viewHeader.bounds,
//                                byRoundingCorners:[.bottomRight, .bottomLeft],
//                                cornerRadii: CGSize(width: 10, height:  10))
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
//        viewHeader.layer.mask = maskLayer

    }
    func autosizeCollectionView(){
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.collectionSkills.layoutIfNeeded()
            let height = self.collectionSkills.contentSize.height
            if self.isSeeMore{
                self.collectionSkillsHeight.constant = height
            }else{
                if height > 20{
                    self.collectionSkillsHeight.constant = 50.0
                }else if height <= 20{
                    self.collectionSkillsHeight.constant = 20.0
                }
            }
            self.collectionSkills.needsUpdateConstraints()
        }
    }
    @IBAction func seeMoreSkills(_ sender: UIButton) {
        if isSeeMore{
            isSeeMore = false
            buttonSeeMore.setTitle("See More", for: .normal)
        }else{
            isSeeMore = true
            buttonSeeMore.setTitle("See Less", for: .normal)
        }
        autosizeCollectionView()
    }
    @IBAction func buttonJobMatches(_ sender: UIButton) {
        if isTableVisible{//table is visible
            isTableVisible = false
            tableJobs.isHidden = true
            viewMatchingJobs.isHidden = true
            viewTableBgHeight.constant = 0.0
        }else{// table is hidden
            isTableVisible = true
            tableJobs.isHidden = false
            viewMatchingJobs.isHidden = false
            viewTableBgHeight.constant = 10.0
        }
    }
    // MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySkills.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HunterSkillsCell", for: indexPath) as! HunterSkillsCell
        cell.labelName.font = UIFont(name: FontName.MontserratRegular.rawValue, size: 10)
        cell.labelName.text = arraySkills[indexPath.row]
        cell.labelName.sizeToFit()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (arraySkills[indexPath.row]).size(withAttributes: [NSAttributedString.Key.font: UIFont(name: FontName.MontserratRegular.rawValue, size: 11) ?? ""]).width
        return CGSize(width: width + 20, height: 20)
    }
    // MARK: - tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HunterJobMatchesCell", for: indexPath) as! HunterJobMatchesCell
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isTableVisible = false
        tableJobs.isHidden = true
        viewMatchingJobs.isHidden = true
        viewTableBgHeight.constant = 0.0
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
