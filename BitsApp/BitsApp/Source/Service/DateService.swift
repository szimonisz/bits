//
//  DateService.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 12/7/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit

class DateService{
    
    func determineCreationDate()->Date{
        return Date()
    }
    
    func getFormattedDateString(from date: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return "\(dateFormatter.string(from:date))"
    }
    
  
    //modular date functionality. I would usually hard code this to use the current date,
    //but in order to test the date properties of my habits I must be able to plug in my own mock dates if necessary
    
    func isCompletedExpired(for habit: Habit, basedOn date: Date)->Bool{
        if(habit.lastCompleted == nil){
            return true
        }
        
        let daysSinceLastCompletion = Calendar.current.dateComponents([.day], from: habit.lastCompleted!,to:date).day ?? 0

        if(habit.type! == "daily" && daysSinceLastCompletion >= 1){
            return true
        }
        
        else if(habit.type! == "weekly" && daysSinceLastCompletion >= 7){
            return true
        }
        else{
            return false
        }
        
    }
    func isStreakExpired(for habit: Habit, basedOn date: Date)-> Bool{
        if(habit.lastCompleted == nil){
            return false
        }
        let daysSinceLastCompletion = Calendar.current.dateComponents([.day], from: habit.lastCompleted!,to:date).day ?? 0
        
        //if habit was last completed yesterday (daily habit)
        if(habit.type! == "daily" && habit.streak > 0 && daysSinceLastCompletion <= 1){
            return false
        }
        //if habit was last completed within the last 7 days (weekly habit)
        else if(habit.type! == "weekly" && habit.streak > 0 && daysSinceLastCompletion <= 7){
            return false
        }
        else{
            return true
        }
        
        
    }
}
