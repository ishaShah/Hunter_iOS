//
//  AppDelegate.swift
//  Hunter
//
//  Created by Zubin Manak on 9/3/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit
import VBRRollingPit

var accessToken = String()
var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkUserAvailable()
        return true
    }
    func checkUserAvailable() {
        if let token = UserDefaults.standard.value(forKey: "accessToken"){
            print(token)
            accessToken = token as! String
            print(accessToken)
            
            if let loggedIn =  UserDefaults.standard.value(forKey: "loggedInStat") {
                let loggedInStr = loggedIn as! String

                if loggedInStr == "loggedIn" {
                    let loginType = UserDefaults.standard.object(forKey: "loginType") as? String

                    if loginType == "candidate" {

                        let mainRootController = UIStoryboard(name: "Candidate", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = mainRootController
                    }
                    else if loginType == "recruiter" {

                        let mainRootController = UIStoryboard(name: "Recruiter", bundle: nil).instantiateViewController(withIdentifier: "VBRRollingPit")
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = mainRootController

                    }
                    else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
                        let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
                        navigationController.viewControllers = [mainRootController]
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = navigationController
                    }
                }
                else {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
                    let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
                    navigationController.viewControllers = [mainRootController]
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = navigationController
                }
            }
            else {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
                let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
                navigationController.viewControllers = [mainRootController]
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = navigationController
            }
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let mainRootController = storyBoard.instantiateViewController(withIdentifier: "HunterCreateAccountVC") as! HunterCreateAccountVC
            let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
            navigationController.viewControllers = [mainRootController]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationController
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

