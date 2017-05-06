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
    
    // MARK: - Public Properties
    
    var delegate: FiltersStackDelegate?
    
    // MARK: - Geometry
    
    var buttonHeight: CGFloat {
        return 64
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
        
        var prevFilterButton: UIButton?
        for filter in filters {
            
            let filterButton = UIButton.init()
            
            filterButton.setTitle(filter.name, for: .disabled)
            filterButton.setTitle(filter.name, for: .focused)
            filterButton.setTitle(filter.name, for: .highlighted)
            filterButton.setTitle(filter.name, for: .normal)
            filterButton.addTarget(self, action: #selector(onFilterClick(sender:)), for: .touchUpInside)
            
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview(filterButton)
            filterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            filterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            filterButton.heightAnchor.constraint(equalToConstant: self.buttonHeight).isActive = true
            if let prev = prevFilterButton {
                filterButton.topAnchor.constraint(equalTo: prev.bottomAnchor).isActive = true
            } else {
                filterButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            
            filterButtons.append(filterButton)
            prevFilterButton = filterButton
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
