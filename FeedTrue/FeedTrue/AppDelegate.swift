//
//  AppDelegate.swift
//  FeedTrue
//
//  Created by Quoc Le on 8/22/18.
//  Copyright © 2018 toanle. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import STPopup
import DKImagePickerController
import PixelEngine
import PixelEditor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().setBackgroundImage(UIImage(color: UIColor.navigationBarColor()), for: UIBarMetrics.default)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.navigationTitleTextColor(), NSAttributedString.Key.font: UIFont.navFont()]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.navigationTitleTextColor(), NSAttributedString.Key.font: UIFont.navFont()], for: .normal)

        // Facebook configure
        //[[FBSDKApplicationDelegate sharedInstance] application:application
        //didFinishLaunchingWithOptions:launchOptions];
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        // STPopup
        STPopupNavigationBar.appearance().setBackgroundImage(UIImage(color: UIColor.white), for: UIBarMetrics.default)
        STPopupNavigationBar.appearance().barTintColor = .white
        STPopupNavigationBar.appearance().tintColor = .black
        STPopupNavigationBar.appearance().barStyle = .default
        STPopupNavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        STPopupNavigationBar.appearance().shadowImage = UIImage(color: .clear)
    
        ColorCubeStorage.loadToDefault()
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /*
         BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
         openURL:url
         sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
         annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
         ];
         // Add any custom logic here.
         return handled;
         */
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
}

extension Collection where Index == Int {
    
    fileprivate func concurrentMap<U>(_ transform: (Element) -> U) -> [U] {
        var buffer = [U?].init(repeating: nil, count: count)
        let lock = NSLock()
        DispatchQueue.concurrentPerform(iterations: count) { i in
            let e = self[i]
            let r = transform(e)
            lock.lock()
            buffer[i] = r
            lock.unlock()
        }
        return buffer.compactMap { $0 }
    }
}

extension ColorCubeStorage {
    static func loadToDefault() {
        
        do {
            
            try autoreleasepool {
                let bundle = Bundle.main
                let rootPath = bundle.bundlePath as NSString
                let fileList = try FileManager.default.contentsOfDirectory(atPath: rootPath as String)
                
                let filters = fileList
                    .filter { ($0.hasSuffix(".png") || $0.hasSuffix(".PNG")) && $0.hasPrefix("LUT_") }
                    .sorted()
                    .concurrentMap { path -> FilterColorCube in
                        let url = URL(fileURLWithPath: rootPath.appendingPathComponent(path))
                        let data = try! Data(contentsOf: url)
                        let image = UIImage(data: data)!
                        let name = path
                            .replacingOccurrences(of: "LUT_", with: "")
                            .replacingOccurrences(of: ".png", with: "")
                            .replacingOccurrences(of: ".PNG", with: "")
                        return FilterColorCube.init(
                            name: name,
                            identifier: path,
                            lutImage: image,
                            dimension: 64
                        )
                }
                
                self.default.filters = filters
            }
            
        } catch {
            
            assertionFailure("\(error)")
        }
    }
}

