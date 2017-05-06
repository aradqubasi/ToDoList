//
//  FiltersStack.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class FiltersStack: UIStackView {
    // MARK: - Private Properties
    
    private var filters: [TasksFilter] = []
    
    private var filterButtons: [UIButton] = []
    private var separators: [UIView] = []
    
    // MARK: - Public Properties
    
    var delegate: FiltersStackDelegate?
    
    var font: UIFont = ToDoListContext.instance.FontTasksFilterList
    
    var textColor: UIColor = ToDoListContext.instance.tdDarkGrey
    
    var separatorColor: UIColor = ToDoListContext.instance.tdPaleGrey
    
    // MARK: - Geometry
    
    private var buttonHeight: CGFloat {
        return 64
    }
    
    private var edgeToButton: CGFloat {
        return 16
    }
    
    private var separatorHeight: CGFloat {
        return 1
    }
    var preferredHeight: CGFloat {
        return buttonHeight * CGFloat(filterButtons.count) + separatorHeight * CGFloat(separators.count)
    }
    
    
    // MARK: - Private Methods
    
    func syncView() {
        if let delegate = self.delegate {
            filters = delegate.filters
        } else {
            filters = []
        }
        
        for button in filterButtons {
            button.removeFromSuperview()
        }
        filterButtons.removeAll()
        for separator in separators {
            separator.removeFromSuperview()
        }
        separators.removeAll()
        
        weak var prevSeparator: UIView?
        //for filter in filters {
        for index in 0..<filters.count {
            let filter = filters[index]
            let filterButton = UIButton.init()

            filterButton.setAttributedTitle(NSAttributedString.init(string: filter.name, attributes: [NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor]), for: .disabled)
            filterButton.setAttributedTitle(NSAttributedString.init(string: filter.name, attributes: [NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor]), for: .focused)
            filterButton.setAttributedTitle(NSAttributedString.init(string: filter.name, attributes: [NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor]), for: .highlighted)
            filterButton.setAttributedTitle(NSAttributedString.init(string: filter.name, attributes: [NSFontAttributeName : self.font, NSForegroundColorAttributeName : self.textColor]), for: .normal)
            
            filterButton.addTarget(self, action: #selector(onFilterClick(sender:)), for: .touchUpInside)
            
            filterButton.contentHorizontalAlignment = .left
            
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview(filterButton)
            filterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.edgeToButton).isActive = true
            filterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            filterButton.heightAnchor.constraint(equalToConstant: self.buttonHeight).isActive = true
            if let prev = prevSeparator {
                filterButton.topAnchor.constraint(equalTo: prev.bottomAnchor).isActive = true
            } else {
                filterButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            
            filterButtons.append(filterButton)
            
            //add separator
            if index != filters.count - 1 {
                let separator = UIView()
                separator.backgroundColor = separatorColor
                self.addArrangedSubview(separator)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: separatorHeight).isActive = true
                separator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                separator.topAnchor.constraint(equalTo: filterButton.bottomAnchor).isActive = true
                separators.append(separator)
                prevSeparator = separator
            }
        }
    }
    
    func onFilterClick(sender: UIButton) {
        guard let clickedLabel = sender.titleLabel, let clickedLabelText = clickedLabel.text, let clickedFilter = filters.first(where: { return $0.name == clickedLabelText }) else {
            fatalError("can not identify clicked filter")
        }
        if let delegate = self.delegate, delegate.onFilterSelect(clickedFilter) {
            print("\(clickedFilter.name) was clicked and selected")
        } else {
            print("\(clickedFilter.name) was clicked but not selected")
        }
    }
}
