//
//  TasksFiltersViewController.swift
//  ToDoList
//
//  Created by Admin on 31.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TasksFiltersViewController: UIViewController, FiltersStackDelegate {
    // MARK: - Outlets
    @IBOutlet weak var filtersStack: FiltersStack!
    
    // MARK: - Events
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersStack.delegate = self
        filtersStack.syncView()
        self.preferredContentSize = CGSize(width: 300, height: filtersStack.preferredHeight)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FiltersStackDelegate Methods
    var filters: [TasksFilter] {
        return ToDoListContext.instance.filters
    }
    var currentFilter: TasksFilter {
        get {
            return ToDoListContext.instance.currentFilter
        }
    }
    func onFilterSelect(_ filter: TasksFilter) -> Bool {
        ToDoListContext.instance.currentFilter = filter
        self.performSegue(withIdentifier: ToDoListContext.instance.segueId_taskFiltersToTaskList, sender: self)
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
