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
    
    
    @IBAction func moveBottomEventUp(_ sender: Any) {
        

        
        
        
        
        
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
    
    
    // Place the correct event at the correct label
    func updateLabels() {
        for event in events {
            switch event.placement {
            case .first:    topLabel.text           = event.statement; print(event.statement)
            case .second:   upperMiddleLabel.text   = event.statement; print(event.statement)
            case .third:    underMiddleLabel.text   = event.statement; print(event.statement)
            case .fourth:   bottomLabel.text        = event.statement
            }
            
        }
    }
    
    var events: [HistoricalEvent] = []
    func initiateEvents() {
        events = gameTopic.pickRandomEvents(amount: 4)
        events[0].placement = .first
        events[1].placement = .second
        events[2].placement = .third
        events[3].placement = .fourth
        
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

