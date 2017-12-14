//
//  DetailHabitViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/19/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class DetailHabitViewController: UIViewController, MFMailComposeViewControllerDelegate{
    var habit: Habit!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        HabitService.shared.updateHabit(habit: habit, basedOn: Date())
        self.view.backgroundColor =  UIColor(red:0.15, green:0.74, blue:0.48, alpha:1.0)

    }
    override func viewDidLoad(){
        super.viewDidLoad()
        typeLabel.text = habit.type
        descriptionLabel.text = habit.details
        currentStreakLabel.text = "\(habit.streak)"

        shareButton.backgroundColor = UIColor(hue: 0.3056, saturation: 0.38, brightness: 1, alpha: 1.0)

        uploadHighlightButton.backgroundColor = UIColor(red:1.00, green:0.78, blue:0.65, alpha:1.0)

        viewHighlightsButton.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.37, alpha:1.0)

        if(habit.lastCompleted == nil){
            lastCompletedLabel.text = "Never"
        }
        else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            lastCompletedLabel.text = dateFormatter.string(from:habit.lastCompleted!)
        }
        
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "UploadImageSegue"){
            if(habit.completed == false){
                let alert = UIAlertController(title: "Uh oh!", message: "You must complete your task before submitting a Highlight Image", preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    NSLog("The \"OK\" alert occured.")}))
                self.present(alert, animated: true, completion: nil)
                
            }
            else {
                let uploadHighlightImageView = segue.destination as! UploadHighlightImageViewController
            
                uploadHighlightImageView.habit = habit
            }
        }
        else if(segue.identifier == "HighlightReelSegue"){
            let highlightReelCollectionView = segue.destination as! HighlightReelCollectionViewController
            
            highlightReelCollectionView.habit = habit
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
    }
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentStreakLabel: UILabel!
    @IBOutlet weak var lastCompletedLabel: UILabel!
    @IBOutlet weak var uploadHighlightButton: UIButton!
    @IBOutlet weak var viewHighlightsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposerViewController = setupMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerViewController,animated: true,completion: nil)
        }
        else{
            showMailError()
        }
        
    }
    
    func setupMailController()->MFMailComposeViewController{
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.mailComposeDelegate = self
        
        mailComposerViewController.setSubject("My Bits Streak!")
        var daysOrWeeks: String?
        if(habit.type == "daily"){
            daysOrWeeks = "days"
        }
        else{
            daysOrWeeks = "weeks"
        }
        mailComposerViewController.setMessageBody("I've been forming a habit! I've completed the task \(habit.title!) \(habit.streak) \(daysOrWeeks!) in a row!", isHTML: false)
        
        return mailComposerViewController
    }
    
    func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not share habit streak!",message:"Your device could not send email",preferredStyle:.alert)
        let dismiss = UIAlertAction(title: "Ok",style: .default, handler:nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert,animated:true,completion:nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated:true,completion:nil)
    }
}
