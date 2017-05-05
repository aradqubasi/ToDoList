//
//  TasksFilterUpcomming.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class TasksFilterUpcomming : TasksFilter {
    var filteredTasks: [Task] {
        get {
            let unsorted = ToDoListContext.instance.GetTasks()
            let filtered = unsorted.drop(while: { return ($0.dueDate < Date.init()) || ($0.isDone) })
            let sorted = filtered.sorted(by: { return $0.dueDate < $1.dueDate })
            return sorted
        }
    }
    var firstTask: Int? {
        get {
            let tasks = filteredTasks
            var result: Int? = nil
            if tasks.count != 0 {
                result = 0
            }
            return result
        }
    }
}
