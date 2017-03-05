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

enum EventCollectionError: Error {
    case invalidResource
    case conversionFailure
    case invalidSelection
}

class PlistConverter {
    static func dictionary(fromFile name: String, ofType type: String) throws -> [String: AnyObject] {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw EventCollectionError.invalidResource
        }
        
        guard let array = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw EventCollectionError.conversionFailure
        }
        
        return array
        
    }
}


class EventCollectionUnarchiver {
    static func eventCollection(fromArray array: [String: AnyObject]) throws -> [HistoricalEvent] {
        var collection: [HistoricalEvent] = []
        
        for (key, value) in collection {
            if  let eventCollection = value as? [String: Any],
                let date = evenCollection["]
        }
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
