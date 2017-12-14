//
//  HighlightReelCollectionViewController.swift
//  FinalProject
//
//  Created by Kelemen Szimonisz on 11/30/17.
//  Copyright © 2017 Kelemen Szimonisz. All rights reserved.
//

import UIKit
import CoreData

class HighlightReelCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    private var convertedImage: UIImage!
    private var arrayOfUIImages: Array<UIImage> = []

    var habit: Habit!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitService.shared.highlightImages(for:habit).fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightImageCell", for: indexPath) as! HighlightImageCell
        
        let cellImage = arrayOfUIImages[indexPath.row]
        
        cell.highlightImageView.image = cellImage
        return cell
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arrayOfHighlightImages = HabitService.shared.highlightImages(for:habit).fetchedObjects
        
        for highlightImage in arrayOfHighlightImages!{
            let convertedImage = UIImage(data:highlightImage.data!,scale:0.4)
            arrayOfUIImages.append(convertedImage!)
        }
       
    }
    
}
