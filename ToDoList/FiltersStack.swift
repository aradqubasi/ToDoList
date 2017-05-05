//
//  FiltersStack.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class FiltersStack: UIStackView {
    // MARK: - Properties
    var filters: [TasksFilter]
    var filterButtons: [UIButton] = []
    // MARK: - Initialization
    init(with: [TasksFilter]) {
        filters = with
        super.init(frame: .zero)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    private func CreateButtons() {
        for filter in filters {
            let filterButton = UIButton.init()
            filterButton.setTitle(filter.name, for: .disabled)
            filterButton.setTitle(filter.name, for: .focused)
            filterButton.setTitle(filter.name, for: .highlighted)
            filterButton.setTitle(filter.name, for: .normal)
            filterButton.addTarget(self, action: #selector(onFilterClick(sender:)), for: .touchUpInside)
        }
    }
    func onFilterClick(sender: UIButton) {
        
    }
}
