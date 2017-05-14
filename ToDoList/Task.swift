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
        static let tDescription = "description"
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
    var tDescription: String
    var isDone: Bool
    var isCancelled: Bool {
        get {
            return dueDate < Date.init()
        }
    }
    private var _dueDate: Date
    var dueDate: Date {
        get {
            let now = Date.init()
            if self.frequency == .daily || _dueDate > now {
                return _dueDate
            }
            else if self.frequency == .daily {
                let now = Date.init()
                var nowStruct = Calendar.current.dateComponents([.year, .month, .day], from: now)
                var dueDateStruct = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: _dueDate)
                var newDueDateStruct = DateComponents()
                newDueDateStruct.calendar = Calendar.current
                newDueDateStruct.year = nowStruct.year
                newDueDateStruct.month = nowStruct.month
                if (now > _dueDate) {
                    newDueDateStruct.day = nowStruct.day
                }
                else {
                    newDueDateStruct.day = dueDateStruct.day
                }
                newDueDateStruct.hour = dueDateStruct.hour
                newDueDateStruct.minute = dueDateStruct.minute
                _dueDate = newDueDateStruct.date!
            }
            else if self.frequency == .weekly {
                let now = Date.init()
                var nowStruct = Calendar.current.dateComponents([.year, .month, .day, .weekdayOrdinal], from: now)
                var dueDateStruct = Calendar.current.dateComponents([.weekday, .hour, .minute], from: _dueDate)
                var newDueDateStruct = DateComponents()
                newDueDateStruct.calendar = Calendar.current
                newDueDateStruct.year = nowStruct.year
                newDueDateStruct.month = nowStruct.month
                newDueDateStruct.weekday = dueDateStruct.weekday
                if (now > _dueDate) {
                    newDueDateStruct.weekdayOrdinal = nowStruct.weekdayOrdinal! + 1
                }
                else {
                    newDueDateStruct.weekdayOrdinal = nowStruct.weekdayOrdinal
                }
                newDueDateStruct.hour = dueDateStruct.hour
                newDueDateStruct.minute = dueDateStruct.minute
                _dueDate = newDueDateStruct.date!
            }
            return _dueDate
        }
        set(new) {
            _dueDate = dueDate
        }
    }
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
        self.tDescription = description
        self.isDone = false
        //self.isCancelled = false
        self._dueDate = dueDate
        self.categories = categories
        self.hashTags = hashTags
        self.frequency = .once
        self.isLiked = false
    }
    enum Frequency: Int {
        case daily = 0
        case weekly = 1
        case once = 2
        static func unHash(_ hashValue: Int) -> Frequency {
            switch hashValue {
            case 0: return Task.Frequency.daily
            case 1: return Task.Frequency.weekly
            case 2: return Task.Frequency.once
            default: fatalError("\(hashValue) is unrecignized hashValue")
            }
        }
    }
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Task.Keys.id)
        aCoder.encode(caption, forKey: Task.Keys.caption)
        aCoder.encode(tDescription, forKey: Task.Keys.tDescription)
        aCoder.encode(isDone, forKey: Task.Keys.isDone)
        //aCoder.encode(isCancelled, forKey: Task.Keys.isCancelled)
        aCoder.encode(_dueDate, forKey: Task.Keys.dueDate)
        aCoder.encode(categories, forKey: Task.Keys.categories)
        aCoder.encode(hashTags, forKey: Task.Keys.hashTags)
        //aCoder.encode(frequency, forKey: Task.Keys.frequency)
        aCoder.encode(frequency.hashValue, forKey: Task.Keys.frequency)
        aCoder.encode(isLiked, forKey: Task.Keys.isLiked)
    }
    // MARK: - NSObject
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Task.Keys.id) as? UUID else {
            fatalError("Task's id is not decoded")
        }
        guard let caption = aDecoder.decodeObject(forKey: Task.Keys.caption) as? String else {
            fatalError("Task's caption is not decoded")
        }
        guard let description = aDecoder.decodeObject(forKey: Task.Keys.tDescription) as? String else {
            fatalError("Task's description is not decoded")
        }
        let isDone = aDecoder.decodeBool(forKey: Task.Keys.isDone)
        //let isCancelled = aDecoder.decodeBool(forKey: Task.Keys.isCancelled)
        guard let dueDate = aDecoder.decodeObject(forKey: Task.Keys.dueDate) as? Date else {
            fatalError("Task's duedate is not decoded")
        }
        guard let categories = aDecoder.decodeObject(forKey: Task.Keys.categories) as? [Category] else {
            fatalError("Task's categories is not decoded")
        }
        guard let hashTags = aDecoder.decodeObject(forKey: Task.Keys.hashTags) as? [String] else {
            fatalError("Task's hashtags is not decoded")
        }
        let frequency = Task.Frequency.unHash(aDecoder.decodeInteger(forKey: Task.Keys.frequency))
        /*
        guard let frequency = aDecoder.decodeObject(forKey: Task.Keys.frequency) as? Task.Frequency else {
            fatalError("Task's frequency is not decoded")
        }*/
        let isLiked = aDecoder.decodeBool(forKey: Task.Keys.isLiked)
        
        self.init(caption: caption, description: description, dueDate: dueDate, categories: categories, hashTags: hashTags)
        self.id = id
        self.isDone = isDone
        //self.isCancelled = isCancelled
        self.frequency = frequency
        self.isLiked = isLiked
    }
    
    // MARK: - Public Methods
    
    func complete() {
        self.isDone = true
        ToDoListContext.instance.UpdateTask(self)
    }
    
    func snooze() {
        self.dueDate.addTimeInterval(900)
        ToDoListContext.instance.UpdateTask(self)
    }
    
    func cancel() {
        ToDoListContext.instance.RemoveTask(self)
    }
    
}
