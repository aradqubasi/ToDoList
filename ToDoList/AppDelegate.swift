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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // MARK: - Application Delegate
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        //set delegate
        center.delegate = self
        //get authorization
        center.requestAuthorization(options: [.alert, .sound, .badge, .carPlay], completionHandler: { (granted, error) in
            //do stuff
            center.getNotificationSettings(completionHandler: {(settings) in
                //check what is enabled
            })
        })
        //actions
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: UNNotificationActionOptions(rawValue: 0))
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION", title: "Stop", options: .foreground)
        let textAction = UNTextInputNotificationAction(identifier: "TYPE_SOMETHING", title: "Type", options: UNNotificationActionOptions.authenticationRequired, textInputButtonTitle: "Type", textInputPlaceholder: "Something")
        //configure categories
        let generalCategory = UNNotificationCategory(identifier: "GENERAL", actions: [], intentIdentifiers: [], options: .customDismissAction)
        let expireCategory = UNNotificationCategory(identifier: "TIMER_EXPIRED", actions: [snoozeAction, stopAction, textAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        //register
        center.setNotificationCategories([generalCategory, expireCategory])
        
        //set some notification
        let nContent = UNMutableNotificationContent.init()
        nContent.title = "Title"
        nContent.subtitle = "SubTitle"
        nContent.body = "Blah-blah blah-blah-blah blah blah-blah-blah blah-blah"
        nContent.categoryIdentifier = "TIMER_EXPIRED"
        nContent.sound = UNNotificationSound.default()//UNNotificationSound(named: "MySound.aiff")
        let nTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval.init(5), repeats: false)
        let nRequest = UNNotificationRequest(identifier: "001", content: nContent, trigger: nTrigger)
        center.add(nRequest, withCompletionHandler: {(error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            } else {
                print("notification not an error")
            }
            })
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
    
    // MARK: - UNNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Update the app interface
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        //handle actions
        if response.actionIdentifier == "SNOOZE_ACTION" {
            print("snooze")
        }
        else if response.actionIdentifier == "STOP_ACTION" {
            print("stop")
        }
        else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print("sysdismiss")
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("sysdefault")
        }
        else if response.actionIdentifier == "TYPE_SOMETHING" {
            if let tResponse = response as? UNTextInputNotificationResponse {
                print(tResponse.userText)
            }
            else {
                print("typed")
            }
        }
        completionHandler()
    }
    
}

