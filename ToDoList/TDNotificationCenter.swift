//
//  TDNotificationCenter.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 07/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UserNotifications
class TDNotificationCenter: NSObject, UNUserNotificationCenterDelegate {
    struct Keys {
        static let CompleteActionId: String = "COMPLETE_ACTION"
        static let SnoozeActionId: String = "SNOOZE_ACTION"
        static let SkipActionId: String = "SKIP_ACTION"
        static let ShowActionId: String = "SHOW_ACTION"
        static let UpcommingTaskCategoryId: String = "UPCOMMING_TASK"
    }
    // MARK: - Event Handling Properties
    var snoozingTaskId: UUID?
    
    dynamic var skipTaskId: UUID?
    
    dynamic var showingTaskId: UUID?
    
    dynamic var completingTaskId: UUID?
    
    var pendingTasksId: [UUID]?
    // MARK: - Initialization
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        //set delegate
        center.delegate = self
        //get authorization
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            //do stuff
            center.getNotificationSettings(completionHandler: {(settings: UNNotificationSettings) in
                //check what is enabled
            })
        })
        //actions
        let completeAction = UNNotificationAction(identifier: TDNotificationCenter.Keys.CompleteActionId, title: "Complete", options: [])
        let snoozeAction = UNNotificationAction(identifier: TDNotificationCenter.Keys.SnoozeActionId, title: "Snooze", options: [])
        let removeAction = UNNotificationAction(identifier: TDNotificationCenter.Keys.SkipActionId, title: "Skip", options: .destructive)
        let showAction = UNNotificationAction(identifier: TDNotificationCenter.Keys.ShowActionId, title: "Show", options: .foreground)
        //let textAction = UNTextInputNotificationAction(identifier: "TYPE_SOMETHING", title: "Type", options: UNNotificationActionOptions.authenticationRequired, textInputButtonTitle: "Type", textInputPlaceholder: "Something")
        //configure categories
        let upcommingTaskCategory = UNNotificationCategory(identifier: TDNotificationCenter.Keys.UpcommingTaskCategoryId, actions: [completeAction, snoozeAction, removeAction, showAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        //register
        center.setNotificationCategories([upcommingTaskCategory])
        /*
        //let center = UNUserNotificationCenter.current()
        let nContent = UNMutableNotificationContent.init()
        nContent.title = "caption"
        nContent.subtitle = "description"
        nContent.body = "Due in soon"
        nContent.categoryIdentifier = TDNotificationCenter.Keys.UpcommingTaskCategoryId
        nContent.sound = UNNotificationSound.default()//UNNotificationSound(named: "MySound.aiff")
        let id = UUID()
        //let attachedTask: [String : UUID] = [Task.Keys.id : id]
        //nContent.userInfo = attachedTask
        //let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: task.dueDate)
        //let cTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let cTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval.init(15), repeats: false)
        let nRequest = UNNotificationRequest(identifier: id.uuidString, content: nContent, trigger: cTrigger)
        center.getPendingNotificationRequests(completionHandler: { requests -> () in
            print("!")
            for request in requests {
                print(request.content.title)
            }
        })
        center.add(nRequest) {(error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            } else {
                print("notification not an error")
            }
        }
        center.getPendingNotificationRequests(completionHandler: { (requests: [UNNotificationRequest]) in
            print("!")
            for request in requests {
                print(request.content.title)
            }
        })
        */
    }
    // MARK: - Public Methods
    
    func pushNotification(for task: Task) {
        let center = UNUserNotificationCenter.current()
        let nContent = UNMutableNotificationContent.init()
        nContent.title = task.caption
        nContent.subtitle = task.tDescription
        nContent.body = "Due in " + ToDoListContext.instance.dateToString(task.dueDate)
        nContent.categoryIdentifier = TDNotificationCenter.Keys.UpcommingTaskCategoryId
        nContent.sound = UNNotificationSound.default()//UNNotificationSound(named: "MySound.aiff")
        let attachedTask = [Task.Keys.id : task.id.uuidString]
        nContent.userInfo = attachedTask
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: task.dueDate)
        let cTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        //let cTrigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval.init(15), repeats: false)
        let nRequest = UNNotificationRequest(identifier: task.id.uuidString, content: nContent, trigger: cTrigger)
        center.add(nRequest, withCompletionHandler: {(error: Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            } else {
                print("notification not an error")
            }
        })
        center.getPendingNotificationRequests(completionHandler: { (requests: [UNNotificationRequest]) in
            print("!")
            for request in requests {
                print(request.content.title)
            }
        })
    }
    
    func cleanup() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.getPendingNotificationRequests(completionHandler: { (pending: [UNNotificationRequest]) in
            var requestToRemoveIds: [String] = []
            for request in pending {
                if let id = request.content.userInfo[Task.Keys.id] as? String, let uuid = UUID.init(uuidString: id) {
                    if let task = ToDoListContext.instance.GetTask(id: uuid), task.isCancelled {
                        requestToRemoveIds.append(request.identifier)
                    }
                }
            }
            center.removePendingNotificationRequests(withIdentifiers: requestToRemoveIds)
        })
    }
    
    // MARK: - UNNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Update the app interface
        completionHandler([.alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void){
        var uuid: UUID?
        if let id = response.notification.request.content.userInfo[Task.Keys.id] as? String {
            uuid = UUID.init(uuidString: id)
        }
        //handle actions
        if response.actionIdentifier == TDNotificationCenter.Keys.SnoozeActionId {
            print("snooze")
            if let id = uuid {
                self.snoozingTaskId = id
                if let task = ToDoListContext.instance.GetTask(id: id) {
                    task.snooze()
                }
            }
        }
        else if response.actionIdentifier == TDNotificationCenter.Keys.SkipActionId {
            print("skip")
            if let id = uuid {
                self.skipTaskId = id
                if let task = ToDoListContext.instance.GetTask(id: id) {
                    task.skip()
                }
            }
        }
        else if response.actionIdentifier == TDNotificationCenter.Keys.CompleteActionId {
            print("complete")
            if let id = uuid {
                self.completingTaskId = id
                if let task = ToDoListContext.instance.GetTask(id: id) {
                    task.complete()
                }
            }
        }
        else if response.actionIdentifier == TDNotificationCenter.Keys.ShowActionId {
            print("show")
            if let id = uuid {
                self.showingTaskId = id
                //show
            }
        }
        else if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print("sysdismiss")
            if let id = uuid {
                self.skipTaskId = id
                if let task = ToDoListContext.instance.GetTask(id: id) {
                    task.skip()
                }
            }
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("sysdefault")
            if let id = uuid {
                self.showingTaskId = id
                //show
            }
        }
        /*
        else if response.actionIdentifier == "TYPE_SOMETHING" {
            if let tResponse = response as? UNTextInputNotificationResponse {
                print(tResponse.userText)
            }
            else {
                print("typed")
            }
        }
        */
        completionHandler()
    }
}
