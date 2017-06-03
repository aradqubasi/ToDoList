//
//  NewCategoryViewDelegate.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 29/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import UIKit
protocol NewCategoryViewDelegate {
    func onCreate(sender : NewCategoryView, name: String, description: String, icon: UIImage)
    func onCancel(sender : NewCategoryView)
}
