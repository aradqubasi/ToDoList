//
//  SimpleTag.swift
//  ToDoList
//
//  Created by Admin on 23.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SimpleTag: UIView {
    // MARK: - Geometry
    let egdeToLabel: CGFloat = 20
    var labelWidth: CGFloat = 0
    let labelToEdge: CGFloat = 20
    
    let topToLabel: CGFloat = 8
    let labelHeigt: CGFloat = 16
    let labelToBottom: CGFloat = 8
    
    let borderRadius: CGFloat = 12
    let borderWidth: CGFloat = 0.5
    
    var width: CGFloat {
        get {
            return egdeToLabel + labelWidth + labelToEdge
        }
    }
    var height: CGFloat {
        get {
            return topToLabel + labelHeigt + labelToBottom
        }
    }
    
    // MARK: - Properties
    var caption: String
    var font: UIFont = ToDoListContext.instance.FontForSimpleTag
    
    // MARK: - Subviews
    weak var label: UILabel?
    
    // MARK: - Initialization
    init(_ tagName: String) {
        caption = tagName
        super.init(frame: CGRect.zero)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func attachLabel() {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = caption
        label.font = font
        labelWidth = ToDoListContext.instance.CalculateSize(for: caption, at: font)
        label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        label.heightAnchor.constraint(equalToConstant: labelHeigt).isActive = true
        
        self.addSubview(label)
        self.label = label
        
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: egdeToLabel).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: topToLabel).isActive = true
    }
    
    private func makeShape() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = ToDoListContext.instance.tdSilver.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = borderRadius
        layer.backgroundColor = ToDoListContext.instance.tdPaleGrey.cgColor
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
