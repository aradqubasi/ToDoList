//
//  TagConstructorDelegate.swift
//  ToDoList
//
//  Created by Admin on 17.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
protocol TagConstructorDelegate {
    func pushTag(tag: DeletableTag, creator: TagConstructor)
}
