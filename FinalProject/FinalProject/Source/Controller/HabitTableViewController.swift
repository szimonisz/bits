//
//  HabitTableViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/12/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

class HabitListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitsFetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath) as! HabitCell
        let habit = habitsFetchedResultsController.object(at: indexPath)
        cell.setHabit(habit: habit)
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(hue: 0.3056, saturation: 0.38, brightness: 1, alpha: 1.0)
        }
        else{
            cell.backgroundColor = UIColor(red:0.15, green:0.74, blue:0.48, alpha:1.0)
        }
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let habit = habitsFetchedResultsController.object(at: indexPath)
            HabitService.shared.deleteHabit(habit: habit)
            habitsFetchedResultsController = HabitService.shared.habits(for: category)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitsFetchedResultsController = HabitService.shared.habits(for: category)
        habitsFetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        habitsFetchedResultsController = HabitService.shared.habits(for: category)
        habitTableView.backgroundColor = UIColor(red:0.83, green:0.83, blue:0.85, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        habitTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateHabitSegue" {
            let createHabitView = segue.destination as! CreateNewHabitViewController
            createHabitView.category = category
        }
        else if segue.identifier == "DetailHabitViewSegue"{
            let detailHabitView = segue.destination as! DetailHabitViewController
            let selectedIndexPath = habitTableView.indexPathForSelectedRow!
            detailHabitView.habit = habitsFetchedResultsController.object(at: selectedIndexPath)
            detailHabitView.title = "\(detailHabitView.habit.title!) Details"
            
            habitTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    var category: Category! = nil
    
    private var habitsFetchedResultsController: NSFetchedResultsController<Habit>!
    
    @IBOutlet private weak var habitTableView: UITableView!
}

//extension HabitListViewController: HabitCellDelegate{
//    func didTapCompletedButton(habit: Habit) {
//        habit.completed = true
//        let indexPath = habitsFetchedResultsController.indexPath(forObject: habit)
//        let goof = habitsFetchedResultsController.object(at: indexPath!)
//        goof.completed = true
//        HabitService.shared.setHabitAsCompleted(habit:habit)
//    }
//}

