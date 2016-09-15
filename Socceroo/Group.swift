/**
 Group.swift - Socceroo
 Struct for group
 
 
 Created by Thijs Verboon.
 Copyright © 2016 Thijs Verboon. All rights reserved.
 */

import Foundation

/// A group of football (soccer) team competing in a group stage before moving on to the elimination round
struct Group {
    
    /// A list of all football (soccer) teams within the group.
    var teams: Array<Team>
    
    /// A list of all the matches to play in the group stage (home and away).
    var matches: Array<Match>
    
    /// Prediction of the group winner by the player
    var predictedWinner: String
    
    
    /**
     Initializes a new football (soccer) match between two teams.
     
     - Parameters:
     - home: Name of the team
     - away: Unique identifier
     
     - Returns: A match between two teams before kickoff (0 - 0)
     */
    init() {
        teams =  Array<Team>()
        matches = Array<Match>()
        predictedWinner = "";
    }
    
    /**
     Adds a team to the group
     
     - Parameters:
     - team: Team to add to the group
     
     */
    mutating func addTeam(team: Team) {
        teams.append(team);
    }
    
    /**
     Creates (schedules) the matches once all 4 teams are added to the group. Every team is matched against every other team in a home and away match. For example Team 1 plays against 2(h)-3(a)-4(h)/4(a)-3(h)-2(a) as is usual in Champions League group phases. This is important for the simulation because of home advantages and hte importance of previous results in the group.
     
     - Parameters:
     - team: Team to add to the group
     
     */
    mutating func createMatches() {
        
        let teamOne = teams[0];
        
        var rounds = teams.count - 1;
        
        while rounds > 0 {
            var teamsCopy = teams;
            let a = teamsCopy[rounds];
            teamsCopy.removeAtIndex(rounds)
            
            //Get the right distribution of home/away
            if(rounds == 2){
                matches.append(Match(home: a, away: teamOne));
            }else{
                matches.append(Match(home: teamOne, away: a));
            }
            
            //get rid of the first one TeamOne)
            teamsCopy.removeFirst()
            
            //The other match is from the left over teams.
            //Get the right distribution of home/away
            if(rounds == 2){
                matches.append(Match(home: teamsCopy[1], away: teamsCopy[0]));
            }else{
                matches.append(Match(home: teamsCopy[0], away: teamsCopy[1]));
            }
            
            
            rounds -= 1;
        }
        
        //Add away matches
        let matchesCopy = matches;
        for match in matchesCopy {
            matches.insert(Match(home: match.away, away: match.home), atIndex: 6);
        }
        
    }
    
    /**
     Sort the teams within the group based on results in matches.
     1. Points
     2. Goal difference
     3. Goals scored
     4. Goals conceded
     5. Aggregate results
     */
    
    mutating func sort() {
        teams.sortInPlace({
            if $0.points() != $1.points(){
                return $0.points() > $1.points()
            }else if $0.goals() != $1.goals(){
                return $0.goals() > $1.goals()
            }else if $0.gs != $1.gs{
                return $0.gs > $1.gs
            }else if $0.gc != $1.gc{
                return $0.gc > $1.gc
            }else{
                return winnerByAggregateResult($0, t2: $1)
            }
        })
    }
    
    /**
     Determine the winner based on aggregate results. This is a simple version which looks at the point difference between the two teams in the matches they played against each other. It does not take into acount goals scored or goals scored in away matches. If both got an equal amount of point the winner is declared alphabetically.
     
     - Parameters:
     - t1: Team 1
     - t2: Team 2
     
     - Returns: Boolean for which team won (true: t1, false: t2)
     */
    func winnerByAggregateResult(t1: Team, t2: Team) -> Bool{
        //if t1 wins return true
        var pointsByT1 = 0;
        var pointsByT2 = 0;
        
        for match in matches{
            
            //check home result
            if(match.home.key == t1.key && match.away.key == t2.key){
                if(match.homeGoals > match.awayGoals){
                    pointsByT1 += 3;
                    
                }else{
                    if(match.homeGoals < match.awayGoals){
                        pointsByT2 += 3;
                    }else{
                        pointsByT1 += 1;
                        pointsByT2 += 1;
                    }
                }
            }
            //check away result
            if(match.home.key == t2.key && match.away.key == t1.key){
                if(match.homeGoals > match.awayGoals){
                    pointsByT2 += 3;
                    
                }else{
                    if(match.homeGoals < match.awayGoals){
                        pointsByT1 += 3;
                    }else{
                        pointsByT1 += 1;
                        pointsByT2 += 1;
                    }
                }
            }
        }
        
        if(pointsByT1 != pointsByT2){
            return pointsByT1 > pointsByT2;
        }else{
            
            //if draw return alphabetical order
            return t1.name > t2.name
        }
    }
    
    /**
     Start simulation of the matches in the group. Update teams along the way to provide intermidate results but also use these results in the upcoming matches. Sorts the group after all matches are done.
     */
    mutating func simulate() {
        
        
        var i = 0;
        for match in matches {
            var m = match
            
            //update team (enable use of previous match results in simulation)
            let h = getTeamByKey(m.home.key);
            if(h != nil){
                m.home = h!;
            }
            
            let a = getTeamByKey(m.away.key);
            if(a != nil){
                m.away = a!;
            }
            
            
            //play match
            m.play();
            
            //update matchlist with results
            matches[i] = m;
            
            //update teams with results
            updateTeam(m.home);
            updateTeam(m.away);
            
            
            i += 1;
        }
        
        //sort the group standing
        sort();
        
        
        
    }
    
    /**
     Retreives the team from the group by its unique identifier. Helper function for getting teams from the Teams array.
     - Parameters:
     - key: Unique identifier (key) of team
     - Returns: Team
     */
    private func getTeamByKey(key: String) -> Team?{
        for t in teams {
            if(t.key == key){
                return t
            }
        }
        
        return nil
    }
    
    /**
     Updates the team in the group. Helper function for updating teams in the Teams array.
     - Parameters:
     - team: Updated team
     
     */
    private mutating func updateTeam(team: Team){
        var i = 0
        for t in teams {
            if(t.key == team.key){
                teams[i] = team
                break;
            }
            i += 1;
            
        }
    }
    
    /**
     Get the group winner (number 1)
     - Returns: Winner (team) of the group
     
     */
    func winner() -> Team{
        return teams[0];
    }
    
    
    /**
     Parses all the match results in the group into a JSON string (array of matches)
     - Returns: JSON string (array)
     */
    func getResultsAsJSON() -> String{
        var json = "[";
        
        for match in matches {
            if(json != "["){
                json += ","
            }
            json += match.toJSON()
        }
        
        json += "]"
        
        return json
    }
    
    
}


