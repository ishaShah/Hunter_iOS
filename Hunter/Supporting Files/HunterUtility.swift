//
//  HunterUtility.swift
//  Hunter
//
//  Created by Zubin Manak on 9/20/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Foundation

class HunterUtility: NSObject {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    static func showProgressBar(){
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
    }
    static func notifiyUser(viewController:UIViewController,title:String,message:String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        //alert.view.tintColor = Color.primaryColor
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
