//
//  TaskEditViewController.swift
//  ToDoList
//
//  Created by Admin on 23.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskEditViewController: UIViewController, SelectableCategoryDelegate {
    // MARK: - Properties
    var task: Task?
    
    // MARK: - SubViews
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoriesStack: UIStackView!
    @IBOutlet weak var tagsStack: UIStackView!
    var categories: [SelectableCategory] = []
    var tags: [SimpleTag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SelectableCategory Delegate
    func onCategoryClick(sender: SelectableCategory) {
        
    }
    func onStateChange(from: Bool) -> Bool {
        return from
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Private Methods
    private func syncView() {
        guard let task = self.task else {
            fatalError("task for edit was not specified")
        }
        let bundle = Bundle.init(for: type(of: self))
        var ttlLength: CGFloat = 0
        var toRemove: [NSLayoutConstraint] = []
        
        //check button
        let checkImg = UIImage.init(named: "notCheck", in: bundle, compatibleWith: self.traitCollection)
        let notCheckImg = UIImage.init(named: "check", in: bundle, compatibleWith: self.traitCollection)
        if task.isDone {
            setButtonStateImages(current: checkImg, next: notCheckImg, for: checkButton)
        } else {
            setButtonStateImages(current: notCheckImg, next: checkImg, for: checkButton)
        }
        
        //like button
        let likedImg = UIImage.init(named: "rubyHeart", in: bundle, compatibleWith: self.traitCollection)
        let notLikedImg = UIImage.init(named: "storeHeart", in: bundle, compatibleWith: self.traitCollection)
        if task.isLiked {
            setButtonStateImages(current: likedImg, next: notLikedImg, for: likeButton)
        } else {
            setButtonStateImages(current: notLikedImg, next: likedImg, for: likeButton)
        }
        
        //name
        nameLabel.text = task.caption
        
        //desc
        descLabel.text = task.description
        
        //date
        dateLabel.text = ToDoListContext.instance.dateToString(task.dueDate)
        
        //categories
        for category in categories {
            category.removeFromSuperview()
        }
        categories.removeAll()
        ttlLength = 0
        for category in task.categories {
            let categoryView = SelectableCategory.init(of: category, state: true)
            categoryView.delegate = self
            categoriesStack.addArrangedSubview(categoryView)
            categories.append(categoryView)
            ttlLength += categoryView.width + categoriesStack.spacing
        }
        ttlLength -= categoriesStack.spacing
        for constraint in categoriesStack.constraints {
            if constraint.firstAttribute == .width {
                categoriesStack.removeConstraint(constraint)
            }
        }
        categoriesStack.widthAnchor.constraint(equalToConstant: ttlLength).isActive = true
        
        //tags
        for tag in tags {
            tag.removeFromSuperview()
        }
        tags.removeAll()
        toRemove = []
        for contraint in tagsStack.constraints {
            if contraint.firstAttribute == .width {
                //tagsStack.removeConstraint(contraint)
                toRemove.append(contraint)
            }
        }
        tagsStack.removeConstraints(toRemove)
        ttlLength = 0
        for tag in task.hashTags {
            let simpleTag = SimpleTag.init(tag)
            tagsStack.addArrangedSubview(simpleTag)
            tags.append(simpleTag)
            ttlLength += simpleTag.width + tagsStack.spacing
        }
        ttlLength -= tagsStack.spacing
        tagsStack.widthAnchor.constraint(equalToConstant: ttlLength).isActive = true
    }
    private func setButtonStateImages(current: UIImage?, next: UIImage?, for button: UIButton) {
        button.setImage(current, for: .focused)
        button.setImage(current, for: .normal)
        button.setImage(current, for: .selected)
        button.setImage(next, for: .highlighted)
    }
}
