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
    
}
