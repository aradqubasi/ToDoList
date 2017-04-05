//
//  Task.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
class Task {
    var id: UUID
    var caption: String
    var description: String
    var isDone: Bool
    var isCancelled: Bool
    var dueDate: Date
    var categories: [Category]
    var hashTags: [String]
    var isReoccuring: Bool
    init?(caption: String, description: String, dueDate: Date, categories: [Category], hashTags: [String]) {
        guard  !caption.isEmpty else {
            return nil
        }
        self.id = UUID()
        self.caption = caption
        self.description = description
        self.isDone = false
        self.isCancelled = false
        self.dueDate = dueDate
        self.categories = categories
        self.hashTags = hashTags
        self.isReoccuring = false
    }
}
