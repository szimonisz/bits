//
//  FinalProjectTests.swift
//  FinalProjectTests
//
//  Created by Kelemen Szimonisz on 11/12/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import XCTest
@testable import BitsApp

class FinalProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

    func createTestCategory(){
         HabitService.shared.addCategory(title: "TestCategory")
    }
    func deleteTestCategory(){
        HabitService.shared.deleteCategory(category: (HabitService.shared.habitCategories().fetchedObjects?.last!)!)
    }
    func createTestHabit(type: String){
        if(type == "daily"){
            HabitService.shared.addHabit(task: "Daily Test Habit", description: "For Testing. Delete after testing.", type: "daily", for: (HabitService.shared.habitCategories().fetchedObjects?.last!)!)
        }
        else{
            HabitService.shared.addHabit(task: "Weekly Test Habit", description: "For Testing. Delete after testing.", type: "weekly", for: (HabitService.shared.habitCategories().fetchedObjects?.last!)!)
        }
    }
   
    func testWeeklyHabitStreak(){
        createTestCategory()
        createTestHabit(type: "weekly")
        
        let testCategory = HabitService.shared.habitCategories().fetchedObjects?.last
        let testHabit = HabitService.shared.habits(for: testCategory!).fetchedObjects?.last
        
        let weeks = 15
        
        //first completion will be set at the current date
        HabitService.shared.setHabitAsCompleted(habit: testHabit!,at: Date())
        
        
        //lets test a 15 week completion streak of a habit (streak should end up being 15+1)
        for i in 1 ..< weeks{
            
            let iWeeksAfterLastCompletion = Calendar.current.date(byAdding: .day, value: 7, to: (testHabit!.lastCompleted!))
            
            HabitService.shared.setHabitAsCompleted(habit: testHabit!,at: iWeeksAfterLastCompletion!)
            XCTAssertTrue(i + 1 == testHabit!.streak, "The user completed a habit for 'i' weeks, and the streak value did not reflect 'i'")
            //this is i+1 because we started the streak at week 0 before the for loop
        }
        
        //Break the streak!
        
        let weekAndOneDayAfterLastCompletion = Calendar.current.date(byAdding: .day, value: 7 + 1, to: (testHabit!.lastCompleted!))
        
        HabitService.shared.updateHabit(habit: testHabit!, basedOn: weekAndOneDayAfterLastCompletion!)
        
        XCTAssertTrue(0 == testHabit!.streak, "The user failed to complete a weekly habit, yet the streak was not reset to zero")
        
        deleteTestCategory()

    }
    
    func testDailyHabitStreak(){
        createTestCategory()
        createTestHabit(type: "daily")
        
        let testCategory = HabitService.shared.habitCategories().fetchedObjects?.last
        let testHabit = HabitService.shared.habits(for: testCategory!).fetchedObjects?.last
        
        let days = 15
        
        //first completion will be set at the current date
        HabitService.shared.setHabitAsCompleted(habit: testHabit!,at: Date())
        
        
        //lets test a 15 week completion streak of a habit (streak should end up being 15)
        for i in 1 ..< days{
            
            let iDaysAfterLastCompletion = Calendar.current.date(byAdding: .day, value: 1, to: (testHabit!.lastCompleted!))
            
            HabitService.shared.setHabitAsCompleted(habit: testHabit!,at: iDaysAfterLastCompletion!)
            XCTAssertTrue(i + 1 == testHabit!.streak, "The user completed a habit for 'i' weeks, and the streak value did not reflect 'i'")
        }
        //Break the streak!
        
        let twoDaysAfterLastCompletion = Calendar.current.date(byAdding: .day, value: 1 + 1, to: (testHabit!.lastCompleted!))
        
        HabitService.shared.updateHabit(habit: testHabit!, basedOn: twoDaysAfterLastCompletion!)
        
        XCTAssertTrue(0 == testHabit!.streak, "The user failed to complete a weekly habit, yet the streak was not reset to zero")
        
        deleteTestCategory()
    }

    
    
    func testCompletionStatusDaily(){
        //in this test, I am looking at the first category's first habit (if they exist)
        //but this should be effective for all categories and habits
        
        createTestCategory()
        createTestHabit(type: "daily")
        
        let testCategory = HabitService.shared.habitCategories().fetchedObjects?.last
        let testHabit = HabitService.shared.habits(for: testCategory!).fetchedObjects?.last
        
        //pretend we completed testHabit today
        
        HabitService.shared.setHabitAsCompleted(habit: testHabit!,at:Date())
        
        let oneDayAfterCompletion = Calendar.current.date(byAdding: .day, value: 1, to: (testHabit!.lastCompleted!))
        
        HabitService.shared.updateHabit(habit: testHabit!, basedOn: oneDayAfterCompletion!)
        
        XCTAssertFalse(testHabit!.completed, "A calendar day passed after the last completion, yet the habit is still labeled as completed")

        deleteTestCategory()
    }
    
    
    func testCompletionStatusWeekly(){
        //in this test, I am looking at the first category's first habit (if they exist)
        //but this should be effective for all categories and habits
        
        createTestCategory()
        createTestHabit(type: "weekly")
        
        let testCategory = HabitService.shared.habitCategories().fetchedObjects?.last
        let testHabit = HabitService.shared.habits(for: testCategory!).fetchedObjects?.last
        
        //pretend we completed testHabit today
        
        HabitService.shared.setHabitAsCompleted(habit: testHabit!,at:Date())
        
        let oneWeekAfterCompletion = Calendar.current.date(byAdding: .day, value: 7, to: (testHabit!.lastCompleted!))
        
        HabitService.shared.updateHabit(habit: testHabit!, basedOn: oneWeekAfterCompletion!)
        
        print(testHabit!.completed)
        
        XCTAssertFalse(testHabit!.completed, "A calendar week passed after the last completion, yet the habit is still labeled as completed")
        
        deleteTestCategory()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
