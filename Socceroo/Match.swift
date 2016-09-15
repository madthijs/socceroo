/**
 Match.swift - Socceroo
 Struct for match
 
 
 Created by Thijs Verboon.
 Copyright © 2016 Thijs Verboon. All rights reserved.
 */

import Foundation

/// A football (soccer) match between two teams
struct Match {
    
    /// Home team for the match
    var home: Team
    
    /// Away team for the match
    var away: Team
    
    /// Goals scored by the home team in the match
    var homeGoals: Int = 0
    
    /// Goals scored by the away team in the match
    var awayGoals: Int = 0
    
    
    /**
     Initializes a new football (soccer) match between two teams.
     
     - Parameters:
     - home: Name of the team
     - away: Unique identifier
     
     - Returns: A match between two teams before kickoff (0 - 0)
     */
    init(home: Team, away: Team) {
        self.home = home
        self.away = away
    }
    
    
    /**
     Simulate the result of the (soccer) match. Various parameters a used to influence the chance to score goals.
     
     1. Team rating (+ / - 0.5% per 1 point difference)
     2. Home advantage / Away disadvantage (+10%)
     3. Previous results in group (+5%  per point difference, max 25%)
     4. Goals scored during match (A. decrease chance when behind by 10%, B. decrease 10% going from 1-0 to 2-0, C. handicap when previous goal(s) not scored)
     5. Max 10 goals per side (very unlikely to happen)
     */
    mutating private func sim(){
        
        print("\n======== "+home.name+" vs "+away.name+" =========");
        
        var hg = 0;
        var ag = 0;
        
        var handicapHome = 0;
        var handicapAway = 0;
        
        var i = 0;
        while i < 10 { //5. Max 10 goals, but chance decreases by 4B and 4C. In total 20 dice rolls are performed for each match
            
            //toggle between home and away
            var x = 0
            while x < 2 {
                //Determine baseline chance of scoring
                var chanceToScore = 40 // tweak this to start the score line realistic (base change of first goals)
                var th = home
                var ta = away
                
                var gs = hg
                var gc = ag
                
                var handicap = handicapHome
                
                
                if(x == 0){
                    //home team
                    chanceToScore += 10; //2. home advantage
                    
                }else{
                    //flip the teams / goals scored in case of away team
                    th = away
                    ta = home
                    
                    gs = ag
                    gc = hg
                    
                    handicap = handicapAway
                }
                
                //1. Team rating
                chanceToScore += (th.rating - ta.rating)
                
                //3. Previous results in group
                chanceToScore += ((th.points() - ta.points())/2)
                
                
                //4A. Decrease chance when behind
                if(gs < gc){
                    chanceToScore -= 10
                }
                
                //4B. Decrease chance when already scored (makes it harder to keep making goals)
                chanceToScore -= 10*i
                
                //4C. Penalty when previous goal not scored, but there is still a chance
                if(gs < i){
                    handicap += i
                    
                    //home team
                    if(x == 0){
                        handicapHome = handicap;
                    }else{
                        //away team
                        handicapAway = handicap;
                    }
                }
                
                //make sure handicap is bigger than 0 to prevent division by 0
                if(handicap > 0){
                    chanceToScore = Int(chanceToScore / handicap);
                }
                
                //make sure chance to score is never less than 0
                if(chanceToScore < 0){
                    chanceToScore = 0;
                }
                
                //roll the dice between 0 and 100. If between 0 and chanceToScore =>>> GOAL!!!
                let dice = Int(arc4random_uniform(100));
                
                //print out some debug info
                print("Chance for "+th.name+" to score: "+chanceToScore.description+"%")
                
                if(dice <= chanceToScore){
                    
                    
                    //home team
                    if(x == 0){
                        hg += 1
                    }else{
                        //away team
                        ag += 1
                    }
                    
                    //print out some debug info if goals is scored
                    print("Goal!!! "+hg.description+" - "+ag.description)
                    
                }
                
                
                
                x += 1;
            }
            
            i += 1
            
        }
        
        
        // save results to the match
        homeGoals = hg;
        awayGoals = ag;
    }
    
    
    /**
     Play the match and update the teams with the results
     */
    mutating func play(){
        sim();
        
        
        //update teams when home and away score the same amount of goals
        if(homeGoals == awayGoals){
            home.d += 1;
            away.d += 1;
        }
        
        //update teams when home scores more goals
        if(homeGoals > awayGoals){
            home.w += 1;
            away.l += 1;
        }
        
        //update teams when away scores more goals
        if(homeGoals < awayGoals){
            away.w += 1;
            home.l += 1;
        }
        
        home.gs += homeGoals
        home.gc += awayGoals
        
        away.gs += awayGoals
        away.gc += homeGoals
    }
    
    
    /**
     Parse the match (and results) into a JSON string
     
     -Returns: JSON string
     */
    func toJSON() -> String{
        let jsonData: [String: AnyObject] = [
            "home": home.key,
            "away": away.key,
            "homeGoals": homeGoals,
            "awayGoals": awayGoals
            
        ]
        
        if NSJSONSerialization.isValidJSONObject(jsonData) {
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(jsonData, options: NSJSONWritingOptions(rawValue: 0))
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            } catch {
                
            }
        }
        return ""
    }
    
    
}


