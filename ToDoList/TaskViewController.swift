//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Admin on 31.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    var quickTaskName: String?
    var taskDescription: String?
    var taskCategories: [Category]?
    var taskHashTags: [String]?
    var taskDueDate: Date?
    var taskIsReoccuring: Bool?
    var task: Task?
    
    @IBOutlet weak var taskNameEdit: UITextField!
    @IBOutlet weak var descriptionEdit: UITextField!
    @IBOutlet weak var subtaskLabel: UILabel!
    @IBOutlet weak var chooseSubtaskButton: UIButton!
    @IBOutlet weak var categoriesStackView: UIStackView!
    @IBOutlet weak var tagsStackView: UIStackView!
    @IBOutlet weak var chooseDateButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncViewWithModel()
        taskNameEdit.delegate = self
        descriptionEdit.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === taskNameEdit {
            quickTaskName = textField.text
        } else if textField === descriptionEdit {
            taskDescription = textField.text
        }
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Navigation
     
     @IBAction func unwindToTask(sender: UIStoryboardSegue) {
     if let source = sender.source as? DueDateViewController, let dueDate = source.dueDate, let isReoccuring = source.isReoccuring {
            taskDueDate = dueDate
            taskIsReoccuring = isReoccuring
        }
     syncViewWithModel()
     }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    // MARK: - Actions
    
    @IBAction func CreateButtonClick(_ sender: Any) {
        task = CreateTask()
    }
    // MARK: - Private Methods
    private func syncViewWithModel() {
        if (quickTaskName != nil) {
            taskNameEdit.text = quickTaskName
        } else {
            taskNameEdit.text = ""
        }
        
        if (taskDescription != nil) {
            descriptionEdit.text = taskDescription
        } else {
            descriptionEdit.text = ""
        }
        
        if (taskDueDate != nil) {
            let dueDateFormatter = DateFormatter()
            dueDateFormatter.dateFormat = "MMMM dd, HH:mm"
            dueDateLabel.text = dueDateFormatter.string(from: taskDueDate!)
        } else {
            dueDateLabel.text = "Due Date"
        }
        
        //
        var isValid = false
        if (quickTaskName == nil) {
            isValid = false
        } else if (taskDescription == nil) {
            isValid = false
        } else if (taskDueDate == nil) {
            isValid = false
        } else if (taskIsReoccuring == nil) {
            isValid = false
        } else {
            isValid = true
        }
        createButton.isEnabled = isValid
    }
    private func CreateTask() -> Task? {
        let task = Task.init(caption: quickTaskName!, description: taskDescription!, dueDate: taskDueDate!, categories: [], hashTags: [])
        task?.isReoccuring = taskIsReoccuring!
        return task
    }
}
