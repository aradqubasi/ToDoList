//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskListTableView: UITableView {

    //MARK: Properties
    var tasks = [Task]()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Event passthrough
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is SelectableCategory {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    //MARK: Private methods
    
}
