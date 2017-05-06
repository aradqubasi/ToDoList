//
//  TasksFilterAll.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class TasksFilterAll: TasksFilter {
    // MARK: - Initialization
    init() {
        
    }
    // MARK: - TaskFilter Protocol Properties
    var filteredTasks: [Task] {
        get {
            let tasks = ToDoListContext.instance.GetTasks().sorted(by: {return $0.dueDate < $1.dueDate})
            return tasks
        }
    }
    var firstTask: Int? {
        get {
            let unsortedTasks = ToDoListContext.instance.GetTasks()
            let sortedTasks = unsortedTasks.sorted(by: {return $0.dueDate < $1.dueDate})
            var firstTodayTaskIndex: Int? = sortedTasks.index(where: { return ToDoListContext.IsToday($0.dueDate) || $0.dueDate > Date.init() })
            if firstTodayTaskIndex == nil && sortedTasks.count != 0 {
                firstTodayTaskIndex = sortedTasks.count - 1
            }
            return firstTodayTaskIndex
        }
    }
    var name: String {
        return "All Tasks"
    }
}
