//
//  CategoryListViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/12/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData


class CategoryListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoriesFetchedResultsController.object(at: indexPath)
        categoryCell.textLabel?.text = category.title
        if(indexPath.row % 2 == 0){
           categoryCell.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.65, alpha:1.0)
        }
        else{
            categoryCell.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.37, alpha:1.0)
        }
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = categoriesFetchedResultsController.object(at: indexPath)
            HabitService.shared.deleteCategory(category: category)
            categoriesFetchedResultsController = HabitService.shared.habitCategories()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HabitViewSegue" {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
            let habitListTable = segue.destination as! HabitListViewController
            
            let selectedIndexPath = categoryListTable.indexPathForSelectedRow!
            habitListTable.category = categoriesFetchedResultsController.object(at: selectedIndexPath)
            habitListTable.title = "\(habitListTable.category.title!) Habits"
            
            categoryListTable.deselectRow(at: selectedIndexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesFetchedResultsController = HabitService.shared.habitCategories()
        categoriesFetchedResultsController.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        categoriesFetchedResultsController = HabitService.shared.habitCategories()

        categoryListTable.backgroundColor = UIColor(red:0.83, green:0.83, blue:0.85, alpha:1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red:1.00, green:0.49, blue:0.54, alpha:1.0)
        categoryListTable.reloadData()

    }
    
    private var categoriesFetchedResultsController: NSFetchedResultsController<Category>!
    
    @IBOutlet private weak var categoryListTable: UITableView!
    
    
    
    
}
