//
//  NewCategoryView.swift
//  ToDoList
//
//  Created by Oleg Sokolansky on 29/05/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class NewCategoryView: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    // MARK: - Properties
    
    var delegate: NewCategoryViewDelegate?
    
    // MARK: - Subviews
    
    var createButton: UIButton
    
    var closeButton: UIButton
    
    var nameEdit: UITextField
    
    var descriptionEdit: UITextView
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        let newCategorySuperFrame = CGRect(x: 16, y: -279, width: 382, height: 279)
        super.init(frame: newCategorySuperFrame)
        //let view = UIView(frame: newCategorySuperFrame)
        
        let newCategoryFrame = CGRect(x: 0, y: 39, width: newCategorySuperFrame.width, height: 240)
        let newCategoryView = UIView(frame: newCategoryFrame)
        newCategoryView.layer.cornerRadius = 9
        newCategoryView.backgroundColor = UIColor.white
        newCategoryView.layer.opacity = 1
        self.addSubview(newCategoryView)
        
        let closeButton = UIButton(frame: CGRect(x: 349, y: 0, width: 21, height: 21))
        closeButton.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        closeButton.addTarget(self, action: #selector(onCloseClick(_:)), for: .touchUpInside)
        self.addSubview(closeButton)
        self.closeButton = closeButton
        
        let nameEdit = UITextField(frame: CGRect(x: 16, y: 55, width: 330, height: 29))
        nameEdit.font = UIFont(name: "Avenir-Light", size: 21)
        nameEdit.textColor = UIColor(red: 69.0 / 255.0, green: 75.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
        nameEdit.placeholder = "Category Name"
        nameEdit.delegate = self
        nameEdit.returnKeyType = .done
        self.addSubview(nameEdit)
        self.nameEdit = nameEdit
        
        let nameToDescriptionSeparator = UIView(frame: CGRect(x: 0, y: 103, width: newCategorySuperFrame.width, height: 1))
        nameToDescriptionSeparator.backgroundColor = UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1)
        self.addSubview(nameToDescriptionSeparator)
        
        let descriptionEdit = UITextView(frame: CGRect(x: 16, y: 120, width: newCategoryFrame.width - 32, height: 111))
        descriptionEdit.font = UIFont(name: "Avenir-Book", size: 14)
        descriptionEdit.textColor = UIColor(red: 197.0 / 255.0, green: 201.0 / 255.0, blue: 201.0 / 255.0, alpha: 1)
        descriptionEdit.text = "Description"
        descriptionEdit.returnKeyType = .done
        descriptionEdit.delegate = self
        self.addSubview(descriptionEdit)
        self.descriptionEdit = descriptionEdit
        
        let descriptionToFooterSeparator = UIView(frame: CGRect(x: 0, y: 231, width: newCategorySuperFrame.width, height: 1))
        descriptionToFooterSeparator.backgroundColor = UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1)
        self.addSubview(descriptionToFooterSeparator)
        
        let createButton = UIButton(frame: CGRect(x: 315, y: 243, width: 54, height: 25))
        let createTitle = NSMutableAttributedString.init(string: "Create", attributes: ToDoListContext.instance.CreateNewCategoryAttributes)
        createButton.setAttributedTitle(createTitle, for: .normal)
        createButton.addTarget(self, action: #selector(onCreateClick(_:)), for: .touchUpInside)
        createButton.isEnabled = false
        self.addSubview(createButton)
        self.createButton = createButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        syncViewWithModel()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === taskNameEdit {
            quickTaskName = textField.text
        } else if textField === descriptionEdit {
            taskDescription = textField.text
        }
        syncViewWithModel()
    }
    
    // MARK: - Private Methods
    
    func onCloseClick(_ sender: UIButton) {
        
    }
    
    func onCreateClick(_ sender: UIButton) {
        
    }
    
    private func syncViewWithModel() {
        
    }
}
