# Socceroo
Mini simulator of soccer group stage written in Swift. It specifically simulates the 1994 - 95 UEFA Champions League - Group D with, the eventual winner of the competition, AFC Ajax, Red Bull Salzburg (well, Red Bull wasn't the official name back then), AEK Athens and AC Milan.

# Instructions
Please use the following setup to evaluate the app:
- iOS Simulator (it should also work on a real device)
- iOS version 9
- Xcode 7.3+
- iPhone 5/6/6+ only

# How to use
Just tap the 'KICKOFF' button to start the simulation. Some debug information is printed out in the console to show the chances of scoring goals during the simulation of matches. Tap the KICKOFF button again to reset the group and run the simulation again. Use the 'three-dots' button in the top right of the screen to open a webpage with overal world-wide statistics as uploaded to the server.


# Screenshots
![Screenshots of Socceroo](https://s14.postimg.org/gmc1grx5d/socceroo_screens.png)

# Documentation
Source code is fully documented and docs are generated using [Jazzy](https://github.com/realm/jazzy). These can be found in the 'docs' directory. Just open the index.html file in your browser.

#Extra features
1. Extra 'gameplay': you will be asked to predict the winner of the group. Upon success you'll receive a congratulatory message!
2. Match results are uploaded and stored on the Socceroo server. The results are combined into a simple statistic webpage showing the number of matches play, goals scored, the overall group winner and runner up. You may [view these results here](http://testdrive.madthijs.com/socceroo) or from within the app (tap the 'three-dots' button in the top right corner on the toolbar).


## Third-party libraries
This app uses the Material UI framework by [CosmicMind](http://materialswift.io/) for setting up a simple but effective and clean-looking UI. All UI work is done programmatically and not through storyboards. Additionally it uses [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) by ninjaprox to show a fun animation while calculating. These frameworks are loaded and compiled into the project using CocoaPods.


