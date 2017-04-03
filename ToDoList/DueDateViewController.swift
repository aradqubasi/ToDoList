//
//  DueDateViewController.swift
//  ToDoList
//
//  Created by Admin on 03.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class DueDateViewController: UIViewController {

    var dueDate: Date? = Date.init()
    
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
    /*
    @IBAction func neverButtonClick(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        let destanation = navigationController?.topViewController
        if  destanation is TaskViewController, let taskVC = destanation as? TaskViewController {
            taskVC.taskDueDate = Date.init()
        }
        
        if destanation is DueDateViewController {
            print("1")
        }
        if destanation is TaskViewController {
            print("2")
        }
 
    }*/
    //MARK: - Private Methods
}
