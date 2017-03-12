//
//  HistoryGame.swift
//  BoutTime
//
//  Created by Marcus Jepsen Klausen on 05/03/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import Foundation
import GameKit
import AudioToolbox

// Initializing sounds
var button: SystemSoundID = 0

enum eventPosition: Int {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
}

protocol HistoricalEvent {
    var date: Date { get }
    var statement: String { get }
    var placement: eventPosition { get set }
}


protocol HistoricalGame {
    var eventCollection: [HistoricalEvent] { get set }
    var roundsPlayed: Int { get set }
    var numberOfRounds: Int { get }
    var timer: Int { get set }
    
    init(eventCollection: [HistoricalEvent])
    
    func pickRandomEvents(amount: Int) -> [HistoricalEvent]
    func nextRound(currentRound: Int)
    func endGame()
    func checkAnswer()
    
}

struct Event: HistoricalEvent {
    let date: Date
    let statement: String
    var placement: eventPosition
}

enum PlistImportError: Error {
    case invalidResource
    case conversionFailure
    case invalidSelection
}

class PlistImporter {
    static func importDictionaries(fromFile name: String, ofType type: String) throws -> [[String: AnyObject]] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistImportError.invalidResource
        }
        guard let arrayOfDictionaries = NSArray.init(contentsOfFile: path) as? [[String: AnyObject]] else {
            throw PlistImportError.conversionFailure
        }
        return arrayOfDictionaries
    }
}



class CollectionUnarchiver {
    static func collection(fromArray array: [[String: AnyObject]]) throws -> [HistoricalEvent] {
        
        var collection: [HistoricalEvent] = []
        
        for dictionary in array {
                if  let date = dictionary["date"] as? Date,
                    let statement = dictionary["statement"] as? String {
                        let event = Event(date: date, statement: statement, placement: eventPosition.first)
                        collection.append(event)
                    } else {
                        print("failed")
                    }
            
        }
        return collection
}
}




class GameTopic: HistoricalGame {
    var eventCollection: [HistoricalEvent]
    var roundsPlayed: Int = 0
    let numberOfRounds: Int = 6
    var timer: Int = 60
    
    required init(eventCollection: [HistoricalEvent]) {
        self.eventCollection = eventCollection
    }
    
    
    
    func pickRandomEvents(amount: Int) -> [HistoricalEvent] {
        var stagedEvents: [HistoricalEvent] = []
        var randomNumbersUsed: [Int] = []
        
        while stagedEvents.count < amount {
            let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: eventCollection.count)
            if randomNumbersUsed.contains(randomNumber) != true {
                stagedEvents.append(eventCollection[randomNumber])
                randomNumbersUsed.append(randomNumber)
            }
        
        }
        return stagedEvents
    }
    
    
    
    
    func nextRound(currentRound: Int) {}
    func endGame() {}
    func checkAnswer() {}
    
}

func loadButtonPressedSound() {
    let pathToSoundFile = Bundle.main.path(forResource: "button-3", ofType: ".wav")
    let soundURL = URL(fileURLWithPath: pathToSoundFile!)
    AudioServicesCreateSystemSoundID(soundURL as CFURL, &button)
}

func buttonPressedSound() {
    AudioServicesPlaySystemSound(button)
}
