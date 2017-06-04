//
//  CategoriesViewController.swift
//  ToDoList
//
//  Created by Admin on 28.03.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverPresentationControllerDelegate, UICollectionViewDelegate, NewCategoryViewDelegate {

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
    private var _newCategoryView: NewCategoryView?
    var newCategoryView: NewCategoryView {
        get {
            if _newCategoryView == nil {
                //_newCategoryView = shapeAsNewCategory()
                _newCategoryView = NewCategoryView()
            }
            return _newCategoryView!
        }
    }
    private var _newBlurView : UIView?
    var newBlurView: UIView {
        get {
            if _newBlurView == nil {
                _newBlurView = shapeAsNewCategoryBlur()
            }
            return _newBlurView!
        }
    }
    private var _realBlurView : BlurView?
    var realBlurView: BlurView {
        get {
            if _realBlurView == nil {
                _realBlurView = BlurView(frame: ToDoListContext.instance.rootView.frame)
            }
            return _realBlurView!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //loadSampleCategories()
        loadSampleFilterOptions()
        categoriesGrid.dataSource = self
        categoriesGrid.delegate = self
        filterPicker.delegate = self
        filterPicker.dataSource = self
        //self.view.addSubview(newBlurView)
        //self.view.addSubview(newCategoryView)
        let rootView = ToDoListContext.instance.rootView
        rootView.addSubview(newBlurView)
        rootView.addSubview(newCategoryView)
        rootView.addSubview(realBlurView)
        newCategoryView.delegate = self
        //for view in rootView.subviews {
        //    print(view)
        //}
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
        let count = ToDoListContext.instance.GetTasks().filter({(task: Task) in
            if task.categories.contains(where: { (_category: Category) in
                return _category.id == category.id
            }) {
                return true
            }
            else {
                return false
            }
        }).count
        cell.taskCount.text = "\(count) Tasks"
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
        //let gradientLayer = CAGradientLayer()
        //gradientLayer.colors = [UIColor.white, I]
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
        else if segue.identifier == ToDoListContext.instance.segueId_categoriesToTasks {
            //print("categories preparing for tasks")
            //print(sender)
            if let tasks = segue.destination as? TaskListViewController/*, let category = sender as? Category*/, let selection = categoriesGrid.indexPathsForSelectedItems?[0] {
                //tasks.filter = TasksFilterCategory(category: categories[selection.row])
                ToDoListContext.instance.currentFilter = TasksFilterCategory(category: categories[selection.row])
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func showProfileClick(_ sender: UIButton) {
    }
    @IBAction func addCategoryClick(_ sender: UIButton) {
    }
    @IBAction func showListClick(_ sender: UIButton) {
        //presentBlurView()
        presentNewCategory()
    }
    @IBAction func showGridClick(_ sender: UIButton) {
        realBlurView.Show()
    }
    func onCloseNewCategoryClick(_ sender: UIButton) {
        hideNewCategory()
    }
    //MARK: - Private methods
    func loadSampleFilterOptions() {
        filterOptions = ["option1", "option2", "option3"]
    }
    
    // MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("selected category N\(indexPath)")
        self.performSegue(withIdentifier: ToDoListContext.instance.segueId_categoriesToTasks, sender: categories[indexPath.row])
    }
    
    // MARK: - NewCategoryViewDelegate
    
    func onCreate(sender : NewCategoryView, name: String, description: String, icon: UIImage) {
        hideNewCategory();
    }
    func onCancel(sender : NewCategoryView) {
        hideNewCategory();
    }
    
    // MARK: - Animated
    
    private func shapeAsNewCategoryBlur() -> UIView {
        let fullScreen = CGRect(x: 0, y: -736, width: 414, height: 736)
        let view = UIView(frame: fullScreen)
        let gLayer = CAGradientLayer()
        gLayer.frame = view.bounds
        gLayer.opacity = 0.83
        gLayer.colors = [ToDoListContext.instance.tdGradientBlue.cgColor, ToDoListContext.instance.tdGradientGreen.cgColor]
        view.layer.insertSublayer(gLayer, at: 0)
        return view
    }
    
    func presentNewCategory() {
        self.newBlurView.frame.origin.y = 0
        self.newBlurView.alpha = 1
        self.newCategoryView.Show()
    }
    
    
    func hideNewCategory() {
        self.newCategoryView.Hide()
        UIView.animate(withDuration: 0.225, delay: 0, options: [.curveEaseOut], animations: {
            //self.newCategoryView.frame.origin.y = -279
            self.newBlurView.alpha = 0
        }, completion: { (isCompleted: Bool) in
            self.newBlurView.frame.origin.y = -736
        })
    }
}
