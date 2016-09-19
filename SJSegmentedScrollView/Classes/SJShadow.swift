//
//  SJShadow.swift
//  SJSegmentedScrollView
//
//  Created by Radhakrishna Pai on 24/08/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//    associated documentation files (the "Software"), to deal in the Software without restriction,
//    including without limitation the rights to use, copy, modify, merge, publish, distribute,
//    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//    substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation
import UIKit

@objc open class SJShadow: NSObject {
    var offset = CGSize(width: 0, height: 1)
    var color = UIColor.lightGray
    var radius: CGFloat = 3.0
    var opacity: Float = 0.4
    
    /**
     To create a custom shadow object.
     
     - parameter offset:  CGSize, shadow size
     - parameter color:   UIColor, shadow color
     - parameter radius:  CGFloat, shadow radius
     - parameter opacity: Float, shadow opacity
     
     - returns: SJShadow
     */
    public convenience init(offset: CGSize, color: UIColor, radius :CGFloat, opacity: Float) {
        self.init()
        self.offset = offset
        self.color = color
        self.radius = radius
        self.opacity = opacity
    }
    
    /**
     Create light shadow
     
     - returns: light SJShadow object
     */
    open class func light() -> SJShadow {
        return SJShadow(offset: CGSize(width: 0, height: 1),
                        color: UIColor.lightGray,
                        radius: 3.0,
                        opacity: 0.4)
    }
    
    /**
     Create Medium shadow
     
     - returns: medium SJShadow object
     */
    open class func medium() -> SJShadow {
        return SJShadow(offset: CGSize(width: 0, height: 1),
                        color: UIColor.gray,
                        radius: 3.0,
                        opacity: 0.4)
    }
    
    /**
     Create dark shadow
     
     - returns: dark SJShadow object
     */
    open class func dark() -> SJShadow {
        return SJShadow(offset: CGSize(width: 0, height: 1),
                        color: UIColor.black,
                        radius: 3.0,
                        opacity: 0.4)
    }
}
