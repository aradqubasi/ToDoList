//
//  SelectableCategoryDelegate.swift
//  ToDoList
//
//  Created by Admin on 19.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
protocol SelectableCategoryDelegate {
    func onCategoryClick(sender: SelectableCategory)
    func onStateChange(from: Bool) -> Bool
}
extension SelectableCategoryDelegate {
    func onStateChange(from: Bool) -> Bool {
        return !from
    }
}
