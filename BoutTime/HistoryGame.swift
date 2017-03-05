//
//  HistoryGame.swift
//  BoutTime
//
//  Created by Marcus Jepsen Klausen on 05/03/2017.
//  Copyright © 2017 Marcus Jepsen Klausen. All rights reserved.
//

import Foundation


protocol HistoricalEvent {
    var date: Date { get }
    var statement: String { get }
    var placement: Int { get set }
}

protocol HistoricalGame {
    var eventCollection: [HistoricalEvent] { get set }
    var roundsPlayed: Int { get set }
    var numberOfRounds: Int { get }
    var timer: Int { get set }
    
    init(eventCollection: [HistoricalEvent])
    
    func nextRound(currentRound: Int)
    func endGame()
    func checkAnswer()
    
}

struct Event: HistoricalEvent {
    let date: Date
    let statement: String
    var placement: Int
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


class EventCollectionUnarchiver {
    static func eventCollection(fromArray array: [[String: AnyObject]]) throws -> [HistoricalEvent] {
        
        var collection: [HistoricalEvent] = []
        
        for dictionary in array {
            
            for (_, value) in dictionary {
                if  let eventCollection = value as? [String: Any],
                    let date = eventCollection["date"] as? Date,
                    let statement = eventCollection["statement"] as? String,
                    let placement = eventCollection["placement"] as? Int {
                    
                        let event = Event(date: date, statement: statement, placement: placement)
                        collection.append(event)
                    }
            }
        }
        return collection
    }
}



class GameTopic: HistoricalGame {
    var eventCollection: [HistoricalEvent] = []
    var roundsPlayed: Int = 0
    let numberOfRounds: Int = 6
    var timer: Int = 60
    
    required init(eventCollection: [HistoricalEvent]) {
        self.eventCollection = eventCollection
    }
    
    func nextRound(currentRound: Int) {}
    func endGame() {}
    func checkAnswer() {}
    
}
