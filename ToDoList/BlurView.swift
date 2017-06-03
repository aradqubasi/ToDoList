//
//  BlurView.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 03/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class BlurView: UIImageView {
    // MARK: - Initialization
    override init(frame: CGRect) {
        var viewFrame = frame
        viewFrame.origin = CGPoint.zero
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
