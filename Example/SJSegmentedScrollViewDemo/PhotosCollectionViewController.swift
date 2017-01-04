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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let sjObject =  SJReadPlist()
        sjObject.readPlist()
       print("\(PhotosCollectionViewController.resultDictionary.description)")
        
        let dict = PhotosCollectionViewController.resultDictionary
        let arrayDict:[NSDictionary] = dict.value(forKey: "item0") as! [NSDictionary]
        for dictionary1 in arrayDict {
            photoCell.append(PhotosModel(dict: dictionary1))
        }
        //getDataObjects()
        
        
     //   self.collectionView!.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    func getDataObjects()  {
        
        photoCell.append(PhotosModel(phtgrapher:
            "Randall Austin", projects:
            "120 Projects", rating:#imageLiteral(resourceName: "stars_01") , collage: #imageLiteral(resourceName: "image_set_01")))
        photoCell.append(PhotosModel(phtgrapher:
            "Derrick Barker", projects:
            "115 Projects", rating:#imageLiteral(resourceName: "stars_03") , collage: #imageLiteral(resourceName: "img_set_02")))
        photoCell.append(PhotosModel(phtgrapher:
            "Dominic Walters", projects:
            "100 Projects", rating:#imageLiteral(resourceName: "stars_01") , collage:#imageLiteral(resourceName: "img_set_4")))
        photoCell.append(PhotosModel(phtgrapher:
            "George Quinn", projects:
            "105 Projects", rating:#imageLiteral(resourceName: "stars_02") , collage:#imageLiteral(resourceName: "img_set_05")))
        
        photoCell.append(PhotosModel(phtgrapher:
            "Adeline Marshall", projects:
            "90 Projects", rating:#imageLiteral(resourceName: "stars_01") , collage:#imageLiteral(resourceName: "image_set_06")))
        photoCell.append(PhotosModel(phtgrapher:
            "Martha Flowers", projects:
            "80 Projects", rating:#imageLiteral(resourceName: "stars_02") , collage:#imageLiteral(resourceName: "img_set_07")))
        
        photoCell.append(PhotosModel(phtgrapher:
            "Frank Ramsey", projects:
            "99 Projects", rating:#imageLiteral(resourceName: "stars_03") , collage:#imageLiteral(resourceName: "img_set_08")))
        
        photoCell.append(PhotosModel(phtgrapher:
            "Edward Lawson", projects:
            "88 Projects", rating:#imageLiteral(resourceName: "stars_02") , collage:#imageLiteral(resourceName: "img_set_02")))
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
   // cell.backgroundColor = UIColor.black
        let item = photoCell[indexPath.row]
        cell.photographerName.text = item.photographerName  as String
        cell.noOfProjects.text = item.projectsNo  as String
        cell.rating.image = item.ratingImage
        cell.collage.image = item.collagePhoto
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
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
