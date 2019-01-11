//
//  AppDelegate.swift
//  RecordAndUpload
//
//  Created by Chrystian Salgado on 10/01/2019.
//  Copyright © 2019 Qranio.com. All rights reserved.
//

import QRUIKit
import QRStyleKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Aparência
        application.statusBarStyle = .lightContent
        
        let defaultBarTintColor = QRResources.value(fromResource: "@variables/navbar_default") as! UIColor
        let defaultTintColor = QRResources.value(fromResource: "@colors/base_color_white_0") as! UIColor
        
        UINavigationBar.appearance().tintColor = defaultTintColor
        let bgImage = UIImage(color: defaultBarTintColor, size: CGSize(width: 3, height: 1))
        let bgResizable = bgImage?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1))
        UINavigationBar.appearance().setBackgroundImage(bgResizable, for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        return true
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

