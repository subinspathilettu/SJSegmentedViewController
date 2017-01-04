   //
//  PhotosModel.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Sonnet on 27/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class PhotosModel: NSObject {
    
    var photographerName:NSString
    var projectsNo:NSString
    var ratingImage:UIImage
    var collagePhoto:UIImage
    
   
    init(phtgrapher:NSString, projects:NSString, rating:UIImage, collage:UIImage) {
        
        photographerName = phtgrapher
        projectsNo = projects
        ratingImage = rating
        collagePhoto = collage
    }

    init(dict:NSDictionary) {
        
        photographerName = dict.value(forKey: "photographerName") as! NSString
         projectsNo = dict.value(forKey: "projectsNo") as! NSString
         let ratingString = dict.value(forKey: "ratingImage") as! NSString
         ratingImage = UIImage(named: ratingString as String)!
        let collagePhotoString = dict.value(forKey: "collagePhoto") as! NSString
        collagePhoto = UIImage(named: collagePhotoString as String)!
    }
    func modelMap( dictArray:[NSDictionary])
    {
        for dict in dictArray {
            
            photographerName = dict.value(forKey: "photographerName") as! NSString
        }
       
        
    }
}
