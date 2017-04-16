//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Admin on 31.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController, UITextFieldDelegate, DeletableTagDelegate {

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
        DrawTags()
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
        of.removeFromSuperview()
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
        for categoryButton in categoryButtons {
            var toCheck: Bool = false
            for category in taskCategories {
                toCheck = toCheck || category === categoryButton.category!
            }
            categoryButton.setState(to: toCheck)
        }
        
    }
    private func DrawTags() {
        /*
        let tagLabel = UILabel.init()
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.textColor = UIColor.black
        tagLabel.text = "Tag"
        let font = ToDoListContext.instance.Font12()
        tagLabel.font = font
        tagLabel.widthAnchor.constraint(equalToConstant: ToDoListContext.instance.CalculateSize(for: "Tag", at: font)).isActive = true
        let h = font.lineHeight
        tagLabel.heightAnchor.constraint(equalToConstant: h).isActive = true
        tagLabel.setContentCompressionResistancePriority(250, for: .horizontal)
        
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 30))
        v.backgroundColor = UIColor.white
        v.addSubview(tagLabel)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        tagLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 12).isActive = true
        tagLabel.topAnchor.constraint(equalTo: v.topAnchor, constant: 8).isActive = true
        
        tagsStackView.addArrangedSubview(v)
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        */
        
        //let t = DeletableTag.init(tag: "Tag")
        //t.widthAnchor.constraint(equalToConstant: 20).isActive = true
        //t.heightAnchor.constraint(equalToConstant: 40).isActive = true
                //tagsStackView.addSubview(t)
        //tagsStackView.addArrangedSubview(t)
        //t.attachTagLabel()
        let tag = DeletableTag.init(tag: "Tag")
        tag.delegate = self
        tagsStackView.addArrangedSubview(tag)
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
        if pickButton.checked {
            taskCategories.append(pickButton.category!)
        } else {
            let pos = taskCategories.index(where: { $0 === pickButton.category! })
            taskCategories.remove(at: pos!)
        }
    }
}
