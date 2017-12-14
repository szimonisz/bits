//
//  CreateHabitViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/19/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

class CreateNewHabitViewController: UIViewController,UITextFieldDelegate,NSFetchedResultsControllerDelegate{
    
    let habitTypes = ["Daily","Weekly"]
    

    
    func haveAllHabitInfo() -> Bool{
        if taskTextField.text?.isEmpty == false {
            taskName = taskTextField.text
        }
        if descriptionTextField.text?.isEmpty == false{
            descriptionText = descriptionTextField.text
        }
        if taskName != nil && descriptionText != nil && type != nil {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.83, green:0.83, blue:0.85, alpha:1.0)
        

    
        taskTextField.delegate = self
        descriptionTextField.delegate = self
        
        taskName = nil
        descriptionText = nil
        type = nil
        
        let doneToolbar = UIToolbar()
        doneToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed))
        doneToolbar.setItems([flexibleSpace,doneBarButton], animated: false)
        
        
        taskTextField.inputAccessoryView = doneToolbar
        descriptionTextField.inputAccessoryView = doneToolbar
               
    }
    
    @objc func donePressed(){
        view.endEditing(true)
    }

    private var taskName: String?
    private var descriptionText: String?
    private var type: String?
    
    var category: Category! = nil
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    
    @IBAction func dailyPressed(_ sender: Any) {
        type = "daily"
        weeklyButton.backgroundColor = UIColor.clear
        dailyButton.backgroundColor = UIColor.white
    }
    @IBAction func weeklyPressed(_ sender: Any) {
        type = "weekly"
        dailyButton.backgroundColor = UIColor.clear
        weeklyButton.backgroundColor = UIColor.white
    }
    @IBAction func createPressed(_ sender: Any) {
        if(haveAllHabitInfo() == true){
            HabitService.shared.addHabit(task: taskName!, description: descriptionText!, type: type!, for: category)
        }
        else{
            let alert = UIAlertController(title: "Not yet!", message: "You need to finish creating your habit.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
