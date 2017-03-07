//
//  ViewController.swift
//  BoutTime
//
//  Created by Marcus Jepsen Klausen on 05/03/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
   
    
    @IBOutlet weak var firstEventDown: UIButton!
    @IBOutlet weak var secondEventUp: UIButton!
    @IBOutlet weak var secondEventDown: UIButton!
    @IBOutlet weak var thirdEventUp: UIButton!
    @IBOutlet weak var thirdEventDown: UIButton!
    @IBOutlet weak var fourthEventUp: UIButton!
    
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var upperMiddleLabel: UILabel!
    @IBOutlet weak var underMiddleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBAction func moveLowerMiddleUp(_ sender: Any) {
        moveUpperMiddleDown(Any.self)
    }
    @IBAction func moveUpperMiddleDown(_ sender: Any) {
        let tempEventTwo = eventTwo
        let tempEventThree = eventThree
        eventTwo = tempEventThree
        eventThree = tempEventTwo
        updateLabels()
    }
    
    @IBAction func moveUpperMiddleUp(_ sender: Any) {
        moveTopDown(Any.self)
    }
    
    @IBAction func moveTopDown(_ sender: Any) {
        let tempEventOne = eventOne
        let tempEventTwo = eventTwo
        eventOne = tempEventTwo
        eventTwo = tempEventOne
        updateLabels()
    }
    
    @IBAction func moveLowerMiddleDown(_ sender: Any) {
        moveBottomEventUp(Any.self)
    }
    
    
    @IBAction func moveBottomEventUp(_ sender: Any) {
        let tempEventFour = eventFour
        let tempEventThree = eventThree
        eventFour = tempEventThree
        eventThree = tempEventFour
        updateLabels()
    }
    
    
    
    let gameTopic: GameTopic
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let arrayOfDictionaries = try PlistImporter.importDictionaries(fromFile: "EventCollection", ofType: "plist")
            let collection = try CollectionUnarchiver.collection(fromArray: arrayOfDictionaries)
            self.gameTopic = GameTopic(eventCollection: collection)
            
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
        
    }
    
    
    //Place the correct event at the correct label
        func updateLabels() {
            
            topLabel.text = eventOne?.statement
            upperMiddleLabel.text = eventTwo?.statement
            underMiddleLabel.text = eventThree?.statement
            bottomLabel.text = eventFour?.statement
  }
    
    var events: [HistoricalEvent] = []
    var eventOne: HistoricalEvent?
    var eventTwo: HistoricalEvent?
    var eventThree: HistoricalEvent?
    var eventFour: HistoricalEvent?
    
    func initiateEvents() {
        events = gameTopic.pickRandomEvents(amount: 4)
        eventOne = events[0]
        eventTwo = events[1]
        eventThree = events[2]
        eventFour = events[3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        firstEventDown.setImage(#imageLiteral(resourceName: "down_full_selected"), for: UIControlState.highlighted)
        secondEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        secondEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        thirdEventUp.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: UIControlState.highlighted)
        thirdEventDown.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: UIControlState.highlighted)
        fourthEventUp.setImage(#imageLiteral(resourceName: "up_full_selected.png"), for: UIControlState.highlighted)
        
        initiateEvents()
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

