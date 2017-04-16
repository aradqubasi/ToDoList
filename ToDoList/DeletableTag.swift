//
//  DeletableTag.swift
//  ToDoList
//
//  Created by Admin on 15.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DeletableTag: UIView {
    //MARK: - Properties
    var tagName: String
    var label: UILabel?
    var button: UIButton?
    
    var edgeToLabel: CGFloat = 12
    var labelWidth: CGFloat = 0
    var labelToButton: CGFloat = 5
    var buttonWidth: CGFloat = 12
    var buttonToEdge:  CGFloat = 10
    var width: CGFloat {
        get { return edgeToLabel + labelWidth + labelToButton + buttonWidth + buttonToEdge }
    }
    var height: CGFloat = 32
    var delegate: DeletableTagDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: - Initialization
    init(tag: String) {
        let frame = CGRect.init(x: 0, y: 0, width: 40, height: 20)
        self.tagName = tag
        super.init(frame: frame)
        //self.backgroundColor = UIColor.blue
        attachTagLabel()
        attachCloseButton()
        makeShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Private Methods
    private func attachTagLabel() {
        let tagLabel = UILabel.init()
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.textColor = ToDoListContext.instance.tdAqua
        tagLabel.text = tagName
        let font = ToDoListContext.instance.Font12()
        tagLabel.font = font
        labelWidth = ToDoListContext.instance.CalculateSize(for: tagName, at: font)
        tagLabel.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
        tagLabel.heightAnchor.constraint(equalToConstant: font.lineHeight).isActive = true
        addSubview(tagLabel)
        tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeToLabel).isActive = true
        tagLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        self.label = tagLabel
    }
    private func attachCloseButton() {
        let closeButton = UIButton.init()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let bundle = Bundle.init(for: type(of: self))
        closeButton.setImage(UIImage.init(named: "closeButton", in: bundle, compatibleWith: self.traitCollection), for: .focused)
        closeButton.setImage(UIImage.init(named: "closeButton", in: bundle, compatibleWith: self.traitCollection), for: .highlighted)
        closeButton.setImage(UIImage.init(named: "closeButton", in: bundle, compatibleWith: self.traitCollection), for: .selected)
        closeButton.setImage(UIImage.init(named: "closeButton", in: bundle, compatibleWith: self.traitCollection), for: .normal)
        closeButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        closeButton.addTarget(self, action: #selector(closeButtonClick(button:)), for: .touchUpInside)
        addSubview(closeButton)
        closeButton.leadingAnchor.constraint(equalTo: (label?.trailingAnchor)!, constant: labelToButton).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }
    private func makeShape() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        let color = ToDoListContext.instance.tdAqua
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        //let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        shapeLayer.bounds = shapeRect
        //shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.position = CGPoint(x: width / 2, y: height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [1,1]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 12).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    func closeButtonClick(button: UIButton) {
        if delegate != nil {
            delegate?.OnTagDelete(of: self)
        }
    }
}
