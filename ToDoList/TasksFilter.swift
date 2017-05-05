//
//  TaskFilter.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
protocol TasksFilter {
    var filteredTasks: [Task] { get }
    var firstTask: Int? { get }
    var name: String { get }
}
