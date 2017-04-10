//
//  ViewController.swift
//  BoutTime
//
//  Created by Marcus Jepsen Klausen on 05/03/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    // Interface builder outlet buttons
    @IBOutlet weak var firstEventDown: UIButton!
    @IBOutlet weak var secondEventUp: UIButton!
    @IBOutlet weak var secondEventDown: UIButton!
    @IBOutlet weak var thirdEventUp: UIButton!
    @IBOutlet weak var thirdEventDown: UIButton!
    @IBOutlet weak var fourthEventUp: UIButton!

    // Interface builder outlet labels
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var upperMiddleLabel: UILabel!
    @IBOutlet weak var underMiddleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var failButton: UIButton!
    @IBOutlet weak var successButton: UIButton!
    
    
    // Interface builder outlet countdown
    @IBOutlet weak var countdown: UILabel!
    
    // Interface builder actions/functions
    @IBAction func forceNextRound(_ sender: UIButton!) {
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
    
    
    
    // Initialize game constant conforming to "GameTopic"
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
    
    // Creation of variables outside scope for global usage
    var events: [HistoricalEvent] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameFinishedSegue" {
            if let destination = segue.destination as? GameFinishedViewController {
                if let score = sender as? Int {
                    destination.score = score
                }
                
            }
        }
    }
    
    func newRound() {
        guard game.roundsPlayed != game.numberOfRounds else {
            game.endGame()
            performSegue(withIdentifier: "GameFinishedSegue", sender: game.points)
            return
        }
        
        events = game.pickRandomEvents(amount: 4)
        countdown.text = "1:00"
        updateLabels()
        game.timer = 20
        game.roundsPlayed += 1
        failButton.isHidden = true
        successButton.isHidden = true
        countdown.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector(("tick")), userInfo: nil, repeats: true)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if game.checkOrder(of: events) == true {
                successButton.isHidden = false
            } else {
                failButton.isHidden = false
            }
            timer?.invalidate()
            countdown.isHidden = true
        }
    }
    
    var timer: Timer?
    
    func tick() {
        
        game.timer -= 1
        
        if game.timer >= 10 {
            countdown.text = "0:\(game.timer)"
            
        } else if game.timer < 10 {
           countdown.text = "0:0\(game.timer)"
        }
        
        if game.timer <= 0 {
            timer?.invalidate()
            if game.checkOrder(of: events) == true {
                successButton.isHidden = false
            } else {
                failButton.isHidden = false
            }
            countdown.isHidden = true
            
            
            
            print("playedrounds: \(game.roundsPlayed)") // DEBUG
            
            print("points: \(game.points)") // DEBUG
            
            
        }
    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        newRound()
        
        successButton.isHidden = true
        failButton.isHidden = true
        
        // Load the sound for button press
        loadButtonPressedSound()
        
        // Update buttons with highlighted state
        firstEventDown.setImage(#imageLiteral(resourceName: "down_full_selected"), for: UIControlState.highlighted)
        secondEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        secondEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        thirdEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        thirdEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        fourthEventUp.setImage(#imageLiteral(resourceName: "up_full_selected.png"), for: UIControlState.highlighted)
        
        
        updateLabels() // run update on labels
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
