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
    var taskCategories: [Category] = []
    var taskHashTags: [String]?
    var taskDueDate: Date?
    var taskIsReoccuring: Task.Frequency?
    var task: Task? {
        get {
            return CreateTask()
        }
    }
    
    var categoryButtons: [CategoryPick] = []
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DrawCategories()
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
        syncViewWithModel()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === taskNameEdit {
            quickTaskName = textField.text
        } else if textField === descriptionEdit {
            taskDescription = textField.text
        }
        textField.resignFirstResponder()
        syncViewWithModel()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: - Navigation
     
     @IBAction func unwindToTask(sender: UIStoryboardSegue) {
     if let source = sender.source as? DueDateViewController, let dueDate = source.dueDate, let isReoccuring = source.frequency {
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
        //task = CreateTask()
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
        //
        taskCategories.removeAll()
        for categoryButton in categoryButtons {
            if categoryButton.checked {
                guard let catFromButton = categoryButton.category else {
                    fatalError("category is empty")
                }
                taskCategories.append(catFromButton)
            }
        }
    }
    private func DrawCategories() {
        let categories = ToDoListContext.instance.GetCategories()
        for button in categoryButtons {
            button.removeFromSuperview()
        }
        categoryButtons.removeAll()
        var ttlLength: CGFloat = 0
        for cat in categories {
            let catButton = CategoryPick.init()
            
            //catButton.setTitle(cat.name, for: .disabled)
            let title = NSAttributedString.init(string: cat.name , attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
            catButton.setAttributedTitle(title, for: .disabled)
            catButton.setTitleColor(UIColor.black, for: .disabled)
            
            catButton.setAttributedTitle(title, for: .focused)
            catButton.setTitleColor(UIColor.black, for: .focused)
            
            catButton.setAttributedTitle(title, for: .highlighted)
            catButton.setTitleColor(UIColor.black, for: .highlighted)
            
            catButton.setAttributedTitle(title, for: .selected)
            catButton.setTitleColor(UIColor.white, for: .selected)
            
            catButton.setAttributedTitle(title, for: .normal)
            catButton.setTitleColor(UIColor.black, for: .normal)
            
            let textSize = (cat.name as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]).width
            catButton.widthAnchor.constraint(equalToConstant: textSize + 18).isActive = true
            catButton.layer.masksToBounds = true
            catButton.layer.cornerRadius = 8
            catButton.titleEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            //catButton.backgroundColor = cat.color
            
            catButton.addTarget(self, action: #selector(catButtonClick(button:)), for: .touchUpInside)
            
            catButton.setColor(for: cat)
            
            categoriesStackView.addArrangedSubview(catButton)
            categoryButtons.append(catButton)
            ttlLength += textSize + 18 + categoriesStackView.spacing
        }
        categoriesStackView.widthAnchor.constraint(equalToConstant: ttlLength).isActive = true
        categoriesStackView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        //categoriesStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        //categoriesStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        //categoriesStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        //categoriesStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    private func CreateTask() -> Task? {
        let task = Task.init(caption: quickTaskName!, description: taskDescription!, dueDate: taskDueDate!, categories: taskCategories, hashTags: [])
        task?.frequency = taskIsReoccuring!
        return task
    }
    func catButtonClick(button: UIButton) {
        guard  let pickButton = button as? CategoryPick else {
            fatalError("CategoryPick expected but \(button) provided")
        }
        pickButton.check()
    }
}
