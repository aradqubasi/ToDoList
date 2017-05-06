//
//  TasksFilterToday.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class TasksFilterToday: TasksFilter {
    var filteredTasks: [Task] {
        get {
            let unsortedTasks = ToDoListContext.instance.GetTasks()
            let filteredTasks = unsortedTasks.filter({ return ToDoListContext.IsToday($0.dueDate) })
            let sortedTasks = filteredTasks.sorted(by: { return $0.dueDate < $1.dueDate})
            return sortedTasks
        }
    }
    var firstTask: Int? {
        get {
            let tasks = filteredTasks
            var firstTask: Int? = nil
            if tasks.count != 0 {
                firstTask = 0
            }
            return firstTask
        }
    }
    var name: String {
        return "Today Tasks"
    }
}
