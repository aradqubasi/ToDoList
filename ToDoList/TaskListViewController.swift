//
//  ViewController.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var taskListTableView: TaskListTableView!
    @IBOutlet weak var filtersDropdownButton: UIButton!
    @IBOutlet weak var taskNameEdit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init task list table view
        //taskListTableView.delegate = self;
        taskListTableView.dataSource = self
        taskListTableView.tasks = ToDoListContext.instance.GetTasks()
        taskNameEdit.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = TaskTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("failed ot instantiate tableview cell")
        }
        let task = taskListTableView.tasks[indexPath.row]
        cell.setCellValue(forTask: task)
        //cell.isDoneSwitch.isOn = task.isDone
        //cell.taskCaptionLabel.text = task.caption
        //cell.dueDateLabel.text = String(describing: task.dueDate)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListTableView.tasks.count
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
            pop?.barButtonItem = nil
            pop?.sourceView = filtersDropdownButton
            pop?.sourceRect = filtersDropdownButton.bounds
            pop?.delegate = self
            
        } else if segue.identifier == "quickTaskCreation" {
            guard  let taskView = segue.destination as? TaskViewController else {
                fatalError("unexpected destanation - \(segue.destination) instead of TaskViewController")
            }
            taskView.quickTaskName = taskNameEdit.text
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
    }

