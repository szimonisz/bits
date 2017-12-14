//
//  HabitCell.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/19/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

protocol HabitCellDelegate{
    func didTapCompletedButton(habit: Habit)
}
class HabitCell: UITableViewCell{
    @IBOutlet weak var habitCellTitle: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    var habitItem: Habit!
 //   var delegate: HabitCellDelegate?

    
    func setHabit(habit: Habit){
        //ensure that the habit we are populating our table with is up to date
        //this will be called everytime reloadData() is called in the habitTableViewController
        
        let currentDate = Date()
        
        HabitService.shared.updateHabit(habit:habit, basedOn: currentDate)
        
        habitItem = habit
        habitCellTitle.text = habit.title
        completedButton.imageView?.contentMode = .scaleAspectFit
      
        //ensure watermelon completion button is in proper state
        if(habitItem.completed == true){
            completedButton.isEnabled = false
        }
        else{
            completedButton.isEnabled = true
        }
        
    }
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        HabitService.shared.setHabitAsCompleted(habit: habitItem, at: Date())
        completedButton.isEnabled = false
      //  delegate?.didTapCompletedButton(habit: habitItem)
    }
}
