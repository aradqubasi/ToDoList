//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Admin on 31.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, DeletableTagDelegate, TagConstructorDelegate, SelectableCategoryDelegate {

    //MARK: - Properties
    var quickTaskName: String?
    var taskDescription: String?
    var taskCategories: [Category] = []
    var taskHashTags: [String] = []
    var taskDueDate: Date?
    var taskIsReoccuring: Task.Frequency?
    var taskToEdit: Task?
    var task: Task? {
        get {
            return CreateTask()
        }
    }
    var notifications = ToDoListContext.instance.notifications
    
    //var categoryButtons: [CategoryPick] = []
    var categoryControls: [SelectableCategory] = []
    var tagViews: [DeletableTag] = []
    var tagAdder: TagConstructor = TagConstructor.init()
    
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
    
    // MARK: - Initialization
    func setToEdit(task: Task?) {
        if let toEdit = task {
            taskToEdit = toEdit
            quickTaskName = toEdit.caption
            taskDescription = toEdit.tDescription
            taskCategories = toEdit.categories
            taskHashTags = toEdit.hashTags
            taskDueDate = toEdit.dueDate
            taskIsReoccuring = toEdit.frequency
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //taskHashTags = ["New", "Oppotunity", "Growth"]
        DrawCategories()
        DrawTags()
        syncViewWithModel()
        taskNameEdit.delegate = self
        descriptionEdit.delegate = self
        addObserver(self, forKeyPath: #keyPath(notifications.completingTaskId), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(notifications.snoozingTaskId), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(notifications.skipTaskId), options: [.new], context: nil)

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        syncViewWithModel()
    }
    //MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        syncViewWithModel()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === taskNameEdit {
            quickTaskName = textField.text
        } else if textField === descriptionEdit {
            taskDescription = textField.text
        }
        syncViewWithModel()
    }
    // MARK: - DeletableTag Delegate methods
    func OnTagDelete(of: DeletableTag) {
        taskHashTags.remove(at: (taskHashTags.index(where: { return $0 == of.tagName }))!)
        syncViewWithModel()
    }
    // MARK: - TagConstructor Delegate Methods
    func pushTag(tag: String) {
        if taskHashTags.index(where: { return $0 == tag }) == nil {
            taskHashTags.append(tag)
        }
        syncViewWithModel()
    }
    // MARK: - SelectableCategory Delegate Methods
    func onCategoryClick(sender: SelectableCategory) {
        if sender.isChecked {
            taskCategories.append(sender.model)
        } else {
            taskCategories.remove(at: taskCategories.index(where: { return $0.id == sender.model.id })!)
        }
        syncViewWithModel()
    }
    // MARK: - Navigation
     
     @IBAction func unwindToTask(sender: UIStoryboardSegue) {
     if let source = sender.source as? DueDateViewController, let dueDate = source.dueDate, let isReoccuring = source.frequency {
            taskDueDate = dueDate
            taskIsReoccuring = isReoccuring
     } /*else if let source = sender.source as? TaskEditViewController, let taskToEdit = source.task {
        quickTaskName = taskToEdit.caption
        taskDescription = taskToEdit.description
        taskCategories = taskToEdit.categories
        taskHashTags = taskToEdit.hashTags
        taskDueDate = taskToEdit.dueDate
        taskIsReoccuring = taskToEdit.frequency
        
        
        
        }
        */
        syncViewWithModel()
     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ToDoListContext.instance.segueId_taskViewToDueDate, let navController = segue.destination as? UINavigationController, let dueDateView = navController.topViewController as? DueDateViewController {
            if let dueDate = taskDueDate {
                dueDateView.dueDate = dueDate as Date?
            } else {
                dueDateView.dueDate = Date.init()
            }
            if taskIsReoccuring != nil {
                dueDateView.frequency = taskIsReoccuring
            } else {
                dueDateView.frequency = Task.Frequency.once
            }
        }
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
        var buttonText = ""
        if taskToEdit != nil {
            buttonText = "Update"
        } else {
            buttonText = "Create"
        }
        createButton.setTitle(buttonText, for: .disabled)
        createButton.setTitle(buttonText, for: .focused)
        createButton.setTitle(buttonText, for: .highlighted)
        createButton.setTitle(buttonText, for: .normal)
        createButton.setTitle(buttonText, for: .selected)
        //
        for categoryControl in categoryControls {
            let state = taskCategories.index(where: { return $0.id == categoryControl.model.id }) != nil
            categoryControl.setState(to: state)
        }
        /*
        for categoryButton in categoryButtons {
            var toCheck: Bool = false
            for category in taskCategories {
                toCheck = toCheck || category === categoryButton.category!
            }
            categoryButton.setState(to: toCheck)
        }
        */
        //
        var newTagViews: [DeletableTag] = []
        for tagView in tagViews {
            if taskHashTags.index(where: { return $0 == tagView.tagName}) == nil {
                tagView.removeFromSuperview()
            } else {
                newTagViews.append(tagView)
            }
        }
        
        tagViews = newTagViews
        for tag in taskHashTags {
            if tagViews.index(where: { return $0.tagName == tag }) == nil {
                let newTag = DeletableTag.init(tag: tag)
                newTag.delegate = self
                tagViews.append(newTag)
                tagsStackView.insertArrangedSubview(newTag, at: tagsStackView.arrangedSubviews.count - 1)
            }
        }
        
        var ttlWidth: CGFloat = 0
        for tagView in tagViews {
            ttlWidth += tagView.width
            ttlWidth += tagsStackView.spacing
        }
        ttlWidth += tagAdder.width
        var toRemove: [NSLayoutConstraint] = []
        for constraint in tagsStackView.constraints {
            if constraint.firstAttribute == .width {
                toRemove.append(constraint)
            }
        }
        tagsStackView.removeConstraints(toRemove)
        tagsStackView.widthAnchor.constraint(equalToConstant: ttlWidth).isActive = true
    }
    private func DrawTags() {
        for tagView in tagViews {
            tagView.removeFromSuperview()
        }
        tagViews.removeAll()
        tagAdder.removeFromSuperview()
        var toRemove: [NSLayoutConstraint] = []
        for constraint in tagsStackView.constraints {
            if constraint.firstAttribute == .width {
                toRemove.append(constraint)
            }
        }
        tagsStackView.removeConstraints(toRemove)
        tagsStackView.addArrangedSubview(tagAdder)
        tagAdder.delegate = self
        tagsStackView.widthAnchor.constraint(equalToConstant: tagAdder.width).isActive = true
    }
    private func DrawCategories() {
        let categories = ToDoListContext.instance.GetCategories()
        for categoryControl in categoryControls {
            categoryControl.removeFromSuperview()
        }
        categoryControls.removeAll()
        
        var ttlWidth: CGFloat = 0
        for category in categories {
            let categoryControl = SelectableCategory.init(of: category, state: false)
            categoriesStackView.addArrangedSubview(categoryControl)
            categoryControls.append(categoryControl)
            ttlWidth += categoryControl.width
            ttlWidth += categoriesStackView.spacing
            categoryControl.delegate = self
        }
        
        ttlWidth -= categoriesStackView.spacing
        var toDelete: [NSLayoutConstraint] = []
        for constraint in categoriesStackView.constraints {
            if constraint.firstAttribute == .width {
                toDelete.append(constraint)
            }
        }
        categoriesStackView.removeConstraints(toDelete)
        categoriesStackView.widthAnchor.constraint(equalToConstant: ttlWidth).isActive = true
        
        /*
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
            //let b = catButton.layer.bounds
            ttlLength += textSize + 18 + categoriesStackView.spacing
            
            

        }
        for constraint in categoriesStackView.constraints {
            if constraint.firstAttribute == .width && constraint.constant != ttlLength {
                constraint.isActive = false
                categoriesStackView.widthAnchor.constraint(equalToConstant: ttlLength).isActive = true
                break
            }
        }
        */
    }
    private func CreateTask() -> Task? {
        if let editedTask = taskToEdit {
            editedTask.caption = quickTaskName!
            editedTask.tDescription = taskDescription!
            editedTask.dueDate = taskDueDate!
            editedTask.categories = taskCategories
            editedTask.hashTags = taskHashTags
            editedTask.frequency = taskIsReoccuring!
            return editedTask
        } else {
        let task = Task.init(caption: quickTaskName!, description: taskDescription!, dueDate: taskDueDate!, categories: taskCategories, hashTags: taskHashTags)
        task?.frequency = taskIsReoccuring!
        return task
        }
    }
    func catButtonClick(button: UIButton) {
        guard  let pickButton = button as? CategoryPick else {
            fatalError("CategoryPick expected but \(button) provided")
        }
        pickButton.check()
        if pickButton.checked {
            taskCategories.append(pickButton.category!)
        } else {
            let pos = taskCategories.index(where: { $0.id == pickButton.category!.id })
            taskCategories.remove(at: pos!)
        }
    }
}
