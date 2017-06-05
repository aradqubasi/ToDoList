//
//  ButtonsListDelegate.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
protocol ButtonsListDelegate {
    func onClick(sender: ButtonsList, option: String)
}
