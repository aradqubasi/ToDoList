//
//  Task.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
class Task: NSObject, NSCoding {
    struct Keys {
        static let id = "id"
        static let caption = "caption"
        static let description = "description"
        static let isDone = "isDone"
        static let isCancelled = "isCancelled"
        static let dueDate = "dueDate"
        static let categories = "categories"
        static let hashTags = "hashTags"
        static let frequency = "frequency"
        static let isLiked = "isLiked"
    }
    var id: UUID
    var caption: String
    var description: String
    var isDone: Bool
    var isCancelled: Bool
    var dueDate: Date
    var categories: [Category]
    var hashTags: [String]
    var frequency: Task.Frequency
    var isLiked: Bool
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
        self.frequency = .once
        self.isLiked = false
    }
    enum Frequency {
        case daily
        case weekly
        case once
    }
    // MARK: - NSObject
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Task.Keys.id) as? UUID else {
            fatalError("Task's id is not decoded")
        }
        guard let caption = aDecoder.decodeObject(forKey: Task.Keys.caption) as? String else {
            fatalError("Task's caption is not decoded")
        }
        guard let description = aDecoder.decodeObject(forKey: Task.Keys.description) as? String else {
            fatalError("Task's description is not decoded")
        }
        let isDone = aDecoder.decodeBool(forKey: Task.Keys.isDone)
        let isCancelled = aDecoder.decodeBool(forKey: Task.Keys.isCancelled)
        guard let hashTags = aDecoder.decodeObject(forKey: Task.Keys.hashTags) else {
            <#statements#>
        }
    }
    
    
}
