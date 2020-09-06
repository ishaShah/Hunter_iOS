//
//  HunterSecrectCodeVC.swift
//  Hunter
//
//  Created by Zubin Manak on 9/20/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class HunterSecrectCodeVC: UIViewController , UITextFieldDelegate  {
    @IBOutlet var textFieldsOutletCollection: [UITextField]!
    
    var textFieldsIndexes:[UITextField:Int] = [:]
    
    @IBOutlet weak var viewInvalid: UIView!

    
    @IBOutlet weak var bgView: UIView!
    
     
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedBtn(_ sender: Any) {
        
        
        
        
        
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterChangePassVC") as! HunterChangePassVC
        self.navigationController?.pushViewController(vc, animated: true)
        }
    
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    viewInvalid.isHidden = true
    
    viewInvalid.layer.shadowPath = UIBezierPath(rect: viewInvalid.bounds).cgPath
    viewInvalid.layer.shadowRadius = 12
    viewInvalid.layer.shadowOffset = CGSize(width: 0, height: 1)
    viewInvalid.layer.shadowOpacity = 0.3
    viewInvalid.layer.masksToBounds = false
    // Do any additional setup after loading the view.
    
    for index in 0 ..< textFieldsOutletCollection.count {
    textFieldsIndexes[textFieldsOutletCollection[index]] = index
    }
    }
    
    enum Direction { case left, right }
    
    func setNextResponder(_ index:Int?, direction:Direction) {
    
    guard let index = index else { return }
    
    if direction == .left {
    index == 0 ?
    (_ = textFieldsOutletCollection.first?.resignFirstResponder()) :
    (_ = textFieldsOutletCollection[(index - 1)].becomeFirstResponder())
    } else {
    index == textFieldsOutletCollection.count - 1 ?
    (_ = textFieldsOutletCollection.last?.resignFirstResponder()) :
    (_ = textFieldsOutletCollection[(index + 1)].becomeFirstResponder())
    }
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if range.length == 0 {
    textField.text = string
    setNextResponder(textFieldsIndexes[textField], direction: .right)
    return true
    } else if range.length == 1 {
    textField.text = ""
    setNextResponder(textFieldsIndexes[textField], direction: .left)
    return false
    }
    
    return false
    
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func continueBtn(_ sender: Any) {
        var code = ""
        for textF in textFieldsOutletCollection {
            code = code + textF.text!
        }
        if code.count == 4 {

        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HunterChangePassVC") as! HunterChangePassVC
        vc.code = code
        self.navigationController?.pushViewController(vc, animated: true)
     }
    }
     @IBAction func back(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
    }


