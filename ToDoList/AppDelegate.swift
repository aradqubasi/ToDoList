//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import UserNotifications

 @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - Application Delegate
    var window: UIWindow?
    
    var notifications = ToDoListContext.instance.notifications
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //let notifications = ToDoListContext.instance.notifications
        addObserver(self, forKeyPath: #keyPath(notifications.showingTaskId), options: [.new], context: nil)
        print("didFinishLaunchingWithOptions")
        let root = window?.rootViewController!
        //print(root)
        ToDoListContext.instance.rootView = (root?.view)!
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //ToDoListContext.instance.notifications.cleanup()
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("applicationWillTerminate")
    }
    
    // MARK: - Observer Methods
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        /*
        print("observer hit")
        let root = window?.rootViewController!
        let showView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskEdit") as! TaskEditViewController
        let showTaskId = change?[NSKeyValueChangeKey.newKey] as! UUID
        let showTask = ToDoListContext.instance.GetTask(id: showTaskId)
        showView.task = showTask
        root?.present(showView, animated: true, completion: nil)
         */
        let root = window?.rootViewController!
        let showNavView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskEditNavigation") as! UINavigationController
        let editViewController = showNavView.viewControllers.first as! TaskEditViewController
        let showTaskId = change?[NSKeyValueChangeKey.newKey] as! UUID
        let showTask = ToDoListContext.instance.GetTask(id: showTaskId)
        editViewController.task = showTask
        root?.present(showNavView, animated: true, completion: nil)
    }
}

