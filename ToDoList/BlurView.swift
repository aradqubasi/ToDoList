//
//  BlurView.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 03/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class BlurView: UIVisualEffectView {
    // MARK: - Initialization
    init(frame: CGRect) {
        var viewFrame = frame
        let blur = UIBlurEffect(style: .dark)
        viewFrame.origin = CGPoint(x: 0, y: -frame.height)
        //viewFrame.origin = CGPoint(x: 0, y: 0)
        super.init(effect: blur)
        self.frame = viewFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Animation
    
    func Show() {
        self.frame.origin.y = 0
    }
    
    func Hide() {
        self.frame.origin.y = self.frame.size.height
    }
}
