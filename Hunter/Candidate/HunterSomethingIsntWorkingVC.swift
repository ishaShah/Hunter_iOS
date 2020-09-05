//
//  HunterSomethingIsntWorkingVC.swift
//  Hunter
//
//  Created by Ajith Kumar on 11/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class HunterSomethingIsntWorkingVC: UIViewController, UITextViewDelegate, FeebackSendProtocol {
    @IBOutlet weak var viewHeader: GradientView!
    @IBOutlet weak var textFeedback: UITextView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var categoryType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFeedback.text = "We'd love to hear your feedback..."
        self.hideKeyboardWhenTappedAround()
        if categoryType == "0"{
            labelTitle.text = "Something Isn't Working"
        }else{
            labelTitle.text = "Spam or Abuse"
        }
    }
    override func viewDidLayoutSubviews() {
        viewHeader.roundCorners([.topLeft, .topRight], radius: 30)
    }
    func getStatus() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: false)
        }
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
    @IBAction func buttonCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func buttonSend(_ sender: UIButton) {
        if textFeedback.text == "" || textFeedback.text == "We'd love to hear your feedback..."{
            self.view.makeToast("Feedback cannot be empty", duration: 1.0, point: CGPoint(x: screenWidth/2, y: screenHeight-130), title: nil, image: nil) { didTap in}
        }else{
            connectToSendFeedback()
        }
    }
    //MARK:- Textview delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "We'd love to hear your feedback..." {
            textView.text = nil
            textFeedback.textColor = UIColor.darkGray
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "We'd love to hear your feedback..."
            textFeedback.textColor = UIColor.lightGray
        }
    }
    //MARK: Webservice
    
    func connectToSendFeedback(){
        if HunterUtility.isConnectedToInternet(){
            
            var url = API.recruiterBaseURL + API.reportErrorURL
            print(url)
            HunterUtility.showProgressBar()
            
            let headers = [ "Authorization" : "Bearer " + accessToken]

            let paramsDict = ["message": textFeedback.text!] as [String : Any]
            print(paramsDict)
            Alamofire.request(url, method: .post, parameters: paramsDict, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let responseDict = response.result.value as? NSDictionary{
                        print(responseDict)
                        SVProgressHUD.dismiss()
                        if let status = responseDict.value(forKey: "status"){
                            if status as! Int == 1   {
                                let vc = UIStoryboard(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "HunterFeedbackThankYouPage") as! HunterFeedbackThankYouPage
                                vc.delegate = self
                                self.present(vc, animated: true, completion: nil)
/*                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)*/
                            }else if status as! Int == 2 {
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else{
                                let alert = UIAlertController(title: "", message: responseDict.value(forKey: "message") as? String, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "", message: responseDict.value(forKey: "error") as? String, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else{
                        SVProgressHUD.dismiss()
                        //                        let alert = UIAlertController(title: "", message: (response.result.value as! NSDictionary).value(forKey: "msg") as? String, preferredStyle: .alert)
                        //                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
                        //                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print(error)
                    let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            print("no internet")
        }
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
protocol FeebackSendProtocol {
    func getStatus()
}
