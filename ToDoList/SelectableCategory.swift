//
//  SelectableCategory.swift
//  ToDoList
//
//  Created by Admin on 18.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SelectableCategory: UIControl {
    //MARK : - Properties
    var model: Category
    var isChecked: Bool
    var point: UIView?
    var label: UILabel?
    var delegate: SelectableCategoryDelegate?
    //MARK : - Geometric Params
    
    let pointRadius: CGFloat = 4
    let edgeToPoint: CGFloat = 0
    var pointWidth: CGFloat = 0
    let pointToLabel: CGFloat = 8
    let edgeToLabel: CGFloat = 8
    var labelWidth: CGFloat = 0
    let labelToEdge: CGFloat = 8
    
    let topToPoint: CGFloat = 13
    var pointHeight: CGFloat = 0
    
    let topToLabel: CGFloat = 8
    var labelHeight: CGFloat = 0
    
    var width: CGFloat {
        get {
            if isSelected {
                return edgeToLabel + labelWidth + labelToEdge
            } else {
                return edgeToPoint + pointWidth + pointToLabel + labelWidth + labelToEdge
            }
        }
    }
    var height: CGFloat {
        get {
            return 32
        }
    }
    let cornerRadius: CGFloat = 12
    
    let font = ToDoListContext.instance.SelectableCategoryFont()
    
    //MARK : - Initialization
    init(of: Category, state: Bool) {
        let frame = CGRect.init(x: 0, y: 0, width: 40, height: 32)
        model = of
        isChecked = state
        super.init(frame: frame)
        attachPoint()
        attachLabel()
        makeShape()
        paintByState()
        self.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK : - Private Properties
    private func attachPoint() {
        let point = UIView.init()
        point.translatesAutoresizingMaskIntoConstraints = false
        point.layer.cornerRadius = pointRadius
        pointWidth = pointRadius * 2
        point.widthAnchor.constraint(equalToConstant: pointWidth).isActive = true
        pointHeight = pointRadius * 2
        point.heightAnchor.constraint(equalToConstant: pointHeight).isActive = true
        point.backgroundColor = model.color
        
        addSubview(point)
        
        point.topAnchor.constraint(equalTo: self.topAnchor, constant: topToPoint).isActive = true
        point.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeToPoint).isActive = true
        
        self.point = point
    }
    private func attachLabel() {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = model.name
        labelWidth = ToDoListContext.instance.CalculateSize(for: model.name, at: font)
        label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        labelHeight = font.lineHeight
        label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        addSubview(label)
        
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: topToLabel).isActive = true
        label.leadingAnchor.constraint(equalTo: point!.leadingAnchor, constant: pointToLabel).isActive = true
        
        self.label = label
    }
    private func makeShape() {
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    private func paintByState() {
        var background = UIColor.clear
        var fontColor = UIColor.black
        if isChecked {
            background = model.color
            fontColor = UIColor.white
        }
        self.backgroundColor = background
        label?.textColor = fontColor
    }
    func onClick(sender: SelectableCategory) {
        isChecked = !isChecked
        paintByState()
        if let d = delegate {
            d.onCategoryClick(sender: self)
        }
    }
    func setState(to: Bool) {
        isChecked = to
        paintByState()
    }
}
