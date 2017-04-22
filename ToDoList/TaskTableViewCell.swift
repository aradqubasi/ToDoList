//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell, SelectableCategoryDelegate {
    //MARK: constants
    public static let identifier = "TaskTableViewCell"
    //MARK: Properties
    
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var categoriesStack: UIStackView!
    //var categoryLabels = [UILabel]()
    //@IBOutlet weak var dueDateLabel: UILabel!
    var categories: [SelectableCategory] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK: - SelectableCategoryDelegate Methods
    func onCategoryClick(sender: SelectableCategory) {
        
    }
    func onStateChange(from: Bool) -> Bool {
        return from
    }
    // MARK: - Public functions
    func setCellValue(forTask task: Task) {
        //set caption
        let captionText = NSMutableAttributedString(string: task.caption)
        self.captionLabel.attributedText = captionText
        //set description
        //set dueDate
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.day], from: Date.init(), to: task.dueDate)
        let dueDateFormatter = DateFormatter()
        switch diff.day! {
        case 0: dueDateFormatter.dateFormat = "hh:mm a"
        dueDateLabel.text = "Today, " + dueDateFormatter.string(from: task.dueDate)
        default: dueDateFormatter.dateFormat = "MMMM, dd"
        dueDateLabel.text = dueDateFormatter.string(from: task.dueDate)
        }
        //set isDone
        let bundle = Bundle(for: type(of: self))
        var stateImage: UIImage?
        if task.isDone {
            stateImage = UIImage(named: "doneSwitch", in: bundle, compatibleWith: self.traitCollection)
        } else {
            stateImage = UIImage(named: "scheduledSwitch", in: bundle, compatibleWith: self.traitCollection)
        }
        stateButton.setImage(stateImage, for: .focused)
        stateButton.setImage(stateImage, for: .highlighted)
        stateButton.setImage(stateImage, for: .normal)
        stateButton.setImage(stateImage, for: .selected)
        //stateButton.setImage(stateImage, for: [.focused, .highlighted, .normal, .selected])
        //set isCancelled
        stateButton.isEnabled = !task.isCancelled
        captionLabel.isEnabled = !task.isCancelled
        if task.isCancelled {
            captionText.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, captionText.length))
            self.captionLabel.attributedText = captionText
        }
        dueDateLabel.isEnabled = !task.isCancelled
        //set categoriesStack
        for category in categories {
            category.removeFromSuperview()
        }
        categories.removeAll()
        var ttlLength: CGFloat = 0
        for category in task.categories {
            let categoryLabel = SelectableCategory.init(of: category, state: true)
            categoryLabel.delegate = self
            categoriesStack.addArrangedSubview(categoryLabel)
            categories.append(categoryLabel)
            ttlLength += categoryLabel.width
            ttlLength += categoriesStack.spacing
            
        }
        if ttlLength != 0 {
            ttlLength -= categoriesStack.spacing
        }
        var widthConstrains: [NSLayoutConstraint] = []
        for constraint in categoriesStack.constraints {
            if constraint.firstAttribute == .width {
                widthConstrains.append(constraint)
            }
        }
        categoriesStack.removeConstraints(widthConstrains)
        categoriesStack.widthAnchor.constraint(equalToConstant: ttlLength)
        
        /*
        for catLabel in categoryLabels {
            catLabel.removeFromSuperview()
        }
        categoryLabels.removeAll()
        for cat in task.categories {
            let catLabel = UILabel()
            catLabel.text = cat.name
            catLabel.backgroundColor = cat.color
            catLabel.layer.masksToBounds = true
            catLabel.layer.cornerRadius = 8
            catLabel.translatesAutoresizingMaskIntoConstraints = false
            let textSize = (cat.name as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]).width
            catLabel.widthAnchor.constraint(equalToConstant: textSize + 16).isActive = true
            catLabel.textAlignment = .center
            categoriesStack.addArrangedSubview(catLabel)
            categoryLabels.append(catLabel)
        }
        let trailingLabel = UILabel()
        categoriesStack.addArrangedSubview(trailingLabel)
        */
    }
}
