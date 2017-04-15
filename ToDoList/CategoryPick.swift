//
//  CategoryPick.swift
//  ToDoList
//
//  Created by Admin on 09.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CategoryPick: UIButton {
    //MARK: - Properties
    var checked: Bool = false
    var category: Category?
    func setColor(for cat: Category) {
        category = cat
    }
    func check() {
        checked = !checked
        if checked {
            self.backgroundColor = category?.color
        } else {
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    /*
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = miscBackgroundColor
        }
    }
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = miscBackgroundColor
        }
    }
    override open var isSelected: Bool {
        didSet {
            backgroundColor = selectedBackgroundColor
        }
    }
 */
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
