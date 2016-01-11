//
//  ViewController.swift
//  FitnessApp
//
//  Created by Daniel Bonates on 8/17/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var logoFinal: UIImageView!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var blurPhoto: UIImageView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var zipInput: UITextField!
    @IBOutlet weak var loadingIndicatorView: UIView!
    
    // a flag for prevent animating the UI before the intro animation
    var firstLoading = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        // Keyboard notifications for animation of input
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotificationChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotificationHide:", name: UIKeyboardWillHideNotification, object: nil)

        
        // hidding elements before animation
        self.resetUI()
        
        
        self.animateOutLogo()
        
    }
    
    // MARK: - a little intro animation
    func animateOutLogo() {
        
        // animation for inicial logo before start UI
        let force : Float = 1
        let curve = CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
        
        let animation = CAKeyframeAnimation()
        animation.delegate = self
        animation.keyPath = "position.y"
        
        // for shake animation instead
        //        animation.values = [0, 30*force, -30*force, 30*force, -400]
        //        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8]
        
        animation.values = [0, 30*force, -400]
        animation.keyTimes = [0, 0.2, 0.4]
        
        animation.timingFunction = curve
        animation.duration = 1.8
        animation.additive = true
        animation.beginTime = 0
        
        animation.removedOnCompletion = false
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        
        self.logoImgView.layer.addAnimation(animation, forKey: "shake")
    }
    
    override func viewDidAppear(animated: Bool) {
        // preventing the UI init before the little logo animation ends
        if !firstLoading { self.startAllAnimations() }
    }
    
    
    
    
    // MARK: - Keyboard callbacks for animating the input field
    
    // gets the keyboard final frame to reposition the elements accordingly
    func keyboardNotificationChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: {
                    self.zipInput.transform = CGAffineTransformMakeTranslation(0, -endFrame!.origin.y+60)
                    self.logoFinal.transform = CGAffineTransformMakeTranslation(0, -20)
                    self.topLbl.transform = CGAffineTransformMakeTranslation(0, -20)

                },
                completion: nil)
        }
    }
    
    
    func keyboardNotificationHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: {
                    self.zipInput.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.logoFinal.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.topLbl.transform = CGAffineTransformMakeTranslation(0, 0)
                    
                },
                completion: nil)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()

        showSearchingIndicator()
        
        return true;
    }
    
    
    // MARK: - Search done, show indicator and perform segue
   
    func showList() {
        
        delay(1.0, closure: { () -> () in
            self.performSegueWithIdentifier("listSegue", sender: self)
            self.resetUI()
        })
    }
    
    func showSearchingIndicator() {
        
        self.loadingIndicatorView.layer.opacity = 0
        self.loadingIndicatorView.hidden = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.loadingIndicatorView.layer.opacity = 1
            }, completion: { success in
                self.showList()
        })
      

    }
    
    func hideSearchingIndicator() {
        self.loadingIndicatorView.layer.opacity = 0
        self.loadingIndicatorView.hidden = true
    }
    
    // MARK: - Building the UI
    
    
    // setup UI offscreen
    func resetUI() {
        
        hideSearchingIndicator()
        
        logoFinal.transform = CGAffineTransformMakeTranslation(0, -400)
        foto.transform = CGAffineTransformMakeTranslation(0, 600)
        blurPhoto.transform = CGAffineTransformMakeTranslation(0, 400)
        topLbl.transform = CGAffineTransformMakeTranslation(0, -400)
        zipInput.transform = CGAffineTransformMakeTranslation(0, 200)
    }
    
    
    func startAllAnimations() {
        
        let duration:NSTimeInterval = 0.6
        let gap:NSTimeInterval = 0.3
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.topLbl.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
        
        UIView.animateWithDuration(duration, delay: gap, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.logoFinal.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
        

        
        UIView.animateWithDuration(duration, delay: gap*2, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.foto.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
        
        
        
        self.blurPhoto.layer.opacity = 0
        self.blurPhoto.transform = CGAffineTransformMakeTranslation(0, 0)
        
        UIView.animateWithDuration(duration*2, delay: gap*3, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.blurPhoto.layer.opacity = 1
            
            }, completion: nil)
        
        UIView.animateWithDuration(duration, delay: gap*4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.zipInput.transform = CGAffineTransformMakeTranslation(0, 0)
            
            }, completion: nil)
        
    }
   
    
    
    
    // MARK: - after intro animation finish, building the UI
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.logoImgView.hidden = true
        firstLoading = false
        self.startAllAnimations()
    }
    
    
    // MARK: - A nice and handy delay function!
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

