//
//  TagConstructor.swift
//  ToDoList
//
//  Created by Admin on 17.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TagConstructor: UIView, UITextFieldDelegate {
    // MARK: - Properties
    
    var newTagEdit: UITextField?
    
    let initialText: String = "Add Tag"
    
    let edgeToEdit: CGFloat = 17
    
    var editWidth: CGFloat = 0
    
    let editToEdge: CGFloat = 17
    
    let cornerRadius: CGFloat = 16
    
    var width: CGFloat {
        get { return edgeToEdit + editWidth + editToEdge }
    }
    
    let topToEdit: CGFloat = 7
    
    var editHeight: CGFloat = 0
    
    let editToBottom: CGFloat = 9
    
    var height: CGFloat {
        get { return topToEdit + editHeight + editToBottom }
    }
    
    let font = ToDoListContext.instance.Font12()
    
    let color = ToDoListContext.instance.tdSilver
    
    var delegate: TagConstructorDelegate?
    
    // MARK: - Initialization
    init() {
        let frame = CGRect.init()
        super.init(frame: frame)
        attachEdit()
        makeShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UITextFieldDelegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newTagEdit?.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        CreateTag(name: textField.text)
    }
    // MARK: - Private Methods
    private func attachEdit() {
        let edit = UITextField.init()
        edit.translatesAutoresizingMaskIntoConstraints = false
        edit.placeholder = initialText
        edit.font = font
        edit.textColor = color
        edit.delegate = self
        edit.returnKeyType = .done
        
        let cltdWidth = ToDoListContext.instance.CalculateSize(for: initialText, at: font)
        let cltdHeight = font.lineHeight
        edit.widthAnchor.constraint(equalToConstant: cltdWidth).isActive = true
        edit.heightAnchor.constraint(equalToConstant: cltdHeight).isActive = true
        
        addSubview(edit)
        newTagEdit = edit
        editWidth = cltdWidth
        editHeight = cltdHeight
        
        edit.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeToEdit).isActive = true
        edit.topAnchor.constraint(equalTo: self.topAnchor, constant: topToEdit).isActive = true
    }
    
    private func makeShape() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        let shapeLayer = CAShapeLayer()
        let shapeRect = CGRect.init(x: 0, y: 0, width: width, height: height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint.init(x: width / 2, y: height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [1,1]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        self.layer.addSublayer(shapeLayer)
        //self.backgroundColor = UIColor.blue
    }
    private func CreateTag(name: String?) {
        if delegate != nil && name != nil {
            let d = delegate!
            d.pushTag(tag: name!)
        }
        newTagEdit?.text = ""
    }
}
