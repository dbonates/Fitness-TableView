//
//  RateView.swift
//  Movies
//
//  Created by Daniel Bonates on 8/8/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit

@IBDesignable class RateView: UIView {
    
    
    @IBInspectable var color : UIColor = UIColor.lightGrayColor()
    
    @IBInspectable var bgColor : UIColor = UIColor.grayColor() {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    
    func tintMe() {
        color = UIColor(red:0.996,  green:0.953,  blue:0, alpha:1)
    }
    
    
    
    override func drawRect(rect: CGRect) {
        
        
        let starPath = UIBezierPath()
        starPath.moveToPoint(CGPointMake(7.5, 0))
        starPath.addLineToPoint(CGPointMake(10.15, 3.86))
        starPath.addLineToPoint(CGPointMake(14.63, 5.18))
        starPath.addLineToPoint(CGPointMake(11.78, 8.89))
        starPath.addLineToPoint(CGPointMake(11.91, 13.57))
        starPath.addLineToPoint(CGPointMake(7.5, 12))
        starPath.addLineToPoint(CGPointMake(3.09, 13.57))
        starPath.addLineToPoint(CGPointMake(3.22, 8.89))
        starPath.addLineToPoint(CGPointMake(0.37, 5.18))
        starPath.addLineToPoint(CGPointMake(4.85, 3.86))
        starPath.closePath()
        color.setFill()
        starPath.fill()
    }


}
