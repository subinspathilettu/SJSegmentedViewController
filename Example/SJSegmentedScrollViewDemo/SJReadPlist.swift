//
//  SJReadPlist.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Sonnet on 03/01/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
//var resultDictionary = NSDictionary()

class SJReadPlist: NSObject {
 
    
      open func readPlist()
    {
        
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("data.plist")
        
        
        let fileManager = FileManager.default
        
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "data", ofType: "plist") {
                
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }
                catch let error as NSError
                {
                    print("Oops.. Something went wrong")
                }
                print("copy")
            } else {
                print("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("GameData.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        
        if let myDict = NSDictionary(contentsOfFile:  path)
        {
            PhotosCollectionViewController.resultDictionary = NSMutableDictionary(contentsOfFile: path)!
            print("Loaded GameData.plist file is --> \(PhotosCollectionViewController.resultDictionary.description)")
            
//            let dict = myDict
//            //            //loading values
//            //            bedroomFloorID = dict.objectForKey(BedroomFloorKey)!
//            //            bedroomWallID = dict.objectForKey(BedroomWallKey)!
//            let appCrashedLastTime = dict.object(forKey: "DidAppCrashedLastTime") as! Bool
////            if appCrashedLastTime
////            {
////                stAlert.showAlertOnCrash()
////            }
//            let exceptionName = dict.object(forKey: "Exception")!
//            let reason = dict.object(forKey: "Reason")
//            print("Exception : \(exceptionName)")
//            print("Exception Reason: \(reason)")
//            //...
        }
        else {
            print("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
        }
        
    }

}
