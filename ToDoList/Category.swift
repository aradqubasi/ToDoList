//
//  Category.swift
//  ToDoList
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
class Category {
    var id: UUID
    var name: String
    var icon: UIImage?
    var color: UIColor
    init?(name: String, icon: UIImage?, color: UIColor) {
        guard !name.isEmpty else {
            fatalError("Could instantiate category with empty name")
        }
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.color = color
    }
}
