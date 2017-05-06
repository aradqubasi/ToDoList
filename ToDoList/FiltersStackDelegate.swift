//
//  FiltersStackDelegate.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 06/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
protocol FiltersStackDelegate {
    var filters: [TasksFilter] { get }
    var currentFilter: TasksFilter { get set }
    func onFilterSelect(_: TasksFilter) -> Bool
}
