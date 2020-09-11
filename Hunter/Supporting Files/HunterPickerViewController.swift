//
//  HunterPickerViewController.swift
//  Hunter
//
//  Created by Shamzi on 01/08/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

 extension UIView {
     func roundCorners(corners: UIRectCorner, radius: Int = 8) {
         let maskPath1 = UIBezierPath(roundedRect: bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius, height: radius))
         let maskLayer1 = CAShapeLayer()
         maskLayer1.frame = bounds
         maskLayer1.path = maskPath1.cgPath
         layer.mask = maskLayer1
     }
 }
class HunterPickerViewController: UIViewController{

    var delegate: hunterDelegate!
    
    @IBOutlet weak var hunterPicker: UIPickerView!
    @IBOutlet weak var viewBG: UIView!
    
     var isFrom = String()
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    var selectedDict = NSDictionary()
    
    let year = Calendar.current.component(.year, from: Date())
    var years = [String]()
    
    var passedDict = NSDictionary()

    var AllCount = Int()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        hunterPicker.delegate = self
        hunterPicker.dataSource = self
        
//         viewBG.roundCorners(corners: [.topLeft, .topRight], radius: 50)
 
        
 
        // set the shadow of the view's layer
        viewBG.layer.masksToBounds =  true
        viewBG.layer.cornerRadius = 20
        viewBG.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewBG.clipsToBounds = true
        
        if isFrom == "companySize" {
            AllCount = passedDict.allValues.count

        }
        else if isFrom == "businessType" {
            AllCount = passedDict.allValues.count

        }else if isFrom == "WorkType" || isFrom == "SalaryRange" || isFrom == "YearsOfExp" || isFrom == "PrefWorkType" {
            AllCount = passedDict.allValues.count

        }
        else {
            years = (1980...year).map { String($0) }
            years = years.sorted {$0.localizedStandardCompare($1) == .orderedDescending}
            selectedDict = ["selectedYear" : years[0]]
            AllCount = years.count

        }
        
         
    }
    
 
    @IBAction func dismiss(_ sender: Any) {
        
    }
    
    @IBAction func actionContinue(_ sender: Any) {
        if self.selectedDict.allKeys.count != 0 {
        dismiss(animated: true) {
            self.delegate?.selectedData(selectedDict: self.selectedDict, isFrom: self.isFrom)
        }
        }
    }
    


}

extension HunterPickerViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        AllCount
    }
    
     func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if isFrom == "companySize" {
            return NSAttributedString(string: passedDict.allValues[row] as! String, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 90.0/255.0, green: 40.0/255.0, blue: 140.0/255.0, alpha: 1.0)])
        }
        else if isFrom == "businessType" {
            return NSAttributedString(string: passedDict.allValues[row] as! String, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 90.0/255.0, green: 40.0/255.0, blue: 140.0/255.0, alpha: 1.0)])
        }else if isFrom == "WorkType" || isFrom == "SalaryRange" || isFrom == "YearsOfExp" || isFrom == "PrefWorkType" {
            return NSAttributedString(string: passedDict.allValues[row] as! String, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 90.0/255.0, green: 40.0/255.0, blue: 140.0/255.0, alpha: 1.0)])
        }
        else {
            return NSAttributedString(string: years[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 90.0/255.0, green: 40.0/255.0, blue: 140.0/255.0, alpha: 1.0)])
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if isFrom == "companySize" || isFrom == "businessType"  || isFrom == "WorkType" || isFrom == "SalaryRange" || isFrom == "YearsOfExp" {
            let selectedValue = passedDict.allValues[row] as! String
 
            let allVal = passedDict.allValues as! [String]
            let indexOfA = allVal.firstIndex(of: selectedValue) // 0

            
             let dict = NSMutableDictionary()
            dict["name"] = selectedValue
            dict["id"] = passedDict.allKeys[indexOfA!] as! String

            selectedDict =
                ["name": selectedValue, "id": passedDict.allKeys[indexOfA!] as! String]
            
            
        }
        else if isFrom == "PrefWorkType" {
                   let selectedValue = passedDict.allValues[row] as! String
        
                   let allVal = passedDict.allValues as! [String]
                   let indexOfA = allVal.firstIndex(of: selectedValue) // 0

                   
                    let dict = NSMutableDictionary()
                   dict["name"] = selectedValue
                   dict["id"] = passedDict.allKeys[indexOfA!] as! String

                   selectedDict =
                    ["name": selectedValue, "id": passedDict.allKeys[indexOfA!] as! String, "index" : index]
                   
                  
               }
        else {
            print(years[row])
            selectedDict = ["selectedYear" : years[row]]
           
         }
  
}
}
class RoundedButtonWithShadow: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
}
