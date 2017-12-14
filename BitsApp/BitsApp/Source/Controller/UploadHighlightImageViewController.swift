//
//  UploadHighlightImageViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/30/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

class UploadHighlightImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFetchedResultsControllerDelegate{
    
    var habit: Habit!
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated:true,completion:nil)
        }
    }
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated:true,completion:nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_sender: Any){
        if(imageView.image != nil){
            let imageData = UIImagePNGRepresentation(imageView.image!)
            HabitService.shared.addHighlightImage(data: imageData,for: habit)
            performSegue(withIdentifier: "ReturnToDetailViewSegue", sender: _sender)
            
            //save imageData to a coreData highlightimage instance
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ReturnToDetailViewSegue"){
            let detailHabitView = segue.destination as! DetailHabitViewController
          
            detailHabitView.habit = habit
            detailHabitView.title = "\(detailHabitView.habit.title!) Details"
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.83, green:0.83, blue:0.85, alpha:1.0)
    }
}
