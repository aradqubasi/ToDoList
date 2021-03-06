//
//  ViewController.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import UserNotifications

class TaskListViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITableViewDelegate {
    //MARK: Properties
    var tasks: [Task] {
        get {
            return filter.filteredTasks
            //return ToDoListContext.instance.GetTasks()
        }
    }
    var taskIndexToEdit: IndexPath?
    var filter: TasksFilter = ToDoListContext.instance.currentFilter
    var notifications = ToDoListContext.instance.notifications
    @IBOutlet weak var taskListTableView: TaskListTableView!
    @IBOutlet weak var filtersDropdownButton: UIButton!
    @IBOutlet weak var taskNameEdit: UITextField!
    @IBOutlet weak var filterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init task list table view
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        taskListTableView.layoutMargins = .zero
        taskListTableView.separatorInset = .zero
        //taskListTableView.tasks = ToDoListContext.instance.GetTasks()
        taskNameEdit.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        taskNameEdit.layer.borderColor = ToDoListContext.instance.tdPaleGrey.cgColor
        


        syncView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver(self, forKeyPath: #keyPath(notifications.completingTaskId), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(notifications.snoozingTaskId), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(notifications.skipTaskId), options: [.new], context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //print("viewWillDisappear")
        removeObserver(self, forKeyPath: #keyPath(notifications.completingTaskId))
        removeObserver(self, forKeyPath: #keyPath(notifications.skipTaskId))
        removeObserver(self, forKeyPath: #keyPath(notifications.snoozingTaskId))
    }
    // MARK: - Update notifications
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(notifications.completingTaskId) {
            print("update table list complete")
            syncView()
        }
        else if keyPath == #keyPath(notifications.snoozingTaskId) {
            print("update table list snooze")
            syncView()

        }
        else if keyPath == #keyPath(notifications.skipTaskId) {
            print("update table list skip")
            let toRemove = notifications.skipTaskId!
            let tasks = ToDoListContext.instance.GetTasks()
            let indexToRemove = tasks.index(where: {(next: Task) -> Bool in
                let hit = next.id == toRemove
                return hit
            })
            tasks[indexToRemove!].cancel()
            taskListTableView.deleteRows(at: [IndexPath(row: indexToRemove!, section: 0)], with: .fade)
            //taskListTableView.cell
            syncView()
        }
    }
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = TaskTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("failed ot instantiate tableview cell")
        }
        let task = tasks[indexPath.row]
        cell.setCellValue(forTask: task)
        cell.layoutMargins = .zero
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDoListContext.instance.RemoveTask(tasks[indexPath.row])
            taskListTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // MARK: - TableViewDelegateMethods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction.init(style: .destructive, title: "Delete") {
            action, index in
            ToDoListContext.instance.RemoveTask(self.tasks[indexPath.row])
            self.taskListTableView.deleteRows(at: [indexPath], with: .fade)
        }
        let edit = UITableViewRowAction.init(style: .normal, title: " Edit ", handler: {
            action, index in
            self.taskIndexToEdit = index
            self.performSegue(withIdentifier: ToDoListContext.instance.segueId_tasksToTaskEdit, sender: self)
            self.taskListTableView.setEditing(false, animated: false)
        })
        return [delete, edit]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.taskIndexToEdit = indexPath
        self.performSegue(withIdentifier: ToDoListContext.instance.segueId_tasksToTaskEdit, sender: self)
        self.taskListTableView.deselectRow(at: indexPath, animated: false)
    }
    //MARK: UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameEdit.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasksFilters" {
            let vc = segue.destination as? TasksFiltersViewController
            let pop = vc?.popoverPresentationController
            vc?.preferredContentSize = CGSize(width: 300, height: 300)
            //pop?.popoverLayoutMargins.top = 200
            pop?.permittedArrowDirections = .up
            pop?.barButtonItem = nil
            pop?.sourceView = filtersDropdownButton
            pop?.sourceRect = filtersDropdownButton.bounds
            pop?.delegate = self
            
        } else if segue.identifier == "quickTaskCreation" {
            guard  let taskView = segue.destination as? TaskViewController else {
                fatalError("unexpected destanation - \(segue.destination) instead of TaskViewController")
            }
            taskView.quickTaskName = taskNameEdit.text
        } else if segue.identifier == ToDoListContext.instance.segueId_tasksToTaskEdit {
            guard let taskEdit = segue.destination as? TaskEditViewController else {
                fatalError("unexpected destanation - \(segue.destination) instead of TaskEditViewController")
            }
            guard let index = taskIndexToEdit else {
                fatalError("no selected row")
            }
            guard let selected = taskListTableView.cellForRow(at: index) as? TaskTableViewCell else {
                fatalError("tryring to edit row at table where none was selected")
            }
            guard let task = selected.task else {
                fatalError("task instance is not assigned to table cell view")
            }
            taskEdit.task = task
        }
    }
    @IBAction func unwindToTasks(sender: UIStoryboardSegue) {
        if let source = sender.source as? TaskViewController {
            if ToDoListContext.instance.GetTasks().index(where: { return $0.id == source.task!.id }) == nil {
                ToDoListContext.instance.AddTask(source.task!)
            } else {
                ToDoListContext.instance.UpdateTask(source.task!)
            }
            syncView()
        } else if let source = sender.source as? TaskEditViewController {
            ToDoListContext.instance.UpdateTask(source.task!)
            syncView()
        } else if sender.source is TasksFiltersViewController {
            syncView()
        }
    }
    //MARK: Private methods
    func getSampleTasks() -> [Task] {
        guard let task1 = Task.init(caption: "Corrupt souls", description:  "", dueDate: Date.init(), categories: [], hashTags: [] ) else {
            fatalError("souls are pure...")
        }
        guard let task2 = Task.init(caption: "Twist the minds", description:  "", dueDate: Date.init(), categories: [], hashTags: [] ) else {
            fatalError("minds are clear...")
        }
        guard let task3 = Task.init(caption: "Destroy all what is good and fair", description:  "", dueDate: Date.init(), categories: [], hashTags: [] ) else {
            fatalError("everything is undestructible")
        }
        return [task1, task2, task3]
    }
    private func syncView() {
        filter = ToDoListContext.instance.currentFilter
        taskListTableView.reloadData()
        if let firstRow = filter.firstTask {
            taskListTableView.scrollToRow(at: IndexPath.init(row: firstRow, section: 0), at: .top, animated: false)
        }
        filterLabel.attributedText = NSAttributedString.init(string: filter.name, attributes: ToDoListContext.instance.FilterDropdownAttributes)
        /*
        let states: [UIControlState] = [.disabled, .focused, .highlighted, .normal]
        for state in states {
        filtersDropdownButton.setAttributedTitle(NSAttributedString.init(string: filter.name, attributes: ToDoListContext.instance.FilterDropdownAttributes), for: state)
        }
         */
        }
    }

