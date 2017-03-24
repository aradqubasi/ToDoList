//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Admin on 22.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    //MARK: constants
    public static let identifier = "TaskTableViewCell"
    //MARK: Properties
    @IBOutlet weak var isDoneSwitch: UISwitch!
    @IBOutlet weak var taskCaptionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
