//
//  Category.swift
//  ToDoList
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
class Category : NSObject, NSCoding {
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let icon = "icon"
        static let color = "color"
    }
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
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Category.Keys.id)
        aCoder.encode(name, forKey: Category.Keys.name)
        aCoder.encode(color, forKey: Category.Keys.color)
        aCoder.encode(icon, forKey: Category.Keys.icon)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Category.Keys.id) as? UUID else {
            fatalError("saved id is not uuid")
        }
        guard let name = aDecoder.decodeObject(forKey: Category.Keys.name) as? String else {
            fatalError("saved name is not a string")
        }
        let icon = aDecoder.decodeObject(forKey: Category.Keys.icon) as? UIImage
        guard let color = aDecoder.decodeObject(forKey: Category.Keys.color) as? UIColor else {
            fatalError("saved color is not a color")
        }
        self.init(name: name, icon: icon, color: color)
        self.id = id
    }
}
