//
//  ToDoListContext.swift
//  ToDoList
//
//  Created by Admin on 30.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//
import Foundation
import UIKit
class ToDoListContext {
    static let instance = ToDoListContext()
    //MARK: Private Methods
    private var _tasks = [Task]()
    private var _categories = [Category]()
    //MARK: Repositary methods
    func AddTask(_ newTask: Task) {
        _tasks.append(newTask)
    }
    func UpdateTask(_: Task) {
        
    }
    func RemoveTask(_ taskToRemove: Task) {
        for i in 0..<_tasks.count {
            if _tasks[i] === taskToRemove {
                _tasks.remove(at: i)
                break
            }
        }
    }
    /*
    func GetTask(id: UUID) -> Task {
        return
    }
    */
    func GetTasks() -> [Task] {
        return _tasks
    }
    func AddCategory(_: Task) {
        
    }
    func UpdateCategory(_: Category) {
        
    }
    func RemoveCategory(_: Category) {
        
    }
    /*
    func GetCategory(id: UUID) -> Category {
        return
    }
    */
    func GetCategories() -> [Category] {
        return _categories
    }
    //MARK: Constructor
    init() {
        let bundle = Bundle.init(for: type(of: self))
        let workCat = UIImage.init(named: "workCat", in: bundle, compatibleWith: nil)
        let learnCat = UIImage.init(named: "learnCat", in: bundle, compatibleWith: nil)
        let sportCat = UIImage.init(named: "sportCat", in: bundle, compatibleWith: nil)
        let healthCat = UIImage.init(named: "healthCat", in: bundle, compatibleWith: nil)
        let relationshipCat = UIImage.init(named: "relationshipCat", in: bundle, compatibleWith: nil)
        let foodCat = UIImage.init(named: "foodCat", in: bundle, compatibleWith: nil)
        
        guard let cat1 = Category.init(name: "Work", icon: workCat, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)) else {
            fatalError("can't work")
        }
        guard let cat2 = Category.init(name: "Learn", icon: learnCat, color: #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)) else {
            fatalError("can't learn")
        }
        guard let cat3 = Category.init(name: "Sport", icon: sportCat, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)) else {
            fatalError("can't do sport")
        }
        guard let cat4 = Category.init(name: "Health", icon: healthCat, color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)) else {
            fatalError("no health")
        }
        guard let cat5 = Category.init(name: "Relationship", icon: relationshipCat, color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)) else {
            fatalError("no relationship")
        }
        guard let cat6 = Category.init(name: "Food", icon: foodCat, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) else {
            fatalError("no food")
        }
        
        _categories.append(cat1)
        _categories.append(cat2)
        _categories.append(cat3)
        _categories.append(cat4)
        _categories.append(cat5)
        _categories.append(cat6)
        
        let cal = Calendar.current
        var comp = DateComponents()
        let curDay = cal.dateComponents([.year, .month, .day], from: Date.init())
        
        comp.year = curDay.year
        comp.month = 2
        comp.day = 20
        guard let task1 = Task.init(caption: "Create new Galaxy", description:  "", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Create new Galaxy")
        }
        task1.isDone = true
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 6
        comp.minute = 0
        guard let task2 = Task.init(caption: "Morning Run", description:  "", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Morning Run")
        }
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 7
        comp.minute = 0
        guard let task3 = Task.init(caption: "Do Yoga", description:  "", dueDate: cal.date(from: comp)!, categories: [cat3, cat4], hashTags: [] ) else {
            fatalError("error -> Do Yoga")
        }
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 8
        comp.minute = 0
        guard let task4 = Task.init(caption: "Coffee with Andy", description:  "", dueDate: cal.date(from: comp)!, categories: [cat6], hashTags: [] ) else {
            fatalError("error -> Coffee with Andy")
        }
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 9
        comp.minute = 0
        guard let task5 = Task.init(caption: "Video Conference", description:  "", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Video Conference")
        }
        
        comp.year = curDay.year
        comp.month = 2
        comp.day = 13
        guard let task6 = Task.init(caption: "Design Landing page", description:  "", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Design Landing page")
        }
        task6.isDone = true
        task6.isCancelled = true
        
        comp.year = curDay.year
        comp.month = 2
        comp.day = 20
        guard let task7 = Task.init(caption: "Dantist appointment", description:  "", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Dantist appointment")
        }
        task7.isCancelled = true
        
        _tasks = [task1, task2, task3, task4, task5, task6, task7]
    }
}
