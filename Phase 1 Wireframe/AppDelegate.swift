//
//  AppDelegate.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/23/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain

/** 
    This file handles special UIApplication states including the following:
 
        applicationDidFinishLaunching: - handles on-startup configuration and construction
 
        applicationWillTerminate: - handles clean up at the end, when the application terminates
 
    Extraneous functionality should NOT be placed in the AppDelegate since they don't really belong there. This includes the following:
 
        Document data -- this should be placed in a document manager singleton
 
        Button/table/view controllers, view delegate methods or other view handling (top-level view in applicationDidFinishLaunching: is still allowed) -- this work should be in respective view controller classes.
 */
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The AppDelegate window. This variable contains information regarding the placment of the Application itself on the phone screen. The rootViewController for this variable will be the `InitialViewController`.
    var window: UIWindow?

    /// The Navigation Bar's appearance is set in this function. Since the entire application will be using the same Navigation bar, setting it here will affect all other views. Most of the backend is also configured in this function (Firebase, Google SDK, Facebook SDK).
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.tintColor = UIColor.WHITE
        navigationBarAppearance.barTintColor = UIColor.BACKGROUND
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.WHITE]
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = APIManager.sharedInstance
        GIDSignIn.sharedInstance().uiDelegate = APIManager.sharedInstance
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let _ = APIManager.sharedInstance.user {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let newvc = storyboard.instantiateViewController(withIdentifier: "demo")
            self.switchViewControllers(viewController: newvc)
        }
        
        return true
    }
    
    /// This function is called when this application opens an URL. It returns true if the URL has handled by either Google SDK or Facebook SDK and returns when the user finishes logging in. This allows the Safari view to close once the user has signed in.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let fbHandled = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        let googleHandled = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication:sourceApplication,
            annotation: [:])
        return fbHandled || googleHandled
    }
    
    func switchViewControllers(viewController: UIViewController) {
        self.window?.rootViewController = viewController
    }

    /** Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state. Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     
        - note: This function is not customized.
    */
    func applicationWillResignActive(_ application: UIApplication) {
 
    }
    
    /** Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     
        - note: This function is not customized.
    */
    func applicationDidEnterBackground(_ application: UIApplication) {
 
    }

    /** Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     - note: This function is not customized.
     */
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    /** Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     - note: This function is customized for the Facebook SDK.
     */
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
}

