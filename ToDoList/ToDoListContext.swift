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
    //private var _tasks = [Task]()
    //private var _categories: [Category]?
    //MARK: - Archiving
    static let ArchiveDirecroty = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchCategoryPath = ArchiveDirecroty.appendingPathComponent("categories")
    static let ArchTasksPath = ArchiveDirecroty.appendingPathComponent("tasks")
    //MARK: - Helpers
    static var snoozeTime: TimeInterval {
        return 5
    }
    static func DateForList(of task: Task) -> String {
        

        let dueDateFormatter = DateFormatter()
        var dateString: String = ""
        if task.frequency == .weekly {
            dueDateFormatter.dateFormat = "EEEE, hh:mm a"
            dateString = dueDateFormatter.string(from: task.dueDate)
        }
        else if task.frequency == .daily {
            dueDateFormatter.dateFormat = "hh:mm a"
            dateString = "Daily, " + dueDateFormatter.string(from: task.dueDate)
        }
        else if ToDoListContext.IsToday(task.dueDate) {
            dueDateFormatter.dateFormat = "hh:mm a"
            dateString = "Today, " + dueDateFormatter.string(from: task.dueDate)
        }
        else {
            dueDateFormatter.dateFormat = "MMMM, dd"
            dateString = dueDateFormatter.string(from: task.dueDate)
        }
        return dateString
    }
    static func IsToday(_ day: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date.init()
        var todayComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: now)
        todayComponents.hour = 0
        todayComponents.minute = 0
        todayComponents.second = 0
        let today = todayComponents.date!
        let tomorrow = now.addingTimeInterval(TimeInterval(864000))
        let isToday: Bool = (day >= today) && (day < tomorrow)
        return isToday
    }
    func GetFont(size: CGFloat) -> UIFont {
        guard let font = UIFont.init(name: "Avenir-Light", size: size) else {
            fatalError("font Avenir-Light \(size) was not found")
        }
        return font
    }
    func Font12() -> UIFont {
        return GetFont(size: 12)
    }
    var FontForSimpleTag: UIFont {
        guard let font = UIFont.init(name: "Avenir-Book", size: 12) else {
            fatalError("font Avenir-Book 12 was not found")
        }
        return font
    }
    var FontTasksFilterList: UIFont {
        guard let font = UIFont.init(name: "Avenir-Light", size: 16) else {
            fatalError("font Avenir-Light 16 was not found")
        }
        return font
    }
    var FilterDropdownAttributes: [String : Any?] {
        return [NSFontAttributeName: self.GetFont(size: 16), NSForegroundColorAttributeName: self.tdDarkGrey] 
    }
    func SelectableCategoryFont() -> UIFont {
        return GetFont(size: 13)
    }
    func CalculateSize(for text: String, at font: UIFont) -> CGFloat {
        let textSize = (text as NSString).size(attributes: [NSFontAttributeName: font]).width + 2
        return textSize
    }
    var tdAqua: UIColor {
        return UIColor(red: 28.0 / 255.0, green: 197.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    var tdSilver: UIColor {
        return UIColor(red: 197.0 / 255.0, green: 196.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
    }
    var tdRosyPink: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 111.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
    }
    var tdBlush: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 169.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
    }
    var tdLightTeal: UIColor {
        return UIColor(red: 103.0 / 255.0, green: 227.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
    }
    var tdSeafoamBlue: UIColor {
        return UIColor(red: 101.0 / 255.0, green: 199.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    }
    var tdSandy: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 219.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    }
    var tdPaleGrey: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 232.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }
    var tdDarkGrey: UIColor {
        return UIColor(red: 46.0 / 255.0, green: 50.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
    }
    // MARK: - Segue Identifiers
    var segueId_tasksToTaskEdit: String {
        return "tasksToTaskEdit"
    }
    var segueId_taskEditTotaskView: String {
        return "taskEditTotaskView"
    }
    var segueId_taskViewToDueDate: String {
        return "taskViewToDueDate"
    }
    var segueId_taskFiltersToTaskList: String {
        return "taskFiltersToTaskList"
    }
    //MARK: Repositary methods
    func AddTask(_ newTask: Task) {
        var _tasks = ToDoListContext.instance.GetTasks()
        _tasks.append(newTask)
        if !newTask.isCancelled {
            notifications.pushNotification(for: newTask)
        }
        NSKeyedArchiver.archiveRootObject(_tasks, toFile: ToDoListContext.ArchTasksPath.path)
    }
    func UpdateTask(_ updatedTask: Task) {
        var _tasks = ToDoListContext.instance.GetTasks()
        guard let index = _tasks.index(where: { return $0.id == updatedTask.id }) else {
            fatalError("task to update is not in list \(updatedTask)")
        }
        _tasks[index] = updatedTask
        NSKeyedArchiver.archiveRootObject(_tasks, toFile: ToDoListContext.ArchTasksPath.path)
    }
    func RemoveTask(_ taskToRemove: Task) {
        var _tasks = ToDoListContext.instance.GetTasks()
        for i in 0..<_tasks.count {
            if _tasks[i].id == taskToRemove.id {
                _tasks.remove(at: i)
                break
            }
        }
        NSKeyedArchiver.archiveRootObject(_tasks, toFile: ToDoListContext.ArchTasksPath.path)
    }
    func GetTask(id: UUID) -> Task? {
        let tasks = GetTasks()
        let task = tasks.first(where: {(task: Task) in
            return task.id == id
        })
        return task
    }
    func GetTasks() -> [Task] {
        var _tasks: [Task] = []
        if let tasks = NSKeyedUnarchiver.unarchiveObject(withFile: ToDoListContext.ArchTasksPath.path) as? [Task] {
            _tasks = tasks
        } else {
            _tasks = pregenTasks()
            NSKeyedArchiver.archiveRootObject(_tasks, toFile: ToDoListContext.ArchTasksPath.path)
        }
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
        var _categories: [Category] = []
        if let categories = NSKeyedUnarchiver.unarchiveObject(withFile: ToDoListContext.ArchCategoryPath.path) as? [Category] {
            _categories = categories
        } else {
            _categories = pregenCategories()
            NSKeyedArchiver.archiveRootObject(_categories, toFile: ToDoListContext.ArchCategoryPath.path)
        }
        return _categories
    }
    private var _currentFilter: TasksFilter?
    private var _filters: [TasksFilter]?
    var currentFilter: TasksFilter {
        get {
            if let filter = _currentFilter {
                return filter
            } else {
                let filter = TasksFilterAll()
                _currentFilter = filter
                return filter
            }
        }
        set(new) {
            _currentFilter = new
        }
    }
    var filters: [TasksFilter] {
        get {
            if let filters = _filters {
                return filters
            } else {
                let filters: [TasksFilter] = [TasksFilterAll(), TasksFilterToday(), TasksFilterUpcomming()]
                _filters = filters
                return filters
            }
        }
        set(new) {
            _filters = new
        }
    }
    //MARK: Pregeneration
    private func pregenCategories() -> [Category] {
        let bundle = Bundle.init(for: type(of: self))
        let workCat = UIImage.init(named: "workCat", in: bundle, compatibleWith: nil)
        let learnCat = UIImage.init(named: "learnCat", in: bundle, compatibleWith: nil)
        let sportCat = UIImage.init(named: "sportCat", in: bundle, compatibleWith: nil)
        let healthCat = UIImage.init(named: "healthCat", in: bundle, compatibleWith: nil)
        let relationshipCat = UIImage.init(named: "relationshipCat", in: bundle, compatibleWith: nil)
        let foodCat = UIImage.init(named: "foodCat", in: bundle, compatibleWith: nil)
        
        guard let cat1 = Category.init(name: "Work", icon: workCat, color: self.tdRosyPink) else {
            fatalError("can't work")
        }
        guard let cat2 = Category.init(name: "Learn", icon: learnCat, color: self.tdSeafoamBlue) else {
            fatalError("can't learn")
        }
        guard let cat3 = Category.init(name: "Sport", icon: sportCat, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)) else {
            fatalError("can't do sport")
        }
        guard let cat4 = Category.init(name: "Health", icon: healthCat, color: self.tdLightTeal) else {
            fatalError("no health")
        }
        guard let cat5 = Category.init(name: "Relationship", icon: relationshipCat, color: self.tdBlush) else {
            fatalError("no relationship")
        }
        guard let cat6 = Category.init(name: "Food", icon: foodCat, color: self.tdSandy) else {
            fatalError("no food")
        }
        
        return [cat1, cat2, cat3, cat4, cat5, cat6]
    }
    private func pregenTasks() -> [Task] {
        //let bundle = Bundle.init(for: type(of: self))
        
        let cal = Calendar.current
        var comp = DateComponents()
        let curDay = cal.dateComponents([.year, .month, .day], from: Date.init())
        
        comp.year = curDay.year
        comp.month = 2
        comp.day = 20
        guard let task1 = Task.init(caption: "Create new Galaxy", description:  "do it in a right way this time", dueDate: cal.date(from: comp)!, categories: [], hashTags: ["Friends", "Family"] ) else {
            fatalError("error -> Create new Galaxy")
        }
        task1.isDone = true
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 6
        comp.minute = 0
        guard let task2 = Task.init(caption: "Morning Run", description:  "come to the blissful light of the morning sun", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Morning Run")
        }
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 7
        comp.minute = 0
        guard let task3 = Task.init(caption: "Do Yoga", description:  "and prepare for paradise", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Do Yoga")
        }
        //categories: [cat3, cat4]
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 8
        comp.minute = 0
        guard let task4 = Task.init(caption: "Coffee with Andy", description:  "this have consequences", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Coffee with Andy")
        }
        //categories: [cat6]
        task4.isLiked = true
        
        comp.year = curDay.year
        comp.month = curDay.month
        comp.day = curDay.day
        comp.hour = 9
        comp.minute = 0
        guard let task5 = Task.init(caption: "Video Conference", description:  "boring...", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Video Conference")
        }
        
        comp.year = curDay.year
        comp.month = 2
        comp.day = 13
        guard let task6 = Task.init(caption: "Design Landing page", description:  "", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Design Landing page")
        }
        task6.isDone = true
        //task6.isCancelled = true
        
        comp.year = curDay.year
        comp.month = 2
        comp.day = 20
        guard let task7 = Task.init(caption: "Dantist appointment", description:  "scary!", dueDate: cal.date(from: comp)!, categories: [], hashTags: [] ) else {
            fatalError("error -> Dantist appointment")
        }
        //task7.isCancelled = true
        
        return [task1, task2, task3, task4, task5, task6, task7]
    }
    //MARK: Constructor
    init() {

    }
    // MARK: - Notification Handling
    
    private var _notifications: TDNotificationCenter?
    var notifications: TDNotificationCenter {
        get {
            if _notifications == nil {
                _notifications = TDNotificationCenter.init()
            }
            return _notifications!
        }
    }
    private var _notificationToShow: UUID?
    var notificationToShow: UUID? {
        get {
            let id = _notificationToShow
            _notificationToShow = nil
            return _notificationToShow
        }
        set(new) {
            _notificationToShow = new
        }
    }
}
