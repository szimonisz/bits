//
//  CreateNewCategoryViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/18/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

class CreateNewCategoryViewController: UIViewController,NSFetchedResultsControllerDelegate,UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.83, green:0.83, blue:0.85, alpha:1.0)

        categoriesFetchedResultsController = HabitService.shared.habitCategories()
        categoriesFetchedResultsController.delegate = self
        textField.delegate = self
    }
    
    private var categoriesFetchedResultsController: NSFetchedResultsController<Category>!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createNewCategoryView: UIView!
    
    @IBAction func pressCreateButton(_ sender: Any) {
        if(textField.text?.isEmpty == false) {
            HabitService.shared.addCategory(title: textField.text!)
        }
    }
}



