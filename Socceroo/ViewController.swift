/**
    ViewController.swift - Socceroo
    Main ViewController for the socceroo app
 

    Created by Thijs Verboon.
    Copyright © 2016 Thijs Verboon. All rights reserved.
*/

import UIKit
import Material
import NVActivityIndicatorView
import SafariServices


/// Main ViewController for the Socceroo app
class ViewController: UIViewController, NVActivityIndicatorViewable {
    
    /// Reference for containerView (VerticalLayout)
    private var containerView: VerticalLayout!
    
    /// Reference for statusBar background color
    private var statusBarBackgroundView: UIView!
    
    /// Reference for contentView (VerticalLayout)
    private var contentView: VerticalLayout!
    
    /// Reference for main toolbar at top of screen.
    private var toolbar: Toolbar!

    
    /// A tableView used to display group standings.
    private let tableView: UITableView = UITableView()
    
    /// A tableView used to display match results.
    private let resultView: UITableView = UITableView()
    
    /// The group containing football (soccer) teams and scheduled matches (and results)
    private var group: Group = Group()
    
    
    
    override func viewWillAppear(animated: Bool) {
        //toggle statusBar style to fit with Material theme
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        super.viewWillAppear(animated)
    }
    
    
    /// Initializes general layout of the app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Prepare views / layouts
        prepareView()
        prepareContainerView()
        prepareToolbar()
        prepareContentView()
        
        prepareGroupTableView()
        prepareResultsView()
        prepareStartButton()
    }
    
    
    
    /// General preparation statements (Basic Layout)
    private func prepareView() {
        view.backgroundColor = MaterialColor.grey.lighten4
    }
    
    /// Prepares the containerView (Basic Layout)
    private func prepareContainerView() {
        containerView = VerticalLayout(width: view.frame.width)
        
        view.addSubview(containerView)
    }
    
    /// prepares the contentView (Basic Layout)
    private func prepareContentView(){
        let w  = (view.bounds.width - 20)
        contentView = VerticalLayout(width: view.frame.width)
        
        let marginView = UIView(frame: CGRectMake((view.bounds.width - w) / 2, 20, w, view.bounds.height - 110))
        
        marginView.addSubview(contentView)
        containerView.addSubview(marginView)
    }
    
    /// Prepares the toolbar (Basic Layout)
    private func prepareToolbar() {
        
        statusBarBackgroundView = UIView()
        statusBarBackgroundView.frame = CGRectMake(0 , 0, view.frame.width, 20)
        statusBarBackgroundView.backgroundColor = MaterialColor.teal.darken2
        
        containerView.addSubview(statusBarBackgroundView)
        
        
        // Create and place toolbar
        toolbar = Toolbar()
        toolbar.frame = CGRectMake(0 , 0, view.frame.width, 40)
        containerView.addSubview(toolbar)
        
        
        
        // Title label.
        toolbar.title = "Socceroo"
        toolbar.titleLabel.textColor = MaterialColor.white
        
        
        
        var image: UIImage? = UIImage(named: "Ball")
        
        
        // Ball button (does not do anything)
        let infoButton: IconButton = IconButton()
        infoButton.pulseColor = MaterialColor.white
        infoButton.tintColor = MaterialColor.white
        infoButton.setImage(image, forState: .Normal)
        infoButton.setImage(image, forState: .Highlighted)
        
        
        // Stats/More button (opens webview with world-wide stats)
        image = MaterialIcon.cm.moreHorizontal
        let shareButton: IconButton = IconButton()
        shareButton.pulseColor = MaterialColor.white
        shareButton.tintColor = MaterialColor.white
        shareButton.setImage(image, forState: .Normal)
        shareButton.setImage(image, forState: .Highlighted)
        
        shareButton.addTarget(self, action: #selector(openWorldwideStats), forControlEvents: .TouchUpInside)
        
        
        toolbar.backgroundColor = MaterialColor.teal.base
        toolbar.leftControls = [infoButton]
        toolbar.rightControls = [shareButton]
        
        
        
    }
    
    /// Open Webview/SafariViewController with world-wide statistics from socceroo
    func openWorldwideStats(){
        let svc = SFSafariViewController(URL: NSURL(string: "http://testdrive.madthijs.com/socceroo")!)
        self.presentViewController(svc, animated: true, completion: nil)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    /// Prepares KICKOFF button
    private func prepareStartButton(){
        let startButtonBar = UIView()
        
        
        startButtonBar.frame = CGRect(x: 0, y: view.frame.size.height - 60 , width: self.view.frame.width, height: 60)
        
        let w: CGFloat = 180
        let button: RaisedButton = RaisedButton(frame: CGRectMake((view.bounds.width - w) / 2, (startButtonBar.bounds.height - 30) / 2, w, 30))
        button.setTitle("KICKOFF", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = MaterialColor.teal.base
        button.pulseColor = MaterialColor.teal.lighten4
        button.titleLabel!.font = RobotoFont.mediumWithSize(16)
        button.addTarget(self, action: #selector(handleStartButton), forControlEvents: .TouchUpInside)
        
        startButtonBar.addSubview(button)
        view.addSubview(startButtonBar)
        
        
    }
    
    /// Handles tap/click on KICKOFF button. Resets the group and shows action sheet to pick winner.
    func handleStartButton() {
        //reset the group
        setupGroup()
        
        showActionSheet(view)
    }
    
    
    /// Prepares the group table view
    private func prepareGroupTableView(){
        
        
        
        //set up group to display standings befor starting
        setupGroup();
        
        tableView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "CellTeam")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.dataSource = self
        tableView.delegate = self
        
        let cardView: CardView = CardView()
        cardView.frame = CGRectMake(0 , 0, view.frame.width - 20, 200)
        
        cardView.backgroundColor = MaterialColor.grey.lighten2
        cardView.cornerRadiusPreset = .Radius1
        cardView.divider = false
        cardView.contentInsetPreset = .None
        cardView.leftButtonsInsetPreset = .Square2
        cardView.rightButtonsInsetPreset = .Square2
        cardView.contentViewInsetPreset = .None
        
        
        
        let titleLabel: UILabel = UILabel()
        titleLabel.font = RobotoFont.mediumWithSize(14)
        titleLabel.text = "1994-95 UEFA Champions League - Group D"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.grey.darken4
        
        cardView.titleLabel = titleLabel
        cardView.contentView = tableView
        
        contentView.addSubview(cardView)
        
        
    }
    
    /// Prepares the match results table view
    private func prepareResultsView(){
        
        resultView.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "CellMatch")
        resultView.separatorStyle = UITableViewCellSeparatorStyle.None
        resultView.dataSource = self
        resultView.delegate = self
        
        let cardView: CardView = CardView()
        cardView.frame = CGRectMake(0 , 20, view.frame.width - 20, view.frame.height - 370)
        
        
        cardView.backgroundColor = MaterialColor.teal.lighten5
        cardView.cornerRadiusPreset = .Radius1
        cardView.divider = false
        cardView.contentInsetPreset = .None
        cardView.leftButtonsInsetPreset = .Square2
        cardView.rightButtonsInsetPreset = .Square2
        cardView.contentViewInsetPreset = .None
        
        
        
        let titleLabel: UILabel = UILabel()
        titleLabel.font = RobotoFont.mediumWithSize(12)
        titleLabel.text = "Match Results"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.teal.darken4
        
        cardView.titleLabel = titleLabel
        cardView.contentView = resultView
        
        
        
        contentView.addSubview(cardView)
        
    }
    
    /// Sets up the group. Creates and adds the teams to the group and schedules matches
    private func setupGroup() {
        group = Group();
        
        group.addTeam(Team(name: "AFC Ajax", key: "AJAX", rating: 90))
        group.addTeam(Team(name: "Redbull Salzburg", key: "SALZBURG", rating: 69))
        group.addTeam(Team(name: "AEK Athens", key: "AEK", rating: 76))
        group.addTeam(Team(name: "AC Milan", key: "MILAN", rating: 88))
        
        
        group.createMatches();
        
        
    }
    
    /// Shows a fancy loader to indicate processing / simulation of matches. Continues after a set time to 'finishLoading'
    func showLoader(){
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message: "Simulating...", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.BallGridPulse.rawValue)!)
        performSelector(#selector(finishLoading),
                        withObject: nil,
                        afterDelay: 1.5)
        
    }
    
    /** Performs actions after the processing loader is done.
    - Hides the loader
    - Informs the user of the results (winner prediction, result tables, group standings)
    - Sends the match results to the server for overall statistics.
    */
    func finishLoading() {
        stopAnimating()
        showResultMessage();
        updateTables();
        sendResultsToServer();
    }
    
    
    // Sends match results to the Socceroo server as a JSON string.
    func sendResultsToServer(){
        let post = group.getResultsAsJSON();
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://testdrive.madthijs.com/socceroo/")!)
        request.HTTPMethod = "POST"
        let postString = "data="+post
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print(responseString)
        }
        task.resume()
    }
    
    /// Updates (redraws) match results tableview and group standings table view
    func updateTables(){
        resultView.reloadData()
        tableView.reloadData()
    }
    
    
    /// Shows the results of the winner prediction to the user via an alert. The winner of the group is compared to the predicted winner by the user and an appropriate message is displayed.
    private func showResultMessage(){
        var title = "Winner!"
        var message = "You made the right choice! "+group.winner().name+" has won the group!"
        
        if(group.predictedWinner != group.winner().key){
           title = "Unlucky";
           message = "You didn't think "+group.winner().name+" would win this group? Better luck next time!";
        }
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    /** Displays an ActionSheet allowing the user to predict a winner for the group.
 - Parameters: sender
     */
    func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Who do you think will win Group D of the 1994-95 UEFA Champions League?", preferredStyle: .ActionSheet)
        
        
        for team in group.teams{
            let action = UIAlertAction(title: team.name, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                //print(team.name)
                self.group.predictedWinner = team.key;
                
                //start simulation
                self.group.simulate();
                
                //show loader to give the illustion of processing
                self.showLoader();
                
                
                
                
            })
            optionMenu.addAction(action)

        }
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
}

/// TableViewDataSource methods to extend the ViewController
extension ViewController: UITableViewDataSource {
    /// Determines the number of rows in the tableView.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tableView == self.tableView) {
            return group.teams.count
        }
        else if (tableView == resultView) {
            return group.matches.count
        }else{
            return 0
        }
        
    }
    
    /// Returns the number of sections in a table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Draws the cells within the table views (match results and group standings).
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /// Draws a cell in the group standings table
        if (tableView == self.tableView) {
            let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "CellTeam")
            
            let cellWidth = contentView.frame.width - 50
            let cellHeight = CGFloat(40)
            
            
            
            let item: Team = group.teams[indexPath.row]
            cell.selectionStyle = .None
            cell.textLabel!.text = item.name
            cell.textLabel!.font = RobotoFont.boldWithSize(14)
            
            let detail = "W: "+item.w.description+" / L: "+item.l.description+" / D: "+item.d.description+" / GS: "+item.gs.description+" / GC: "+item.gc.description;
            
            //Use default cell elements for displaying team name, detail information and team logo
            cell.detailTextLabel!.text = detail
            cell.detailTextLabel!.font = RobotoFont.lightWithSize(10)
            cell.detailTextLabel!.textColor = MaterialColor.grey.darken1
            cell.imageView!.image = item.image?.resize(toWidth: 30)
            cell.imageView!.layer.cornerRadius = 0
            
            
            
            //Points label
            let t = UILabel();
            t.frame = CGRectMake(cellWidth - 25, (cellHeight - 20)/2, 20, 20)
            t.textAlignment = .Center;
            t.backgroundColor = MaterialColor.teal.lighten4
            t.font = RobotoFont.boldWithSize(14)
            t.text = item.points().description;
            
            
            cell.addSubview(t)
            
            
            //Goaldiff label
            let g = UILabel();
            g.frame = CGRectMake(cellWidth , (cellHeight - 20)/2, 20, 20)
            g.textAlignment = .Right;
            
            g.font = RobotoFont.lightWithSize(10)
            g.textColor = MaterialColor.grey.darken2
            g.text = item.goals().description;
            
            cell.addSubview(g)
            
            
            //Rating label, use different colors to distinguih a good team from a lesser team.
            let r = UILabel();
            r.frame = CGRectMake(cellWidth - 60, (cellHeight - 20)/2, 20, 20)
            r.textAlignment = .Center;
            r.backgroundColor = MaterialColor.green.darken1
            
            if(item.rating < 85){
                    r.backgroundColor = MaterialColor.yellow.darken2
            }
            
            if(item.rating < 70){
                r.backgroundColor = MaterialColor.orange.base
            }
            
            if(item.rating < 60){
                r.backgroundColor = MaterialColor.red.lighten1
            }
            
            r.font = RobotoFont.regularWithSize(10)
            r.textColor = MaterialColor.white
            r.text = item.rating.description
            
            cell.addSubview(r)
            
            return cell
        }
            /// Draws a cell in the match result table
        else if (tableView == resultView) {
            
            let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: "CellMatch")
            
            let cellWidth = contentView.frame.width - 20
            let cellHeight = CGFloat(50)
            
            
            let item: Match = group.matches[indexPath.row]
            cell.selectionStyle = .None
            
            let seperator = UILabel();
            seperator.frame = CGRectMake((cellWidth - 30) / 2, (cellHeight - 30)/2, 30, 30)
            seperator.textAlignment = .Center;
            seperator.font = RobotoFont.boldWithSize(26)
            seperator.textColor = MaterialColor.grey.darken1
            seperator.text = "-"
            
            
            cell.addSubview(seperator)
            
            //Home score
            let hs = UILabel();
            hs.frame = CGRectMake((cellWidth - 30) / 2 - 60, (cellHeight - 30)/2, 30, 30)
            hs.textAlignment = .Center;
            if item.homeGoals <= item.awayGoals {
                hs.font = RobotoFont.regularWithSize(20)
                hs.textColor = MaterialColor.grey.darken1
            }else{
                hs.font = RobotoFont.boldWithSize(20)
            }
            
            hs.text = item.homeGoals.description
            
            
            cell.addSubview(hs)
            
            //Away score
            let aws = UILabel();
            aws.frame = CGRectMake((cellWidth - 30) / 2 + 60, (cellHeight - 30)/2, 30, 30)
            aws.textAlignment = .Center;
            if item.homeGoals >= item.awayGoals {
                aws.font = RobotoFont.regularWithSize(20)
                aws.textColor = MaterialColor.grey.darken1
            }else{
                aws.font = RobotoFont.boldWithSize(20)
            }
            aws.text = item.awayGoals.description
            
            cell.addSubview(aws)
            
            
            //Home Team Logo
            let hl = UIImageView(image: item.home.image?.resize(toWidth: 30)!)
            hl.frame = CGRectMake((cellWidth - 30) / 2 - 100, (cellHeight - 30)/2, 30, 30)
            
            cell.addSubview(hl)
            
            
            //Away Team Logo
            let al = UIImageView(image: item.away.image?.resize(toWidth: 30)!)
            al.frame = CGRectMake((cellWidth - 30) / 2 + 100, (cellHeight - 30)/2, 30, 30)
            
            cell.addSubview(al)
            
            
            
            return cell
            
        }else{
            let cell: UITableViewCell = UITableViewCell();
            return cell
        }
    }
}

/// UITableViewDelegate methods.
extension ViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (tableView == self.tableView) {
            return 40
        }
        else if (tableView == resultView) {
            return 50
        }else{
            return 0
        }
    }
}




