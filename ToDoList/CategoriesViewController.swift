//
//  CategoriesViewController.swift
//  ToDoList
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var showProfile: UIButton!
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var addCategory: UIButton!
    @IBOutlet weak var showList: UIButton!
    @IBOutlet weak var showGrid: UIButton!
    @IBOutlet weak var categoriesGrid: UICollectionView!
    
    var categories = ToDoListContext.instance.GetCategories()
    var filterOptions = [String]()
    var blurView : UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //loadSampleCategories()
        loadSampleFilterOptions()
        categoriesGrid.dataSource = self
        filterPicker.delegate = self
        filterPicker.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let identifier = "CategoryGridCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryViewCell else {
            fatalError("Dequeued cell is not an instance of CategoryGrifCell")
        }
        let category = categories[indexPath.row]
        cell.icon.image = category.icon
        cell.name.text = category.name
        cell.taskCount.text = "0 Tasks"
        return cell
    }
    
    //MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterOptions.count
    }
    //MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterOptions[row]
    }
    //MARK: UIPopoverPresentationControllerDelegate methods
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        //self.view.backgroundColor = UIColor.blue
        blurView = UIView(frame: self.view.frame)
        blurView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //blurView?.backgroundColor.alp
        self.view.addSubview(blurView!)
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //self.view.backgroundColor = UIColor.white
        blurView!.removeFromSuperview()
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategoryPopOver" {
            let vc = segue.destination as? CategoryViewController
            let pop = vc?.popoverPresentationController
            vc?.preferredContentSize = CGSize(width: self.view.frame.width, height: 300)/*CGSize(width: self.preferredContentSize.width, height: self.preferredContentSize.height)*/
            pop?.popoverLayoutMargins.top = 5
            pop?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            pop?.barButtonItem = nil
            pop?.sourceView = self.view
            pop?.sourceRect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
            pop?.delegate = self
        }
    }

    //MARK: Actions
    
    @IBAction func showProfileClick(_ sender: UIButton) {
    }
    @IBAction func addCategoryClick(_ sender: UIButton) {
    }
    @IBAction func showListClick(_ sender: UIButton) {
    }
    @IBAction func showGridClick(_ sender: UIButton) {
    }
    
    //MARK: Private methods
    func loadSampleFilterOptions() {
        filterOptions = ["option1", "option2", "option3"]
    }
}
