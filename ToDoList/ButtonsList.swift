//
//  ButtonsList.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 05/06/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ButtonsList: UIView {
    // MARK: - Private Properties
    
    private var _attributes: [String: Any] {
        get {
            let name = "Avenir-Light"
            let size: CGFloat = 16
            guard let font = UIFont.init(name: name, size: size) else {
                fatalError("font not found \(name) \(size)")
            }
            let color = ToDoListContext.instance.tdDarkGrey
            return [NSFontAttributeName: font, NSForegroundColorAttributeName: color]
        }
    }
    
    private var _spacing: CGFloat {
        get {
            return 16
        }
    }
    
    private var _buttonHeight: CGFloat {
        get {
            return 64
        }
    }
    
    private var _cornerRadius: CGFloat {
        get {
            return 16
        }
    }
    
    private var _topLevel: CGFloat!
    
    private var _offset: CGFloat!
    
    // MARK: - Initialization
    
    init(frame: CGRect, options: [String]) {
        super.init(frame: frame)
        //self.translatesAutoresizingMaskIntoConstraints = false
        var topLevel: CGFloat = frame.size.height - _spacing
        for index in 0..<options.count {
            let option = options[options.count - 1 - index]
            topLevel -= _buttonHeight + _spacing
            let button = UIButton(frame: CGRect(x: _spacing, y: topLevel, width: self.frame.size.width - (_spacing * 2), height: _buttonHeight))
            button.setAttributedTitle(NSAttributedString.init(string: option, attributes: _attributes), for: .normal)
            button.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = _cornerRadius
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: _spacing, left: _spacing, bottom: _spacing, right: _spacing)
            self.addSubview(button)
        }
        _topLevel = topLevel
        _offset = frame.size.height - _topLevel
        for subview in subviews {
            subview.frame.origin.y += _offset
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    
    func onClick(sender: UIButton) {
        Hide()
    }
    
    // MARK: - Animation
    
    func Show() {
        var delay: CGFloat = 0
        for index in 0..<subviews.count {
            let subview = subviews[subviews.count - 1 - index]
            UIView.animate(withDuration: 0.225, delay: TimeInterval(delay), options: .curveEaseIn, animations: {
                subview.frame.origin.y -= self._offset
            }, completion: nil)
            delay += 0.1
        }
        /*
        for subview in subviews {
            UIView.animate(withDuration: 0.225, delay: TimeInterval(delay), options: .curveEaseIn, animations: {
                subview.frame.origin.y -= self._offset
            }, completion: nil)
            delay += 0.1
        }
         */
    }
    
    func Hide() {
        var delay: CGFloat = 0
        for index in 0..<subviews.count {
            let subview = subviews[subviews.count - 1 - index]
            UIView.animate(withDuration: 0.225, delay: TimeInterval(delay), options: .curveEaseIn, animations: {
                subview.frame.origin.y += self._offset
            }, completion: nil)
            delay += 0.1
        }
    }
}
