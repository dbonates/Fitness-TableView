//
//  ListTableViewController.swift
//  FitnessApp
//
//  Created by Daniel Bonates on 8/17/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit


class ListTableViewController: UITableViewController {
    
    
    // these are for help on scroll direction detection
    var toTop = false
    var currentOffset:CGFloat = 0
    
    // for wooble effect on photos
    let animationLeft = CAKeyframeAnimation()
    let animationRight = CAKeyframeAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let font = UIFont(name: "Avenir-Book", size: 22) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        
        // some visual setup
        view.backgroundColor = UIColor.whiteColor()
        self.tableView.rowHeight = 168;
        
        // tableview go offscreen, will enter on viewWillAppear
        self.tableView.transform = CGAffineTransformMakeTranslation(0, 667)

        
        
        // MARK: - setup animation for 'wooble' effect of photos on cells
        
        let force = 0.2
        let duration = 1
        let amount = 0.2
        
        animationLeft.keyPath = "transform.rotation"
        animationLeft.values = [0, amount*force, -amount*force, amount*force, 0]
        animationLeft.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animationLeft.duration = CFTimeInterval(duration)
        animationLeft.additive = true
        
        animationRight.keyPath = "transform.rotation"
        animationRight.values = [0, -amount*force, amount*force, -amount*force, 0]
        animationRight.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animationRight.duration = CFTimeInterval(duration)
        animationRight.additive = true

    }
    
    // MARK: Show the tableview
    override func viewWillAppear(animated: Bool) {
        
        // remember, the tableview went offscreen on didload
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: nil)
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PersonalSource().personals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PersonalTableViewCell

        let personal = PersonalSource().personals[indexPath.row]
        
        // let the cell configure itself
        cell.configureCell(personal)

        return cell
    }
    
    
    // MARK: - tableview delegate and fx
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        

        if !tableView.dragging {
            
            // first animation, when not scrolling it should be simple
            cell.contentView.layer.opacity = 0
            cell.contentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                cell.contentView.layer.opacity = 1
                cell.contentView.transform = CGAffineTransformMakeScale(1, 1)

            })
            
            return
        
        }
        
        let mvCell:PersonalTableViewCell = cell as! PersonalTableViewCell
        
        cell.contentView.layer.opacity = 0
        if toTop {
            
            mvCell.contentView.transform = CGAffineTransformMakeTranslation(0, -200)
            mvCell.photoView.transform = CGAffineTransformMakeTranslation(0, -200)
            mvCell.photoView.layer.addAnimation(self.animationLeft, forKey: "wobble")

            
        } else {
            mvCell.contentView.transform = CGAffineTransformMakeTranslation(0, 200)
            mvCell.photoView.transform = CGAffineTransformMakeTranslation(0, 200)
            mvCell.photoView.layer.addAnimation(self.animationRight, forKey: "wobble")

        }
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            let mvCell:PersonalTableViewCell = cell as! PersonalTableViewCell
            
            mvCell.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
            mvCell.contentView.layer.opacity = 1
            
            }, completion: nil)
        
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            let mvCell:PersonalTableViewCell = cell as! PersonalTableViewCell
            
            mvCell.photoView.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
    }
    
    
    // MARK: - using scrollview callbacks from tableview to setup scroll direction, later needed for animation
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        currentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let newOffset = scrollView.contentOffset.y
        
        if newOffset > currentOffset {
            toTop = false
        } else {
            toTop = true
        }
        currentOffset = newOffset
    }
    
    
    // MARK: - Remove this viewcontroller from stack and return to the search screen
    
    @IBAction func dismissMe(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }

}
