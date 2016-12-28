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
    var projects_no:NSString
    var ratingImage:UIImage
    var collagePhoto:UIImage
    
   
    init(phtgrapher:NSString, projects:NSString, rating:UIImage, collage:UIImage) {
        
        photographerName = phtgrapher
        projects_no = projects
        ratingImage = rating
        collagePhoto = collage
    }

}
