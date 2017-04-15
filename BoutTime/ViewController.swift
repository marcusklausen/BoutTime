//
//  ViewController.swift
//  BoutTime
//
//  Created by Marcus Jepsen Klausen on 05/03/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameFinishedDelegate {
   

//- MARK: OUTLETS
    
    // Arrow buttons
    @IBOutlet weak var firstEventDown: UIButton!
    @IBOutlet weak var secondEventUp: UIButton!
    @IBOutlet weak var secondEventDown: UIButton!
    @IBOutlet weak var thirdEventUp: UIButton!
    @IBOutlet weak var thirdEventDown: UIButton!
    @IBOutlet weak var fourthEventUp: UIButton!

    // Event labels
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var upperMiddleLabel: UILabel!
    @IBOutlet weak var underMiddleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var shakeTextLabel: UILabel!
    
    // next round buttons
    @IBOutlet weak var failButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    
    // Outlets for event webview buttons and countdown label
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var topEventButton: UIButton!
    @IBOutlet weak var secondEventButton: UIButton!
    @IBOutlet weak var thirdEventButton: UIButton!
    @IBOutlet weak var fourthEventButton: UIButton!

//- MARK: Actions

    // perform segue with correct event wiki URL
    @IBAction func eventWebViewEngaged(_ sender: UIButton!) {
        switch sender {
        case topEventButton:
            performSegue(withIdentifier: "WebView", sender: events[0].url)
        case secondEventButton:
            performSegue(withIdentifier: "WebView", sender: events[1].url)
        case thirdEventButton:
            performSegue(withIdentifier: "WebView", sender: events[2].url)
        case fourthEventButton:
            performSegue(withIdentifier: "WebView", sender: events[3].url)
        default:
            performSegue(withIdentifier: "WebView", sender: "http://www.teamtreehouse.com") // Easter egg
        }
    }

    // Check it next round button was pressed
    @IBAction func forceNextRound(_ sender: UIButton!) {
        buttonPressedSound()
        if sender == successButton || sender == failButton {
            newRound()
        }
    }
    
    @IBAction func moveLowerMiddleUp(_ sender: Any) {
        // Do the same as moveUpperMiddleDown
        moveUpperMiddleDown(Any.self)
    }
    @IBAction func moveUpperMiddleDown(_ sender: Any) {
        
        // Store temporary constants for swapping
        let tempEventTwo    = events[1]
        let tempEventThree  = events[2]
        
        // Swap events
        events[1] = tempEventThree
        events[2] = tempEventTwo
        
        // Update labels
        updateLabels()
        
        // Run sound function
        buttonPressedSound()
    }
    @IBAction func moveUpperMiddleUp(_ sender: Any) {
        // Do the same as moveTopDown
        moveTopDown(Any.self)
    }
    @IBAction func moveTopDown(_ sender: Any) {
        // Same concept as moveUpperMiddleDown
        let tempEventOne = events[0]
        let tempEventTwo = events[1]
        events[0] = tempEventTwo
        events[1] = tempEventOne
        updateLabels()
        buttonPressedSound()
    }
    @IBAction func moveLowerMiddleDown(_ sender: Any) {
        // Do the same as moveBottomEventUp
        moveBottomEventUp(Any.self)
    }
    @IBAction func moveBottomEventUp(_ sender: Any) {
        // Same concept as moveUpperMiddleDown
        let tempEventThree = events[2]
        let tempEventFour = events[3]
        events[2] = tempEventFour
        events[3] = tempEventThree
        updateLabels()
        buttonPressedSound()
    }
    
    // Delegate function, if score modal is dismissed then;
    func playAgainButtonPressed(_ playAgain: Bool) {
        game.points = 0
        game.roundsPlayed = 0
        newRound()
    }
    
    // Initialize game constant conforming to "GameTopic" e.g "CarTopic"
    let game: GameTopic
    
    //psuedo code
    required init?(coder aDecoder: NSCoder) {
        do {
            // Attempt to import the EventCollection.plist
            let arrayOfDictionaries = try PlistImporter.importDictionaries(fromFile: "EventCollection", ofType: "plist")
            
            // Attempt to unarchive the arrayOfDictionaries
            let collection = try CollectionUnarchiver.collection(fromArray: arrayOfDictionaries)
            
            // Initialize game to "GameTopic" with event collection as collection unarchived above
            self.game = GameTopic(eventCollection: collection)
            
        } catch let error {
            
            fatalError("\(error)")
        }
        // psuedo code
        super.init(coder: aDecoder)
    }
    
    // Updates the labels .text property to the corresponding events .statement property
    func updateLabels() {
        topLabel.text = events[0].statement
        upperMiddleLabel.text = events[1].statement
        underMiddleLabel.text = events[2].statement
        bottomLabel.text = events[3].statement
        
    }
    
    // Creation event array outside scope for global usage
    var events: [HistoricalEvent] = []
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Prepare for GameFinishedVC transition
        if segue.identifier == "GameFinishedSegue" {
            if let destination = segue.destination as? GameFinishedViewController {
                if let score = sender as? Int {
                    
                    // Set GameFinishedViewControllers score var to this VCs score var
                    destination.score = score
                    
                    // Initialize delegate on this VC otherwise it wont work
                    destination.delegate = self
                }
                
            }
        }
        
        // Prepare for webviewVC transition send link to WebVC urlString variable
        if segue.identifier == "WebView" {
            if let destination = segue.destination as? WebViewController {
                if let link = sender as? String {
                    destination.urlString = link
                }
            }
        }
    }
    
    // Helper method - enable or disable all WebView buttons
    func enableWebViewButtons(_ enable: Bool) {
        if enable == true {
            topEventButton.isEnabled = true
            secondEventButton.isEnabled = true
            thirdEventButton.isEnabled = true
            fourthEventButton.isEnabled = true
        } else if enable == false {
                topEventButton.isEnabled = false
                secondEventButton.isEnabled = false
                thirdEventButton.isEnabled = false
                fourthEventButton.isEnabled = false
            }
        }
    
    func newRound() {
        
        // Make sure we haven't played all rounds
        guard game.roundsPlayed != game.numberOfRounds else {
            
            // Else we end game
            timer?.invalidate()
            performSegue(withIdentifier: "GameFinishedSegue", sender: game.points)
            return
        }
        
        // Disable webview buttons
        enableWebViewButtons(false)
        
        events = game.pickRandomEvents(4)
        countdown.text = "1:00"
        updateLabels()
        
        game.timer = 60
        game.roundsPlayed += 1
        
        // Hide next buttons and show countdown
        failButton.isHidden = true
        successButton.isHidden = true
        countdown.isHidden = false
        
        // Set shakeTextLabel
        shakeTextLabel.text = "Shake to complete"
        
        // Create timer instance
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("tick")), userInfo: nil, repeats: true)
    }

    func endOfRound(answer: Bool) {
        
        // Show correct button
        switch answer {
        case true :
            successButton.isHidden = false
            failButton.isHidden = true
        case false :
            successButton.isHidden = true
            failButton.isHidden = false
        break
        }
        
        enableWebViewButtons(true)
        countdown.isHidden = true
        timer?.invalidate() // stop timer
        shakeTextLabel.text = "Tap events to learn more"

    }
    
    
    // Check for shake
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
                // If shake, end round with answer from checkorder()
                endOfRound(answer:
                    game.checkOrder(of: events)
            )
            
        }
    }
    
    // Initiate variable outside score for global usage
    var timer: Timer?
    
    // Timer tick method
    func tick() {
        game.timer -= 1
        
        if game.timer >= 10 {
            countdown.text = "0:\(game.timer)"
            
        } else if game.timer < 10 {
           countdown.text = "0:0\(game.timer)"
        }
        
        // If timer hits 0 then end game with answer from checkOrder()
        if game.timer <= 0 {
            endOfRound(answer:
                game.checkOrder(of: events)
            )
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide next round buttons
        successButton.isHidden = true
        failButton.isHidden = true
        
        newRound()
        
        // Update buttons with highlighted state
        // Update, finally found out how to set these in xcode instead, but I'll keep this solution.
        firstEventDown.setImage(#imageLiteral(resourceName: "down_full_selected"), for: UIControlState.highlighted)
        secondEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        secondEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        thirdEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        thirdEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        fourthEventUp.setImage(#imageLiteral(resourceName: "up_full_selected.png"), for: UIControlState.highlighted)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
