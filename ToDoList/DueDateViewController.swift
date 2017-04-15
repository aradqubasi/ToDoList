//
//  DueDateViewController.swift
//  ToDoList
//
//  Created by Admin on 03.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DueDateViewController: UIViewController {
    //MARK: - Properties
    var isValid: Bool = false
    var dueDate: Date? {
        get {
            let pickedDate = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
            let pickedTime = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
            var dueDateComponents = DateComponents()
            dueDateComponents.year = pickedDate.year
            dueDateComponents.month = pickedDate.month
            dueDateComponents.day = pickedDate.day
            dueDateComponents.hour = pickedTime.hour
            dueDateComponents.minute = pickedTime.minute
            return Calendar.current.date(from: dueDateComponents)
        }
    }
    
    var frequency: Task.Frequency? {
        get {
            var temp: Task.Frequency?
            switch frequencySegmentedControl.titleForSegment(at: frequencySegmentedControl.selectedSegmentIndex) ?? "" {
            case "Weekly":
                temp = .weekly
            case "Daily":
                temp = .daily
            case "Once":
                temp = .once
            default:
                temp = nil
            }
            return temp
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var frequencySegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Actions
    @IBAction func backButtonClick(_ sender: Any) {
        isValid = false
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonClick(_ sender: Any) {
        isValid = true
    }

}
