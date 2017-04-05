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
    var dueDate: Date? = Date.init()
    var isReoccuring: Bool? = false
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
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
    
    @IBAction func neverButtonClick(_ sender: Any) {
        setDate(reoccuring: false)
    }
    @IBAction func repeatButtonClick(_ sender: Any) {
        setDate(reoccuring: true)
    }
    //MARK: - Private Methods
    private func setDate(reoccuring: Bool) {
        let pickedDate = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        let pickedTime = Calendar.current.dateComponents([.hour, .minute], from: timePicker.date)
        var dueDateComponents = DateComponents()
        dueDateComponents.year = pickedDate.year
        dueDateComponents.month = pickedDate.month
        dueDateComponents.day = pickedDate.day
        dueDateComponents.hour = pickedTime.hour
        dueDateComponents.minute = pickedTime.minute
        dueDate = Calendar.current.date(from: dueDateComponents)
        print(datePicker.date)
        print(timePicker.date)
        print(dueDate!)
        isReoccuring = reoccuring
    }
}
