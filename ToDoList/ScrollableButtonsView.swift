//
//  ScrollableButtonsView.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 15/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ScrollableButtonsView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is SelectableCategory {
            return true
        }
        if view is SimpleTag {
            return true
        }
        if view is TagConstructor {
            return true
        }
        if view is DeletableTag {
            return true
        }
        //print(view)
        return super.touchesShouldCancel(in: view)
    }
}
