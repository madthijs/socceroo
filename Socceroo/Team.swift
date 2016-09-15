/**
 Team.swift - Socceroo
 Struct for team
 
 
 Created by Thijs Verboon.
 Copyright © 2016 Thijs Verboon. All rights reserved.
 */

import Foundation
import UIKit


/// A football (soccer) team with a performance rating
struct Team {
    
    /// Name of the football (soccer) team
    var name: String
    
    /// Unique identifier of the team
    var key: String
    
    /// Performance rating from 0 (very weak) to 100 (very strong). Professional team are within the 50 - 100 range.
    var rating: Int
    
    /// (Club) logo of the team
    var image: UIImage?
    
    /// Number of matches won
    var w: Int = 0
    
    /// Number of matches lost
    var l: Int = 0
    
    /// Number of matches resulted in a draw
    var d: Int = 0
    
    /// Number of goals conceded
    var gc: Int = 0
    
    /// Number of goals scored
    var gs: Int = 0
    
    
    /**
     Initializes a new football (soccer) team with a specific performance rating.
     
     - Parameters:
     - name: Name of the team
     - key: Unique identifier
     - rating: Performance rating
     
     - Returns: A performance rated football (soccer) team
     */
    
    init(name: String, key: String, rating: Int) {
        self.name = name
        self.key = key
        self.rating = rating
        self.image = UIImage(named: key+"-Logo")
    }
    
    
    /**
     Calculates the number of points won. 3 for a match win, 1 for a draw.
     
     - Returns: Number of points won
     */
    func points() -> Int {
        return (w*3)+(d*1);
    }
    
    /**
     Calculates the goal difference. Goals scored - goals conceded.
     
     - Returns: Goal difference
     */
    func goals() -> Int {
        return gs - gc;
    }
}
