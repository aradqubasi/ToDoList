//
//  TasksFilterCategory.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 27/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
class TasksFilterCategory: TasksFilter {
    // MARK: - Private Properties
    private let id: UUID
    private let _name: String
    // MARK: - Initialization
    init(category: Category) {
        id = category.id
        _name = category.name
    }
    // MARK: - TaskFilter Protocol Properties
    var filteredTasks: [Task] {
        get {
            let filtered = ToDoListContext.instance.GetTasks().filter({ (task: Task) in
                let related = task.categories.contains(where: {(ctg: Category) in
                    return ctg.id == self.id
                })
                return related
            })
            let sorted = filtered.sorted(by: {return $0.dueDate < $1.dueDate})
            return sorted
        }
    }
    var firstTask: Int? {
        get {
            let filtered = ToDoListContext.instance.GetTasks().filter({ (task: Task) in
                let related = task.categories.contains(where: {(ctg: Category) in
                    return ctg.id == self.id
                })
                return related
            })
            let sorted = filtered.sorted(by: {return $0.dueDate < $1.dueDate})
            var firstTodayTaskIndex: Int? = sorted.index(where: { return ToDoListContext.IsToday($0.dueDate) || $0.dueDate > Date.init() })
            if firstTodayTaskIndex == nil && sorted.count != 0 {
                firstTodayTaskIndex = sorted.count - 1
            }
            return firstTodayTaskIndex
        }
    }
    var name: String {
        return _name
    }
}
