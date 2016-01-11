//
//  PersonalTableViewCell.swift
//  FitnessApp
//
//  Created by Daniel Bonates on 8/17/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit


class PersonalTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var reviewsLbl: UILabel!
    @IBOutlet weak var yearsLbl: UILabel!
    @IBOutlet weak var specialitiesLbl: UILabel!
    
    @IBOutlet weak var s1: RateView!
    @IBOutlet weak var s2: RateView!
    @IBOutlet weak var s3: RateView!
    @IBOutlet weak var s4: RateView!
    @IBOutlet weak var s5: RateView!
    @IBOutlet weak var photoView: UIImageView!
    
    var stars = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(personal:NSDictionary) {
        
        self.stars = [s1, s2, s3, s4, s5]
        
        self.nameLbl.text = personal.objectForKey("fullname") as? String
        
        let distanceString: Int = personal.objectForKey("rate")!.integerValue!
        self.locationLbl.text = "Austin, TX, \(distanceString) miles away"
        
        let reviews:Int = personal.objectForKey("reviews")!.integerValue!
        self.reviewsLbl.text = "\(reviews) reviews"
        
        let specialities : NSArray = personal["specialities"] as! NSArray
        self.specialitiesLbl.text = "\(specialities[0]), \(specialities[1])"
        
        let years:Int = personal.objectForKey("years")!.integerValue!
        self.yearsLbl.text = "\(years)"
        
        let rate:Int = personal.objectForKey("rate")!.integerValue!
        self.tintStarsForRate(rate)
        
        
        self.photoView.layer.cornerRadius = self.photoView.bounds.size.width/2
        self.photoView.clipsToBounds = true

        

        // photo
        let nameDict : NSDictionary = personal["name"] as! NSDictionary
        if let imgName = nameDict.objectForKey("first") as? String {
            self.photoView.image = UIImage(named: imgName)
        } else {
            self.photoView.image = UIImage(named: "placeholder")
        }
        
    }
    
    func tintStarsForRate(rate:Int) {
        if rate < 1 { return }
        
        let arr = 0...rate-1
        for n in arr {
            let s = stars[n] as! RateView
            s.tintMe()
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

}
