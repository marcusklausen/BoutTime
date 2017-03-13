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
    
    // Interface builder outlet countdown
    @IBOutlet weak var countdown: UILabel!
    
    // Interface builder actions/functions
    @IBAction func moveLowerMiddleUp(_ sender: Any) {
        // Do the same as moveUpperMiddleDown
        moveUpperMiddleDown(Any.self)
    }
    @IBAction func moveUpperMiddleDown(_ sender: Any) {
        
        // Store temporary constants for swapping
        let tempEventTwo = eventTwo
        let tempEventThree = eventThree
        
        // Swap events
        eventTwo = tempEventThree
        eventThree = tempEventTwo
        
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
        let tempEventOne = eventOne
        let tempEventTwo = eventTwo
        eventOne = tempEventTwo
        eventTwo = tempEventOne
        updateLabels()
        buttonPressedSound()
    }
    @IBAction func moveLowerMiddleDown(_ sender: Any) {
        
        // Do the same as moveBottomEventUp
        moveBottomEventUp(Any.self)
    }
    @IBAction func moveBottomEventUp(_ sender: Any) {
        
        // Same concept as moveUpperMiddleDown
        let tempEventFour = eventFour
        let tempEventThree = eventThree
        eventFour = tempEventThree
        eventThree = tempEventFour
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
        topLabel.text = eventOne?.statement
        upperMiddleLabel.text = eventTwo?.statement
        underMiddleLabel.text = eventThree?.statement
        bottomLabel.text = eventFour?.statement
        
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let events = [eventOne, eventTwo, eventThree, eventFour]
            game.checkOrder(of: events as! [HistoricalEvent])
        }
    }
    
    
    // Creation of variables outside scope for global usage
    var events: [HistoricalEvent] = []
    var eventOne: HistoricalEvent?
    var eventTwo: HistoricalEvent?
    var eventThree: HistoricalEvent?
    var eventFour: HistoricalEvent?
    
    
    // Picks (amount) random events and assigns to global variables corresponding to each label position
    func initiateEvents() {
        events = game.pickRandomEvents(amount: 4)
        eventOne = events[0]
        eventTwo = events[1]
        eventThree = events[2]
        eventFour = events[3]
    }
    
    
    func tick() {
        game.timer -= 1
        countdown.text = "0:\(game.timer)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdown.text = "1:00"
        // Do any additional setup after loading the view, typically from a nib.
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.tick), userInfo: nil, repeats: true)
        
        
        
        
        
        // Load the sound for button press
        loadButtonPressedSound()
        
        // Update buttons with highlighted state
        firstEventDown.setImage(#imageLiteral(resourceName: "down_full_selected"), for: UIControlState.highlighted)
        secondEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        secondEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        thirdEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        thirdEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        fourthEventUp.setImage(#imageLiteral(resourceName: "up_full_selected.png"), for: UIControlState.highlighted)
        
        
        initiateEvents() // Pick events and assign to variables
        updateLabels() // run update on labels
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
