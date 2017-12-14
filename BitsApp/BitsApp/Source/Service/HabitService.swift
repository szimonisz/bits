//
//  HabitService.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/12/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

class HabitService{
    
    // MARK: CoreData Entity Fetching
    func habitCategories() -> NSFetchedResultsController<Category>{
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return createFetchedResultsController(for: fetchRequest)
    }
    func habits(for category: Category) -> NSFetchedResultsController<Habit>{
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@",category)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return createFetchedResultsController(for: fetchRequest)
    }
    
    func highlightImages(for habit: Habit) -> NSFetchedResultsController<HighlightImage>{
        let fetchRequest: NSFetchRequest<HighlightImage> = HighlightImage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "habit == %@",habit)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"data",ascending:true)]
        return createFetchedResultsController(for: fetchRequest)
    }
    
    private func createFetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T>{
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        }
        catch let error {
            fatalError("Could not perform fetch for fetched results controller: \(error)")
        }
        return fetchedResultsController
    }
    
    
    
    // MARK: Adding CoreData Entities
    func addCategory(title: String){
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: persistentContainer.viewContext) as! Category
        category.title = title
        persistentContainer.viewContext.insert(category)
        self.saveContext(error: "Failed to save context after attempting to add category")
    }
    
    func addHabit(task: String, description: String, type: String, for category: Category){
        let habit = NSEntityDescription.insertNewObject(forEntityName: "Habit", into: persistentContainer.viewContext) as! Habit
        habit.title = task
        habit.details = description
        habit.type = type
        habit.completed = false
        habit.creationDate = DateService().determineCreationDate()
        
        
        category.addToHabits(habit)
        self.saveContext(error: "Failed to save context after attempting to add new habit")
    }
    
    func addHighlightImage(data:Data?,for habit: Habit){
        let highlightImage = NSEntityDescription.insertNewObject(forEntityName: "HighlightImage", into: persistentContainer.viewContext) as! HighlightImage
        highlightImage.data = data
        habit.addToHighlightImages(highlightImage)
        self.saveContext(error: "Failed to save context after attempting to add new highlight image")
    }
    
    
    
    // MARK: Deleting CoreData Entities
    func deleteCategory(category: Category){
        if(category.habits != nil){
            for habit in category.habits!{
                HabitService.shared.deleteHabit(habit: habit as! Habit)
            }
        }
        persistentContainer.viewContext.delete(category)
        self.saveContext(error:"Failed to save context after attempting to delete category")
    }
    
    func deleteHabit(habit: Habit){
        if(habit.highlightImages != nil){
            for highlight in habit.highlightImages!{
                HabitService.shared.deleteHighlightImage(highlight: highlight as! HighlightImage)
            }
        }
        persistentContainer.viewContext.delete(habit)
        self.saveContext(error: "Could not save context after attempting to delete habit")
    }
    
    func deleteHighlightImage(highlight: HighlightImage){
        persistentContainer.viewContext.delete(highlight)
        self.saveContext(error: "Could not save context after attempting to delete highlightImage")
    }
    
    
    
    // MARK: Habit Functions
    func setHabitAsCompleted(habit:Habit, at date: Date){
        habit.completed = true
        habit.lastCompleted = date
        habit.streak += 1
        self.saveContext(error: "Failed to set habit to completed state")
    }
    
    func updateHabit(habit:Habit, basedOn date: Date){
        
        if(DateService().isCompletedExpired(for: habit,basedOn:date) == true){
            habit.completed = false
        }
        
        if(DateService().isStreakExpired(for: habit, basedOn: date) == true){
            habit.streak = 0
            habit.completed = false
        }
        self.saveContext(error: "Failed to calculate streak")
    }
    
 
    
    //MARK: View Context Initialization and Saving
    
    func saveContext(error: String){
        let context = self.persistentContainer.viewContext
        do{
            try context.save()
        }
        catch _ {
            fatalError(error)
        }
    }
    
    private init(){
        persistentContainer = NSPersistentContainer(name:"Model")
        persistentContainer.loadPersistentStores(completionHandler:
            { (storeDescription, error) in
                
                let context = self.persistentContainer.viewContext
                context.perform {
                }
                self.saveContext(error:"Failed to save context after loading CoreData")
    
        })
    }
    private let persistentContainer: NSPersistentContainer
    
    static let shared = HabitService()
}
