    //
//  PhotosCollectionViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Sonnet on 23/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let itemsPerRow: CGFloat = 2
private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 0.0, right: 10.0)
  private let sectionInsets2 = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0)

  class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  static var resultDictionary = NSDictionary()
    var photoCell: [PhotosModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataObjects()
        
    }

    func getDataObjects()  {
        
        let sjObject =  SJReadPlist()
        sjObject.readPlist()
        print("\(PhotosCollectionViewController.resultDictionary.description)")
        let dict = PhotosCollectionViewController.resultDictionary
        let arrayDict:[NSDictionary] = dict.value(forKey: "item0") as! [NSDictionary]
        for dictElement in arrayDict {
            photoCell.append(PhotosModel(dict: dictElement))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoCell.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
    
        // Configure the cell
        let item = photoCell[indexPath.row]
        cell.photographerName.text = item.photographerName  as String
        cell.noOfProjects.text = item.projectsNo  as String
        cell.rating.image = item.ratingImage
        cell.collage.image = item.collagePhoto
        return cell
    }

   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)

        
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: 150)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets2
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
          return 10
    }
}
